<?php
include('include/open_db.php');

$xml = isset($_GET['xml']);

$studyMatches = isset($_GET['deMatch']);

 $city =  isset($_GET['city']) ? $_GET['city']: 'New York';
 $area =  isset($_GET['area']) ? $_GET['area']: 'Manhattan';
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
<title>TROUBLESHOOTING - deMatching 2by2 </title>
</head>
<body>
<br>
<?php

$html = "Let's do some deMatching 2 by 2 ";
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

// print_r($listAreas);

echo $html; $html = "";


// Function used when user inputs his choices
function buildChoiceList($listUser, $selectedUser)
{
    $choiceList = "";
    for ($i = 0; $i < count($listUser); $i++)
    {
    	//echo " selectedUser :  " . $selectedUser."  listUser ".$listUser[$i]."<br>\n";
        $choiceList .= "<option value= '".$listUser[$i]."' " .($selectedUser == $listUser[$i] ? "selected" : "")."  >".$listUser[$i]." </option>\n";
    }

    return $choiceList;
}




// User inputs the parameters

$formOutput = "";

    $formOutput .= "<form method=GET  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutput .= "<input name=deMatch value=plop type=hidden /><br>\n";
    $formOutput .= "City <select name=city > < option value = ".buildChoiceList($listCities, $city)."> </option> </select><br>\n";
//  $formOutput .= "Area <select name=area > '".buildChoiceList($listAreas, $area)."' </select><br>\n";
    $formOutput .= "Number of omb_places to troubleshoot <input name=limit value='".$limit."'  /> <br>\n";
    $formOutput .= "Offset <input name=offset value='".$offset."'  /> <br>\n";
    $formOutput .= "Only look at places with at least <input name=checkins value='".$checkins."' checkins /> <br>\n";
    $formOutput .= "Only look at matches in radius (m) greater than <input name=radius value='".$radius."'  /> <br>\n";
    $formOutput .= "Only look at matches where theta (threshold for name similarity) smaller than <input name=theta value='".$theta."'  /> <br>\n";
    $formOutput .= "<input type=submit value=study  ><br>";
    $formOutput .= "</form><br>\n";


echo $formOutput;
// echo $city;

 




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
omb_places as op,
places as p,
equivalence_table as e
WHERE matches>1
and op.omb_place_id = temp.omb_place
and p.place_id = e.place_id
and op.omb_place_id = e.omb_place_id
and op.omb_place_id = e.omb_place_id
and p.city = '" . $city .
"' order by omb_place
limit " . $limit ."
offset " . $offset . " ;";
      }  
//echo "$sqlgetMatchedOmbPlaces <br>\n";

      $resultMatchedOmbPlaces = mysql_query($sqlgetMatchedOmbPlaces) or die('Échec de la requête : ' . mysql_error()). $sqlgetMatchedOmbPlaces;
//echo $resultMatchedOmbPlaces;
 while ($array = mysql_fetch_row($resultMatchedOmbPlaces))
    {
	$OmbPlaceId = $array[0];

	 echo "<br/> Omb Place = $OmbPlaceId <br>\n <br/>";

{
	$sqlselectCouples = "SELECT e1.omb_place_id, mh1.place_id, m1.value, p1.sourcename, p1.name, p1.source_id,
e2.omb_place_id, mh2.place_id, m2.value, p2.sourcename, p2.name, p2.source_id, p1.address, p2.address, p1.city, p2.city,
round((50000*sqrt((p1.latitude- p2.latitude) * (p1.latitude- p2.latitude)+ (p1.longitude-p2.longitude)*(p1.longitude- p2.longitude))),2) as distance, round(tbs.score,2)
FROM metrics as m1, metrics as m2, metric_headers as mh1, metric_headers as mh2, equivalence_table as e1, equivalence_table as e2, places as p1, places as p2, nm_troubleshoot as tbs
WHERE p1.place_id < p2.place_id
and p1.place_id = mh1.place_id
and p2.place_id = mh2.place_id
and m1.metric_header_id = mh1.metric_header_id
and m2.metric_header_id = mh2.metric_header_id
and mh1.place_id = e1.place_id
and mh2.place_id = e2.place_id
and mh1.metric_id = mh2.metric_id
and mh2.metric_id = 1
and e1.omb_place_id = e2.omb_place_id
and e2.omb_place_id = '" . $OmbPlaceId . "' 
and  p1.place_id in (tbs.place_id_1,tbs.place_id_2)
and  p2.place_id in  (tbs.place_id_1,tbs.place_id_2)
and tbs.matching_algo = 'SoftTFIDF2'
and round(tbs.score,2) <= " . $theta ."
and round(50000*sqrt((p1.latitude- p2.latitude) * (p1.latitude- p2.latitude)+ (p1.longitude-p2.longitude)*(p1.longitude- p2.longitude)),2) >= " . $radius ."
and m1.timestamp = (select max(mm1.timestamp) FROM metrics mm1 
WHERE mm1.metric_header_id = mh1.metric_header_id) 
and m2.timestamp = (select max(mm2.timestamp) FROM metrics mm2 
WHERE mm2.metric_header_id = mh2.metric_header_id)
and m1.value >= " . $checkins ."
or m2.value >= " . $checkins .";";

	//	echo $sqlselectCouples;

    }
    $resultCouples = mysql_query($sqlselectCouples) or die('Échec de la requête : ' . mysql_error()). $sqlSelectCouples;

    while ($row = mysql_fetch_row($resultCouples))
    {

      $pid1 = $row[1];
      $value1 = $row[2];
      $sourcename1 = $row[3];
      $name1 = $row[4];
      $sourceid1 = $row[5];
      $pid2 = $row[7];
      $value2 = $row[8];
      $sourcename2 = $row[9];
      $name2 = $row[10];
      $sourceid2 = $row[11];
      $address1 = $row[12];
      $address2 = $row[13];
      $city1 = $row[14];
      $city2 = $row[15];
      $distance = $row[16];
      $theta = $row[17];


if ($sourcename1 == 'Facebook') {$sourceURL1 = "<a href='http://www.facebook.com/$sourceid1'> (FB)"; }  else  {$sourceURL1 = " <a href='http://www.foursquare.com/v/$sourceid1'> (4sq)"; } 

if ($sourcename2 == 'Facebook') {$sourceURL2 = "<a href='http://www.facebook.com/$sourceid2'> (FB)"; }  else  {$sourceURL2 = " <a href='http://www.foursquare.com/v/$sourceid2'> (4sq)"; } 


echo "<table border='1' cellpadding='5'>";
    echo "<tr> <th> name </th> <th> address </th> <th> city </th> <th> checkins </th> <th> distance (m) </th> <th> theta </th>";	
            echo "<tr>";
	    echo "<td> <b>" . $name1 . $sourceURL1 . "</b> </td>";
            echo '<td>' . $address1 . '</td>';
	    echo '<td>' . $city1 . '</td>';
            echo '<td>' . $value1 . '</td>';
            echo '<td>' . $distance . '</td>';
	    echo '<td>' . $theta . '</td>';

            echo "</tr>"; 

	    echo "<tr>";
	    echo "<td> <b>" . $name2 . $sourceURL2 . "</b> </td>";
            echo '<td>' . $address2 . '</td>';
	    echo '<td>' . $city2 . '</td>';
            echo '<td>' . $value2 . '</td>';
	    //   echo '<td>' . $distance . '</td>';
            echo "</tr>"; 

    } 

    echo "</table> <br>\n";

}

$html .= "<br>\n";
$html .= "<br>\n";
  
 


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
