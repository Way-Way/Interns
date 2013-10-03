<?php
include('include/open_db.php');

$xml = isset($_GET['xml']);

$deMatching = isset($_GET['deMatch']);
$reMatching = isset($_GET['reMatch']);
$saveMatches = isset($_GET['outputMatch']);
$savedeMatches = isset($_GET['outputdeMatch']);

 $city =  isset($_GET['city']) ? $_GET['city']: 'New York';
 $limit =  isset($_GET['limit']) ? $_GET['limit']: '1000';
 $offset =  isset($_GET['offset']) ? $_GET['offset']: '0';
 $radius =  isset($_GET['radius']) ? $_GET['radius']: '100';
 $theta1min =  isset($_GET['theta1min']) ? $_GET['theta1min']: '-1';
 $theta1max =  isset($_GET['theta1max']) ? $_GET['theta1max']: '1';
 $theta2min =  isset($_GET['theta2min']) ? $_GET['theta2min']: '-1';
 $theta2max =  isset($_GET['theta2max']) ? $_GET['theta2max']: '1';
 $theta3min =  isset($_GET['theta3min']) ? $_GET['theta3min']: '-1';
 $theta3max =  isset($_GET['theta3max']) ? $_GET['theta3max']: '1';
 $theta4min =  isset($_GET['theta4min']) ? $_GET['theta4min']: '-1';
 $theta4max =  isset($_GET['theta4max']) ? $_GET['theta4max']: '1';
$checkins =  isset($_GET['checkins']) ? $_GET['checkins']: '0';


?>
<meta http-equiv="content-type" content = "text/html ; charset =utf-8" />
<html>
<head>
<title> TROUBLESHOOTING - NY SAMPLE </title>
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

if (!$saveMatches && !$savedeMatches)
{

// user inputs the parameters for deMatching

$formOutput = "";

    $formOutput .= "<form method=GET  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutput .= "<input name=deMatch value=plop type=hidden /><br>\n";
    $formOutput .= "City <select name=city >".buildChoiceList($listCities, $city)."</select><br>\n";
    $formOutput .= "Number of places to troubleshoot <input name=limit value='".$limit."'  /> <br>\n";
    $formOutput .= "Offset <input name=offset value='".$offset."'  /> <br>\n";
//  $formOutput .= "Minimum checkins of main place <input name=checkins value='".$checkins."'  /> <br>\n";
//   $formOutput .= "Look in Radius larger than <input name=radius value='".$radius."' meters  /> <br>\n";
    $formOutput .= " <input name=theta1min value='".$theta1min."'  /> < Theta name < <input name=theta1max value='".$theta1max."'  /> <br>\n";
    $formOutput .= " <input name=theta2min value='".$theta2min."'  /> < Theta address < <input name=theta2max value='".$theta2max."'  /> <br>\n";
    $formOutput .= " <input name=theta3min value='".$theta3min."'  /> < Theta phone < <input name=theta3max value='".$theta3max."'  /> <br>\n";
    $formOutput .= " <input name=theta4min value='".$theta4min."'  /> < Theta web < <input name=theta4max value='".$theta4max."'  /> <br>\n";
    $formOutput .= "<input type=submit value=deMatch  ><br>";
    $formOutput .= "</form><br>\n";


echo $formOutput;


// form for reMatching

$formOutput = "";

    $formOutput .= "<form method=GET  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutput .= "<input name=reMatch value=plop type=hidden /><br>\n";
    $formOutput .= "City <select name=city >".buildChoiceList($listCities, $city)."</select><br>\n";
    $formOutput .= "Number of places to troubleshoot <input name=limit value='".$limit."'  /> <br>\n";
    $formOutput .= "Offset <input name=offset value='".$offset."'  /> <br>\n";
//  $formOutput .= "Minimum checkins of main place <input name=checkins value='".$checkins."'  /> <br>\n";
    $formOutput .= "Look in Radius smaller than <input name=radius value='".$radius."' meters  /> <br>\n";
    $formOutput .= " <input name=theta1min value='".$theta1min."'  /> < Theta name < <input name=theta1max value='".$theta1max."'  /> <br>\n";
    $formOutput .= " <input name=theta2min value='".$theta2min."'  /> < Theta address < <input name=theta2max value='".$theta2max."'  /> <br>\n";
    $formOutput .= " <input name=theta3min value='".$theta3min."'  /> < Theta phone < <input name=theta3max value='".$theta3max."'  /> <br>\n";
    $formOutput .= " <input name=theta4min value='".$theta4min."'  /> < Theta web < <input name=theta4max value='".$theta4max."'  /> <br>\n";
    $formOutput .= "<input type=submit value=reMatch  ><br>";
    $formOutput .= "</form><br>\n";


echo $formOutput;

 }

// That's where all the code for updating the db on manual matching goes

if ($saveMatches)
{
  // echo 'hi';
$letsmatch = isset($_GET['matchTwo']);
$match = $letsmatch ? $_GET['matchTwo'] : "";
// echo $match;
$pattern = "/[-]/";

  if (preg_match($pattern,$match))
{ 
  //  echo '<b>'.$match.'</b> is a valid name.<br />';
$keywords = preg_split($pattern, $match);
// print_r($keywords);
$id1 = $keywords[0];
$id2 = $keywords[1];

$sqlManualMatch = "update distances 
set manually_matched = 1
where place_id_1 in (". $id1 .", ". $id2 .")
and place_id_2 in (". $id1 .", ". $id2 .")
and place_id_2 <> place_id_1 ;";


//echo $sqlManualMatch;

 $result = mysql_query($sqlManualMatch) or die('Échec de la requête : ' . mysql_error()). $sqlManualMatch;
  echo "we matched ". $id1 . " and " . $id2 ." manually";
}

else { 
    echo '<b>'.$match.'</b> is not a valid name.<br />';
  }
  }







// This is manual deMatching



if ($savedeMatches)
{
  // echo 'hi';
$letsdematch = isset($_GET['dematchTwo']);
$dematch = $letsdematch ? $_GET['dematchTwo'] : "";
// echo $match;
$pattern = "/[-]/";

  if (preg_match($pattern,$dematch))
{ 
  //  echo '<b>'.$dematch.'</b> is a valid name.<br />';
$keywords = preg_split($pattern, $dematch);
// print_r($keywords);
$id1 = $keywords[0];
$id2 = $keywords[1];

$sqlManualdeMatch = "update distances 
set manually_matched = -1
where place_id_1 in (". $id1 .", ". $id2 .")
and place_id_2 in (". $id1 .", ". $id2 .")
and place_id_2 <> place_id_1 ;";


//echo $sqlManualdeMatch;

 $result = mysql_query($sqlManualdeMatch) or die('Échec de la requête : ' . mysql_error()). $sqlManualdeMatch;
  echo "we dematched ". $id1 . " and " . $id2 ." manually";
}

else { 
    echo '<b>'.$dematch.'</b> is not a valid name.<br />';
  }
  }


















// First look at what happens if we want to be doing deMatching ///////////////////////////////////////////////////////////////////////////////////////

if ($deMatching)

  { 

    echo "So let's deMatch";

$sqlgetPlaces = "select distinct d.place_id_1, s.place_id, s.sourcename, s.source_id, s.name, s.address, s.city, m.value, des.phone, des.website, s.count
from distances as d,
metrics as m,
metric_headers as mh,
descriptions as des,
NY_sample as s
where (d.matched = 1 or d.manually_matched = 1)
and d.place_id_1 = mh.place_id
and des.place_id = s.place_id
and s.place_id = mh.place_id
and m.metric_header_id = mh.metric_header_id
and s.city = '" . $city . "' 
and mh.metric_id = 1
and m.value >= '". $checkins ."'
and m.timestamp = (select max(mm.timestamp) FROM metrics mm 
WHERE mm.metric_header_id = mh.metric_header_id)
order by -m.value
limit " . $limit ."
offset " . $offset . " 
;";

      
// echo "$sqlgetPlaces <br>\n";

      $resultPlaces = mysql_query($sqlgetPlaces) or die('Échec de la requête : ' . mysql_error()). $sqlgetPlaces;
// echo $resultPlaces;


echo "<table border='1' cellpadding='5'>";
//echo "<tr> <th> place_id </th>";
//echo "<th> omb_place_id </th> ";
echo "<th> name </th> 
<th> address </th>
<th> phone </th>
<th> website </th>
 <th> city </th> 
<th> checkins </th>
<th> photos </th>
 <th> distance </th>
<th> th_name </th> 
<th> th_address </th> 
<th> th_phone </th> 
<th> th_web </th> 
<th> should we dematch? </th>
  ";


 while ($array = mysql_fetch_row($resultPlaces))

 {
	$PlaceIdmain = $array[0]; 
	$sourcename = $array[2]; 
	$sourceidmain = $array[3]; 
	$name = $array[4];
	$address = $array[5]; 
	$city = $array[6]; 
	$value =  $array[7]; 
$phonemain =  $array[8]; 
$webmain =  $array[9]; 
$countphotos =  $array[10]; 


  $sqlGetMatches = "select p.place_id, p.sourcename, p.source_id, p.name, p.address, p.city, round(d.soft_tfidf,2), round(d.address,2), round(d.phone,2), round(d.website,2), d.geo, m.value, des.phone, des.website
from places as p,
places as pmain,
distances as d,
metrics as m,
metric_headers as mh,
descriptions as des
where d.place_id_1 = p.place_id
and des.place_id = p.place_id
and d.place_id_2 = pmain.place_id
and (d.matched, d.manually_matched) in ((1,0), (1,1), (0,1))
and p.place_id <> pmain.place_id
and pmain.place_id = '" . $PlaceIdmain . "'
and d.soft_tfidf >= '" . $theta1min ."'
and d.soft_tfidf <=  '" . $theta1max ."' 
and d.address >= '" . $theta2min ."'
and d.address <= '" . $theta2max ."' 
and d.phone >= '" . $theta3min ."'
and d.phone <= '" . $theta3max ."' 
and d.website >= '" . $theta4min ."'
and d.website <= '" . $theta4max ."' 
and p.place_id = mh.place_id
and m.metric_header_id = mh.metric_header_id
and mh.metric_id = 1 
and m.timestamp = (select max(mm.timestamp) FROM metrics mm 
WHERE mm.metric_header_id = mh.metric_header_id)
order by d.geo;";  

 
      $resultGetMatches = mysql_query($sqlGetMatches) or die('Échec de la requête : ' . mysql_error()). $sqlGetMatches;


if(mysql_num_rows($resultGetMatches) > 0)
{

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
echo '<td>'. $countphotos .' </td>';
echo ' <th> distance </th>
 <th> th_name </th> 
<th> th_address </th> 
<th> th_phone </th> 
<th> th_web </th> 
<th> should we dematch? </th>';

            echo "</tr>"; 


 while ($row = mysql_fetch_row($resultGetMatches))  
   { 


$sourceid = $row[2];

$placeId = $row[0];

$formOutputdeMatch = "";

    $formOutputdeMatch .= "<form method=GET  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutputdeMatch .= "<input name=outputdeMatch value=plop type=hidden /><br>\n";
    // $formOutputdeMatch .= " <input type='checkbox' name=dematchTwo value=$placeId-$PlaceIdmain  /> deMatch <br>";
$formOutputdeMatch .= "<input type=submit name=dematchTwo value=$placeId-$PlaceIdmain  > deMatch <br>";
    //  $formOutputdeMatch .= "<input type=submit value=save  ><br>";
    $formOutputdeMatch .= "</form><br>\n";




 if ($row[1] == 'Facebook')
      {$sourceURL = "<a href='http://www.facebook.com/$sourceid'> (FB)"; }  else  {$sourceURL = " <a href='http://www.foursquare.com/v/$sourceid'> (4sq)"; }   
            echo "<tr>";
	    //	    echo '<td>' . $row[0] . '</td>';
	    //	    echo '<td>' . $row[9] . '</td>';
            echo '<td> <b>' . $row[3] . $sourceURL . '</b> </td>';
	    echo '<td>' . $row[4] . '</td>';
 echo '<td>' . $row[12] . '</td>';
 echo '<td>' . $row[13] . '</td>';
            echo '<td>' . $row[5] . '</td>';
echo '<td>'. $row[11] . '</td>';
echo '<td> </td>';
echo '<td>' . $row[10] . '</td>';
            echo '<td>' . $row[6] . '</td>';
echo '<td>' . $row[7] . '</td>';
echo '<td>' . $row[8] . '</td>';
echo '<td>' . $row[9] . '</td>';
echo '<td>' . $formOutputdeMatch . '</td>';

            echo "</tr>"; 
    } 


} 

 } 

}


// Then look at what happens if we want to be doing reMatching ///////////////////////////////////////////////////////////////////////////////////////

if ($reMatching)

  { 

    echo "So let's reMatch";


$sqlgetAllPlaces = "select p.place_id, p.sourcename, p.source_id, p.name, p.address, p.city, m.value, des.phone, des.website
from metrics as m,
metric_headers as mh,
places as p,
descriptions as des,
NY_sample as s
where p.place_id = mh.place_id
and s.place_id = p.place_id
and des.place_id = p.place_id
and m.metric_header_id = mh.metric_header_id
and p.city = '" . $city . "' 
and mh.metric_id = 1
and m.value >= '". $checkins ."'
 and m.timestamp = (select max(mm.timestamp) FROM metrics mm 
WHERE mm.metric_header_id = mh.metric_header_id)
  order by -m.value
limit " . $limit ."
offset " . $offset . " 
;";

     
 echo "$sqlgetAllPlaces <br>\n";

      $resultAllPlaces = mysql_query($sqlgetAllPlaces) or die('Échec de la requête : ' . mysql_error()). $sqlgetAllPlaces;
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
 <th> distance </th>
<th> th_name </th> 
<th> th_address </th> 
<th> th_phone </th> 
<th> th_web </th> 
<th> should we match? </th>
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


  $sqlGetnonMatches = "select p.place_id, p.sourcename, p.source_id, p.name, p.address, p.city, round(d.soft_tfidf,2), round(d.address,2), round(d.phone,2), round(d.website,2), d.geo, m.value, des.phone, des.website
from places as p,
places as pmain,
distances as d,
metrics as m,
metric_headers as mh, 
descriptions as des
where d.place_id_1 = p.place_id
and des.place_id = p.place_id
and d.place_id_2 = pmain.place_id
and (d.matched, d.manually_matched) in ((0,0),(1,-1),(0,-1))
and p.place_id <> pmain.place_id
and pmain.place_id = '" . $PlaceIdmain . "'
and d.soft_tfidf >= '" . $theta1min ."'
and d.soft_tfidf <=  '" . $theta1max ."' 
and d.address >= '" . $theta2min ."'
and d.address <= '" . $theta2max ."' 
and d.phone >= '" . $theta3min ."'
and d.phone <= '" . $theta3max ."' 
and d.website >= '" . $theta4min ."'
and d.website <= '" . $theta4max ."' 
and p.place_id = mh.place_id
and m.metric_header_id = mh.metric_header_id
and mh.metric_id = 1 
and m.timestamp = (select max(mm.timestamp) FROM metrics mm 
WHERE mm.metric_header_id = mh.metric_header_id)
and d.geo <= '" . $radius ."' 
order by d.geo;";

   
      $resultGetnonMatches = mysql_query($sqlGetnonMatches) or die('Échec de la requête : ' . mysql_error()). $sqlGetnonMatches;
      //  echo "<br>\n";

if(mysql_num_rows($resultGetnonMatches) > 0)
{

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
            echo ' <th> distance </th>
<th> th_name </th> 
<th> th_address </th> 
<th> th_phone </th> 
<th> th_web </th> 
<th> should we match? </th>';

            echo "</tr>"; 


 while ($row = mysql_fetch_row($resultGetnonMatches))  
   { 

$placeId = $row[0];

$formOutputMatch = "";

    $formOutputMatch .= "<form method=GET  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutputMatch .= "<input name=outputMatch value=plop type=hidden /><br>\n";
    //    $formOutputMatch .= " <input type='checkbox' name=matchTwo value=$placeId-$PlaceIdmain  /> Match <br>";
     $formOutputMatch .= "<input type=submit name=matchTwo value=$placeId-$PlaceIdmain > Match <br>";
     //  $formOutputMatch .= "<input type=submit value=save  ><br>";
    $formOutputMatch .= "</form><br>\n";



$sourceid = $row[2];
 if ($row[1] == 'Facebook')
      {$sourceURL = "<a href='http://www.facebook.com/$sourceid'> (FB)"; }  else  {$sourceURL = " <a href='http://www.foursquare.com/v/$sourceid'> (4sq)"; }   
            echo "<tr>";
	    //	    echo '<td>' . $row[0] . '</td>';
	    //	    echo '<td>' . $row[9] . '</td>';
            echo '<td> <b>' . $row[3] . $sourceURL . '</b> </td>';
	    echo '<td>' . $row[4] . '</td>';
  echo '<td>' . $row[12] . '</td>';
  echo '<td>' . $row[13] . '</td>';

            echo '<td>' . $row[5] . '</td>';
echo '<td>'. $row[11] . '</td>';
echo '<td>' . $row[10] . '</td>';
            echo '<td>' . $row[6] . '</td>';
echo '<td>' . $row[7] . '</td>';
echo '<td>' . $row[8] . '</td>';
echo '<td>' . $row[9] . '</td>';
echo '<td>' . $formOutputMatch .'</td>';

            echo "</tr>"; 
    } 


}
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
