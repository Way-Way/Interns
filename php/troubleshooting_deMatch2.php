<?php
include('include/open_db.php');

$xml = isset($_GET['xml']);

$studyMatches = isset($_GET['deMatch']);

 $city =  isset($_GET['city']) ? $_GET['city']: 'New York';
// $area =  isset($_GET['area']) ? $_GET['area']: 'Manhattan';
 $limit =  isset($_GET['limit']) ? $_GET['limit']: '10';
 $offset =  isset($_GET['offset']) ? $_GET['offset']: '0';
 $radius =  isset($_GET['radius']) ? $_GET['radius']: '0';
 $theta =  isset($_GET['theta']) ? $_GET['theta']: '1';
 $checkins =  isset($_GET['checkins']) ? $_GET['checkins']: '0';


$getAllMetrics = !$studyMatches;

/* Page functionalities:

- deMatch indicates that we want to look at the "places" that have been matched in the same "omb_place"
- the value of "deMatch" is the number of omb_places we want to look at. By default we look at the list of omb_places in order of their omb_place_id
- the offset enables us to access omb_places with larger omb_place_ids
- in city, indicate the city you want to study!

example of url: path_to_the_page/troubleshooting_all.php?deMatch=6&offset=1&city=Chicago

 */


?>
<meta http-equiv="content-type" content = "text/html ; charset =utf-8" />
<html>
<head>
<title>TROUBLESHOOTING - deMatching</title>
</head>
<body>
<br>
<?php

$html = "Let's look at omb_places that have matched ";
echo $html; $html="";

 
    // Retrieving the list of cities and areas in our database and storing them inside $listCity and $listArea

//  $sqlSelectCities = "SELECT DISTINCT `city` FROM `cities`; ";
    $sqlSelectCities = "SELECT DISTINCT city FROM places; ";

//    echo $sqlSelectCities."<br>\n";

    $result = mysql_query($sqlSelectCities) or die('Échec de la requête : ' . mysql_error());

    $listCities = Array();
    while ($array = mysql_fetch_row($result))
    {
        if ($array[0] != "")
        {
            array_push($listCities, $array[0]);
        }
    }

// print_r($listCities);

   $sqlSelectAreas = "SELECT DISTINCT area FROM cities where area not in (select distinct city from cities); ";
    $result = mysql_query($sqlSelectAreas) or die('Échec de la requête : ' . mysql_error());

    $listAreas = Array();
    while ($array = mysql_fetch_row($result))
    {
        if ($array[0] != "")
        {
            array_push($listAreas, $array[0]);
        }
    }

//print_r($listAreas);

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




// User inputs the parameters

$formOutput = "";

    $formOutput .= "<form method=GET  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutput .= "<input name=deMatch value=plop type=hidden /><br>\n";
    $formOutput .= "City <select name=city > < option value = '".buildChoiceList($listCities, $city)."'> </option> </select><br>\n";
//   $formOutput .= "Area <select name=area > '".buildChoiceList($listAreas, $area)."' </select><br>\n";
    $formOutput .= "Number of omb_places to troubleshoot <input name=limit value='".$limit."'  /> <br>\n";
    $formOutput .= "Offset <input name=offset value='".$offset."'  /> <br>\n";
    $formOutput .= "Only look at places for which most popular FB or 4sq place have at least <input name=checkins value='".$checkins."' checkins /> <br>\n";
    $formOutput .= "Only look at matches in radius (m) greater than <input name=radius value='".$radius."'  /> <br>\n";
    $formOutput .= "Only look at matches where theta (threshold for name similarity) smaller than <input name=theta value='".$theta."'  /> <br>\n";
    $formOutput .= "<input type=submit value=study  ><br>";
    $formOutput .= "</form><br>\n";


echo $formOutput;


 




if ($studyMatches)

{


/*
first version, without indicating the city
  {
    $sqlgetMatchedOmbPlaces = "SELECT temp.omb_place FROM 
(SELECT count(*) AS matches, omb_place_id AS omb_place FROM equivalence_table GROUP BY omb_place_id) AS temp 
WHERE matches>1
ORDER BY omb_place
limit " . $limit ."
offset " . $offset . " ;";
      }
 */

    $sqlgetMatchedOmbPlaces = "
SELECT distinct temp.omb_place FROM 
(SELECT count(*) AS matches, omb_place_id AS omb_place 
FROM equivalence_table GROUP BY omb_place_id) AS temp,
omb_places as op,".
//omb_descriptions as od,
"places as p,
equivalence_table as e
WHERE matches>1
and op.omb_place_id = temp.omb_place
and p.place_id = e.place_id
and op.omb_place_id = e.omb_place_id
and op.omb_place_id = e.omb_place_id ".
      //and od.omb_place_id = op.omb_place_id
      //and od.area in (select id from omb_search where value = '" . $area . "')
"and p.city = '" . $city .
"' order by omb_place
limit " . $limit ."
offset " . $offset . " ;";
      }  
// echo "$sqlgetMatchedOmbPlaces <br>\n";

      $resultMatchedOmbPlaces = mysql_query($sqlgetMatchedOmbPlaces) or die('Échec de la requête : ' . mysql_error()). $sqlgetMatchedOmbPlaces;
// echo $resultMatchedOmbPlaces;
 while ($array = mysql_fetch_row($resultMatchedOmbPlaces))
    {
	$OmbPlaceId = $array[0];

	 echo "<br/> Omb Place = $OmbPlaceId <br>\n <br/>";

{
	$sqlSelectMainPlace = "SELECT e.omb_place_id, mh.place_id, m.value, p.sourcename, p.name, p.latitude, p.longitude FROM metrics as m, metric_headers as mh, equivalence_table as e, places as p
WHERE p.place_id = mh.place_id
and m.metric_header_id = mh.metric_header_id
and mh.place_id = e.place_id
and mh.metric_id = 1
and e.omb_place_id = '" . $OmbPlaceId . "' 
and m.value >= '". $checkins."' 
and m.timestamp = (select max(mm.timestamp) FROM metrics mm 
WHERE mm.metric_header_id = mh.metric_header_id) 
order by p.sourcename,-m.value
limit 1;";
    }
    $resultMainPlace = mysql_query($sqlSelectMainPlace) or die('Échec de la requête : ' . mysql_error()). $sqlSelectMainPlace;

if(mysql_num_rows($resultMainPlace) > 0)
{

    while ($array = mysql_fetch_row($resultMainPlace))
    {
	$mainombId = $array[0];
	$mainplaceId = $array[1];
    	$mainvalue = $array[2];
	$mainsource = $array[3];
	$mainname = $array[4];
	$mainlatitude = $array[5];
	$mainlongitude = $array[6];

    {
    	$sqlSelectMatchedPlaces = "SELECT e.omb_place_id, mh.place_id, m.value, p.source_id, p.sourcename, p.name, p.address, p.city, round(50000*sqrt((p.latitude- '" . $mainlatitude . "') * (p.latitude- '" . $mainlatitude . "')+ (p.longitude- '" . $mainlongitude . "')*(p.longitude- '" . $mainlongitude . "')))
FROM metrics as m, metric_headers as mh, equivalence_table as e, places as p
WHERE p.place_id = mh.place_id
and m.metric_header_id = mh.metric_header_id
and mh.place_id = e.place_id
and mh.metric_id = 1
and e.omb_place_id = '" . $OmbPlaceId . "' 
and round(50000*sqrt((p.latitude- '" . $mainlatitude . "') * (p.latitude- '" . $mainlatitude . "')+ (p.longitude- '" . $mainlongitude . "')*(p.longitude- '" . $mainlongitude . "'))) >= " . $radius ." or p.place_id = ". $mainplaceId ." 
and m.timestamp = (select max(mm.timestamp) FROM metrics mm 
WHERE mm.metric_header_id = mh.metric_header_id) 
order by p.sourcename,-m.value;";
    }
    $resultMatchedPlaces = mysql_query($sqlSelectMatchedPlaces) or die('Échec de la requête : ' . mysql_error()). $sqlSelectMatchedPlaces;


echo "<table border='1' cellpadding='5'>";
    echo "<tr> <th> name </th> <th> address </th> <th> city </th> <th> distance (m) </th> <th> theta </th> <th> checkins </th>";

    while($row = mysql_fetch_array( $resultMatchedPlaces )) { 

	$sourceid = $row[3];
	$sourcename = $row[4];

if ($sourcename == 'Facebook') {$sourceURL = "<a href='http://www.facebook.com/$sourceid'> (FB)"; }  else  {$sourceURL = " <a href='http://www.foursquare.com/v/$sourceid'> (4sq)"; }

            echo "<tr>";
	    echo "<td> <b>" . $row[5] . $sourceURL. "</b> </td>";
            echo '<td>' . $row[6] . '</td>';
	    echo '<td>' . $row[7] . '</td>';
            echo '<td>' . $row[8] . '</td>';
	    // echo '<td>' . $row[9] . '</td>';
            echo '<td>' . $row[2] . '</td>';
            echo "</tr>"; 
    } 

    echo "</table>";



$html .= "<br>\n";
$html .= "<br>\n";
   }
 }
}


$html .= "<br>\n";

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
