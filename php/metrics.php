<?php
include('include/open_db.php');
include('include/utilities.php');

$xml = isset($_GET['xml']);
$omb = isset($_GET['omb']);

$listMetricsName = 1;

$listCities = isset($_GET['getCities']);
$listPlaces = isset($_GET['getPlaces']);

$studyPlace = isset($_GET['id']);
$getPicture = isset($_GET['id']);

$limitMetrics = isset($_GET['limitMetrics']) ? $_GET['limitMetrics'] : 10;
$limitPhotos = isset($_GET['limitPhotos']) ? $_GET['limitPhotos'] : 10;


$idPlace = $studyPlace ? $_GET['id'] : "";

// VR 28-6-13 : here we study the city metrics per each date, in city.php we will study them for all step to be published
$studyCity = isset($_GET['city']);

$getAllMetrics = !$studyPlace && !$listPlaces & !$listCities;

/*
SELECT p.name, mn.metric_name, m.* FROM places p, metrics m, metric_headers h, metric_names mn
WHERE h.place_id = p.place_id
AND mn.metric_name = 'checkins'
AND p.sourcename = 'Facebook'
AND p.city = 'Manhattan'
AND h.metric_id = mn.metric_id
AND h.metric_header_id = m.metric_header_id
AND instr(m.timestamp,'2013-05-24')>0 ORDER by -m.value limit 100000000;
*/

if (!$xml)
{
?>
 <meta http-equiv="content-type" content = "text/html ; charset =utf-8" />
<html>
<head>
  <title>Omb Labs Metrics and Photos Retrieval</title>
<?php
}
else
    header("Content-type: text/xml; charset=utf-8");

$xmlHeader = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";


$html = "";

$link = "menu.php?" . ($omb ? "omb&" : ""). "id=" . $idPlace;
$html .= "<a href='" . $link . "' >Menu</a><br>\n";


$MetricIdToName = array();
$listMetricsOut = "";
if ($listMetricsName)
{
    $sqlQuery = "SELECT * FROM WayWay.metric_names";
    $result = mysql_query($sqlQuery) or die('Échec de la requête : ' . mysql_error());
    while ($array = mysql_fetch_row($result))
    {
        $listMetricsOut .= $array[1] . "<br>\n";
        $MetricIdToName[$array[0]] = $array[1];
        //echo "We have this amount of metrics : " . $array[0];
    }
}

if ($studyPlace)
{
	$placesTable = $omb ? "omb_places" : "places";
	$descriptionTable = $omb ? "omb_descriptions" : "descriptions";
	$placeId = $omb ? "omb_place_id" : "place_id";

    $sqlSelectInfoOnPlace = "SELECT opl.name, opl.address, opl.latitude, opl.longitude, opl.city FROM " .$placesTable. " opl WHERE opl." . $placeId . " = '" . $idPlace . "';";
    $result = mysql_query($sqlSelectInfoOnPlace) or die('Échec de la requête : ' . mysql_error(). $sqlSelectInfoOnPlace);

    if (mysql_num_rows($result) == 0)
    {
        $html .= "You have no place with such id !";
        echo "You have no place with such id !";
    }
    while ($array = mysql_fetch_row($result))
    {
        $name = $array[0];
        $address = $array[1];
        $lat = $array[2];
        $long = $array[3];
        $city = $array[4];
        $html .= "Name : $name, address : $address, $lat, $long <br>\n";
    }

    $sqlSelectInfoOnPlace = "SELECT * FROM " .$placesTable. " pl, ".$descriptionTable." d WHERE pl." . $placeId . " = '" . $idPlace . "' AND pl." . $placeId . " = d." . $placeId . " ;";
    $result = mysql_query($sqlSelectInfoOnPlace) or die('Échec de la requête : ' . mysql_error(). $sqlSelectInfoOnPlace);
    if ($array = mysql_fetch_row($result))
    {
        $html .= print_r($array, true)."<br>\n";
    }

    $linkZoomOnMap = dirname($_SERVER['PHP_SELF']) . "map.html" . "?lat=" . $lat ."&long=" . $long;
    // To be implemented !
    // $html .= "<a href='" . $linkZoomOnMap . "' >Zoom on map</a><br>\n";

    $linkStudyCity = $_SERVER['PHP_SELF'] . "?city=" . $city;
    $html .= "<a href='" . $linkStudyCity . "' >Study City</a><br>\n";

//    if ($omb)
    {
        $selectEquivalentPlace = "SELECT et.omb_place_id, et.place_id FROM equivalence_table et WHERE et.".($omb?"omb_":"")."place_id = '" . $idPlace . "' ";
        $html .= "We study the raw places linked to this omb_places or places : <br>\n";
	    $html .= " selectEquivalentPlace : " . $selectEquivalentPlace . " <br>\n";
        $result = mysql_query($selectEquivalentPlace) or die('Échec de la requête : ' . mysql_error()). $selectEquivalentPlace;
        while ($array = mysql_fetch_row($result))
        {
            $raw_place_id = $array[1];
            $link = $_SERVER['PHP_SELF'] . "?id=" . $raw_place_id;
            $html .= "<a href='" . $link . "' >One Place</a><br>\n";

            $raw_place_id = $array[0];
            $link = $_SERVER['PHP_SELF'] . "?omb&id=" . $raw_place_id;
            $html .= "<a href='" . $link . "' >THE Omb Place</a><br>\n";
        }
    }

    if ($omb)
    {
        $sqlQueryStudyPlace = "SELECT os.name, os.timestamp, os.value FROM omb_scores os WHERE os.omb_place_id = '".$idPlace."' " . " ORDER BY os.timestamp desc LIMIT ". ($limitMetrics) ." ;";
	}
	else
	{
        $sqlQueryStudyPlace = "SELECT mh.metric_id, m.timestamp, m.value FROM WayWay.metrics m, WayWay.metric_headers mh WHERE mh.metric_header_id = m.metric_header_id AND mh.place_id = '".$idPlace."' " . " ORDER BY mh.metric_id, m.timestamp desc LIMIT ". ($limitMetrics) ." ;";
	}
	$html .= " sqlQueryStudyPlace : " . $sqlQueryStudyPlace . " <br>\n";
    $result = mysql_query($sqlQueryStudyPlace) or die('Échec de la requête : ' . mysql_error()). $sqlQueryStudyPlace;

    while ($array = mysql_fetch_row($result))
    {
    	if ($omb)
    	{
            $html .= $array[0] . ": ";
    	}
    	else
    	{
            $html .= $MetricIdToName[$array[0]] . ": ";
    	}
        $html .= $array[1] . ": ";
        $html .= $array[2] ;

//    	for ($i = 0; $i < count($array); $i++)
//    	    $html .= $array[$i]. ", ";
//   	$html .= $MetricIdToName[$array[$i - 1]];

    	$html .= "<br>\n";
        //$html .= $array[1] . "<br>\n";
        //$MetricIdToName[$array[0]] = $array[1];
        //echo "We have this amount of metrics : " . $array[0];
    }
}

if ($getPicture)
{
	if ($omb)
            $selectPictureFromThisPlace = " SELECT ph.omb_photo_id, ph.omb_place_id, ph.url, ph.category FROM omb_photos ph WHERE ph.omb_place_id='" . $idPlace . "' LIMIT " . (10 * $limitPhotos) . " ; ";
	else
            $selectPictureFromThisPlace = " SELECT ph.photo_id, ph.place_id, ph.url FROM photos ph WHERE ph.place_id='" . $idPlace . "'  LIMIT " . (10 * $limitPhotos) . "  ; ";

    $html .= $selectPictureFromThisPlace."<br>\n";

    $ids = array();
    $urls = array();
    $place_ids = array();
    $tags = array(); 
    $result = mysql_query($selectPictureFromThisPlace) or die('Échec de la requête : ' . mysql_error()). $html;
    while ($array = mysql_fetch_row($result))
    {
        $id = $array[0];
        $url = $array[2];
        $place_id = $array[1];
        $tag = $omb ? $array[3] : "";

        array_push($ids, $id);
        array_push($urls, $url);
        array_push($place_ids, $place_id);
        array_push($tags, $tag);
    }

    if ($xml)
    {
        $xmlOut = createXmlContent($ids, $urls);
    }
    else
    {
    	$html .= " We have at least : " .count($ids) . " photos <br>\n";
	    for ($i = 0; $i < min(count($ids), $limitPhotos); $i++)
	    {
		    $link = "metrics.php?id=" . $place_ids[$i] . ($omb ? "&omb" : "");
//                    echo  " : " .  $urls[$i] . "<br>\n";
		    $html .= "<a  href='$link' ><img src='" . $urls[$i] . "' alt='$ids[$i]' height='300' width='300' /></a>$tags[$i]<br>\n";
	    }
    }
}

if ($studyCity)
{
    $city = $_GET['city'];
    $selectCountPlaces = "SELECT pl.sourcename, COUNT(*) FROM places pl WHERE pl.city = '" . $city . "' " . " GROUP BY pl.sourcename ;";
    $html .= $selectCountPlaces."<br>\n";

    $html .= "We have for this place : ";

    $result = mysql_query($selectCountPlaces) or die('Échec de la requête : ' . mysql_error()). $selectCountPlaces;
    while ($array = mysql_fetch_row($result))
    {
        $html .= $array[0]. " " . $array[1]. " <br>\n";
    }



    $city = $_GET['city'];
    $selectGroupByDate = "SELECT COUNT(*), Date(m.timestamp), mh.metric_id FROM metrics m, metric_headers mh, places pl WHERE m.metric_header_id = mh.metric_header_id AND mh.place_id = pl.place_id AND pl.city = '" . $city . "' " . " GROUP BY Date(m.timestamp), mh.metric_id ORDER BY mh.metric_id, Date(m.timestamp) desc;";
    //Date(m.timestamp) desc; ";
    $html .= $selectGroupByDate."<br>\n";

    $result = mysql_query($selectGroupByDate) or die('Échec de la requête : ' . mysql_error()). $selectGroupByDate;
    while ($array = mysql_fetch_row($result))
    {
        $html .= $MetricIdToName[$array[2]]. " " . $array[1]. " " . $array[0]. " <br>\n";
    }
}


if ($getAllMetrics)
{
    $sqlQuery = "SELECT COUNT(*) FROM WayWay.metrics";
    if (isset($_GET['name']))
    {
        $sqlQuery .= " WHERE `name` = '" . $_GET['name']."' ";
        $html .= "Name of metrics : " . $_GET['name'] . "<br>\n";
    }

    $result = mysql_query($sqlQuery) or die('Échec de la requête : ' . mysql_error()) . $sqlQuery;
    $array = mysql_fetch_row($result);
    $html .= "We have this amount of metrics : " . $array[0] . "<br>\n";
}


$html .= "<br>\n";
$html .= "<br>\n";
$html .= "<br>\n";
$html .= $listMetricsOut;

if (!$xml)
{
    echo $html;
?>
</body>
</html>
<?php
}
else
    echo $xmlHeader . $xmlOut;

include('include/close_db.php');
?>
