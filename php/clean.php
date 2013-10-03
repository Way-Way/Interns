<?php
include('include/open_db.php');

$xml = isset($_GET['xml']);

$cleaning = isset($_GET['outputclean']);
$cleaningOne = isset($_GET['outputcleanOne']);

$ombplaceid = isset($_GET['omb_place_id']) ? $_GET['omb_place_id']: "";
 $city =  isset($_GET['city']) ? $_GET['city']: "";
 $limit =  isset($_GET['limit']) ? $_GET['limit']: '10';
 $offset =  isset($_GET['offset']) ? $_GET['offset']: '0';
$checkins =  isset($_GET['checkins']) ? $_GET['checkins']: '0';

$lat = isset($_GET['lat']) ? $_GET['lat'] : 0;
$long = isset($_GET['long']) ? $_GET['long'] : 0;
$meters = isset($_GET['meters']) ? $_GET['meters'] : 0;


$condLoc = "";
if ($lat != 0. && $long != 0. && $meters != 0.)
{
    $condLoc = " AND ";
    $condLoc .= " ((p.latitude - ".$lat.") * (p.latitude - ".$lat.") + (p.longitude - ".$long.") * (p.longitude - ".$long.")) < " . ($meters * $meters / 1e10)  . " ";

   echo $condLoc . "<br>\n";
}

?>
<meta http-equiv="content-type" content = "text/html ; charset =utf-8" />
<html>
<head>
<title> CLEANING </title>
<script language="javascript" SRC="script/md5.js"></script>
</head>
<body>
<br>
<?php

$html = "Let's look at a couple of places <br />";

 
    // Retrieving the list of cities and areas in our database and storing them inside $listCity and $listArea

    $sqlSelectCities = "SELECT DISTINCT `city` FROM `places`; ";

    $result = mysql_query($sqlSelectCities) or die('Échec de la requête : ' . mysql_error());

    $listCities = Array();
    while ($array = mysql_fetch_row($result))
    {
        if ($array[0] != "")
        {
            array_push($listCities, $array[0]);
        }
    }

echo $html; $html = "";


// Function used when user inputs his choices
function buildChoiceList($listUser, $selectedUser)
{
    $choiceList = "";
    for ($i = 0; $i < count($listUser); $i++)
    {
    	//echo " selectedUser :  " . $selectedUser."  listUser ".$listUser[$i]."<br>\n";
        $choiceList .= "<option value= '".$listUser[$i]."' " .($selectedUser == $listUser[$i] ? "selected" : "")."  >".$listUser[$i]."</option>\n";
    }

    return $choiceList;
}

{


$formOutput = "";

    $formOutput .= "<form method=GET  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutput .= "<input name=outputclean value=plop type=hidden /><br>\n";
    $formOutput .= "City <select name=city >".buildChoiceList($listCities, $city)."</select><br>\n";
    $formOutput .= "Number of places to clean <input name=limit value='".$limit."'  /> <br>\n";
    $formOutput .= "Offset <input name=offset value='".$offset."'  /> <br>\n";
//  $formOutput .= "Minimum checkins of main place <input name=checkins value='".$checkins."'  /> <br>\n";
 $formOutput .= "Center your search around latitude <input name=lat value='".$lat."'  /> longitude <input name=long value='".$long."'  /> and in circle of <input name=meters value='".$meters."'  /> meters <br>\n";
    $formOutput .= "<input type=submit value=clean  ><br>";
    $formOutput .= "</form><br>\n";


echo $formOutput;

 }

// That's where all the code for updating the db on manual cleaning goes

if ($cleaningOne)
{
  // echo 'hi';
$letsclean = isset($_GET['cleanOne']);
$cleanid = $letsclean ? $_GET['cleanOne'] : "";
$sqlManualClean = "update descriptions 
set to_keep = 0
where place_id =". $cleanid . ";";


$result = mysql_query($sqlManualClean) or die('Échec de la requête : ' . mysql_error()). $sqlManualClean;
  echo "we cleaned place ". $cleanid . " from the db";
}
 



// Then look at what happens if we want to be doing cleaning ///////////////////////////////////////////////////////////////////////////////////////

if ($cleaning)

  { 

    echo "So let's clean";


if (isset($_GET['omb_place_id']))

 { $sqlgetAllKeptPlaces = "select p.place_id, p.sourcename, p.source_id, p.name, p.address, p.city, m.value, des.phone, des.website
from metrics as m,
metric_headers as mh,
places as p,
descriptions as des,
equivalence_table as eq
where p.place_id = mh.place_id
and des.place_id = p.place_id
and des.to_keep = 1
and m.metric_header_id = mh.metric_header_id
and mh.metric_id = 1
and eq.place_id = p.place_id
and eq.omb_place_id = ". $ombplaceid ."
and m.timestamp = (select max(mm.timestamp) FROM metrics mm 
WHERE mm.metric_header_id = mh.metric_header_id) ".
 "order by -m.value
;";

  }
else 
 { 

$sqlgetAllKeptPlaces = "select p.place_id, p.sourcename, p.source_id, p.name, p.address, p.city, m.value, des.phone, des.website
from metrics as m,
metric_headers as mh,
places as p,
descriptions as des
where p.place_id = mh.place_id
and des.place_id = p.place_id
and des.to_keep = 1
and m.metric_header_id = mh.metric_header_id ".
($city == "" ? "" : " and p.city = '" . $city . "' ").
" and mh.metric_id = 1
and m.value >= '". $checkins ."'"
. $condLoc
. " and m.timestamp = (select max(mm.timestamp) FROM metrics mm 
WHERE mm.metric_header_id = mh.metric_header_id) ".
 "order by -m.value ".
"limit " . $limit ."
offset " . $offset . " 
;";
  }
     
 echo "$sqlgetAllKeptPlaces <br>\n";

      $resultAllPlaces = mysql_query($sqlgetAllKeptPlaces) or die('Échec de la requête : ' . mysql_error()). $sqlgetAllKeptPlaces;
      // echo $resultAllPlaces;


echo "<table border='1' cellpadding='5'>";
//echo "<tr> <th> place_id </th>";
//echo "<th> omb_place_id </th> ";
echo "<th> name </th> 
<th> address </th>
<th> phone </th>
<th> website </th>
 <th> city </th> 
<th> checkins </th>
<th> should we erase? </th>
  ";


 while ($array = mysql_fetch_row($resultAllPlaces))

 {
	$PlaceIdmain = $array[0]; 
	$sourcename = $array[1]; 
	$sourceidmain = $array[2]; 
	$name = $array[3];
	$address = $array[4]; 
	$city = $array[5]; 
	$value =  $array[6]; 
	$phonemain =  $array[7]; 
	$webmain =  $array[8]; 




$formOutputClean = "";

    $formOutputClean .= "<form method=GET  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutputClean .= "<input name=outputcleanOne value=plop type=hidden /><br>\n";
     $formOutputClean .= "<input type=submit name=cleanOne value=$PlaceIdmain > Delete <br>";
    $formOutputClean .= "</form><br>\n";
 

    if ($sourcename == 'Facebook')

      {$mainsourceURL = "<a href='http://www.facebook.com/$sourceidmain'> (FB)"; }  else  {$mainsourceURL = " <a href='http://www.foursquare.com/v/$sourceidmain'> (4sq)"; } 

 echo "<tr style='background-color:lightblue;' >";
 //    echo '<td>'. $PlaceIdmain .' </td>';
 //	    echo '<td>'. $ombid .'</td>';
            echo '<td> <b>'. $name . $mainsourceURL . '</b> </td>';
	    echo '<td>'. $address.' </td>';
echo '<td>'. $phonemain.' </td>';
echo '<td>'. $webmain.' </td>';
            echo '<td>'. $city.' </td>';
echo '<td>'. $value .' </td>';
echo '<th>'. $formOutputClean .' </th>';

            echo "</tr>"; 

}
  }


if (!$xml)
{
    echo $html;
}

?>
</body>
</html>
<?php
include('include/close_db.php');
?>
