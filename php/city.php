
// Version Agathe July 16th with pricing feature

<?php
if (isset($_SERVER["USER"]))//== "victor")
    parse_str(implode('&', array_slice($argv, 1)), $_GET);

error_reporting(E_ERROR | E_WARNING | E_PARSE);
include('include/open_db.php');
include('include/utilities.php');

$addCity = isset($_GET['addCity']);
$studyCity = isset($_GET['studyCity']);
$listPlaceByCities = isset($_GET['listPlaceByCities']);
$all = isset($_GET['all']);

$html .= "By setting all in the list of request you will have a complete auditing of the size and cost but it will take some time to run <br>\b";

$verbose = isset($_GET['verbose']);
$html = "";
if ($verbose)
{
    $html .= "Verbose mode ! <br>\n";
}

$city = isset($_GET['city']) ? $_GET['city'] : "NewYork";
$geoname = $city;

if (!$xml)
{
?>
 <meta http-equiv="content-type" content = "text/html ; charset =utf-8" />
<html>
<head>
    <title> CITIES, studying - OMB LABS </title>
<?php
}
else
    header("Content-type: text/xml; charset=utf-8");

$xmlOut = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";

if (!$xml)
{
?>
</head>
<body>
<br>
<br>
<?php
}



function buildConditionLocalization($geoname, $prefix, $verbose)
{

    $selectLatLong = "SELECT * FROM `cities` WHERE `area`='".
    $geoname."' OR `city`='".$geoname."';";

    $result = mysql_query($selectLatLong) or die('Échec de la requête : ' . mysql_error() . $selectLatLong);

    if ($verbose)
    {
        echo $selectLatLong ."<br>\n";
    }

    $max_lat = -90;
    $min_lat = 90;
    $max_long = -180;
    $min_long = 180;

    while ($array = mysql_fetch_row($result))
    {
        $latitude = $array[3];
        $longitude = $array[4];

		if ($max_lat < $latitude)
		    $max_lat = $latitude;
		if ($min_lat > $latitude)
		    $min_lat = $latitude;
		if ($max_long < $longitude)
		    $max_long = $longitude;
		if ($min_long > $longitude)
		    $min_long = $longitude;
    }

    $conditionLocalization = " ".$prefix."latitude > '" . $min_lat . "' "
        . " AND ".$prefix."latitude < '" . $max_lat . "' "
        . " AND ".$prefix."longitude > '" . $min_long . "' "
        . " AND ".$prefix."longitude < '" . $max_long . "' ";
    return $conditionLocalization;
}



// Create list

      //list cities
    $sqlSelecCities = "SELECT DISTINCT `city` FROM `cities`; ";
    $result = mysql_query($sqlSelecCities) or die('Échec de la requête : ' . mysql_error() . $sqlSelecCities);
    $listCity = Array();
    while ($array = mysql_fetch_row($result))
    {
        if ($array[0] != "")
        {
            array_push($listCity, $array[0]);
        }
    }
    $sqlSelecCities = "SELECT DISTINCT `area` FROM `cities`; ";
    $result = mysql_query($sqlSelecCities) or die('Échec de la requête : ' . mysql_error() . $sqlSelecCities);
    while ($array = mysql_fetch_row($result))
    {
        if ($array[0] != "")
        {
            array_push($listCity, $array[0]);
        }
    }

for ($i = 0; $i < count($listCity); $i++)
{
    if (removeWhiteSpace($listCity[$i]) == $city)
    {
        $html .= "Found geoname : " . $listCity[$i] . "<br>\n";
        $geoname = $listCity[$i];
    }
}



if ($listPlaceByCities)
{
    $selectCityPlaces = "SELECT COUNT(*), city FROM `WayWay`.`places` GROUP BY city ORDER BY COUNT(*) desc; ";
    $result = mysql_query($selectCityPlaces) or die('Échec de la requête : ' . mysql_error() . $selectCityPlaces);
    while ($array = mysql_fetch_row($result))
    {
        $html .= " City  ".$array[1]." has ".$array[0]." places (raw before matching)  <br>\n";
    }
}

/* mail('inscription@moilerat.com','phpinfo',phpinfo(),'From : phpinfo@zeroemission.fr') ; */

// to be removed
if ($addCity)
{
    $latitudes = $_GET['latitudes'];
    $longitudes = $_GET['longitudes'];
    $cityname = $_GET['cityname'];
    $areaname = $_GET['areaname'];

    if ($areaname = "")
        $areaname = $cityname;

    $arrayLat = explode(",", $latitudes);
    $arrayLong = explode(",", $longitudes);

    $html .= print_r($arrayLat);
    $html .= print_r($arrayLong);

    if (count($arrayLat) == 1)
    {
        $latitude = $arrayLat[0];
        $longitude = $arrayLong[0];
        $arrayLat = array();
        $arrayLong = array();

	    array_push($arrayLat, $latitude - 1.);
	    array_push($arrayLat, $latitude - 1.);
	    array_push($arrayLat, $latitude + 1.);
	    array_push($arrayLat, $latitude + 1.);

	    array_push($arrayLong, $longitude - 1.);
	    array_push($arrayLong, $longitude + 1.);
	    array_push($arrayLong, $longitude + 1.);
	    array_push($arrayLong, $longitude - 1.);
    }

    $insertCity = "INSERT INTO `WayWay`.`cities` (`city`, `area`, `latitude`, `longitude`, `point_rank`) VALUES";
    $html .= $insertCity;
    for ($i = 0; $i < count($arrayLat ); $i++)
    {
        if ($i > 0)
            $insertCity .= ", ";
        $insertCity .= "('".$cityname."', '".$cityname."', '".$arrayLat[$i]."', '".$arrayLong[$i]."', '".$i."' ) ";
    }
    $insertCity .= ";";

    $html .= " insertCity ". $insertCity."<br>\n";

    $result = mysql_query($insertCity) or die('Échec de la requête : ' . mysql_error() . ", insertCity : " . $insertCity);
    //$html .= mysql_rows_affected()."<br>\n";
}

function selectAndOutputValue($selectQuery, $verbose)
{
    $res = "";
	if ($verbose)
	    $res .= $selectQuery . "<br>\n";
    $result = mysql_query($selectQuery) or die('Échec de la requête : ' . mysql_error() . $selectQuery);
    while ($array = mysql_fetch_row($result))
    {
        $res .=  print_r ($array, true) . "<br>\n";
    }
    return $res;
}

if ($studyCity)
{
    $prefix = "pl.";
    $conditionLoc = buildConditionLocalization($geoname, $prefix, $verbose);
    echo $conditionLoc ;

    // PLACES ___________________________________________________________________________
    $html .= "<br> <b>Do we have places ?</b> <br> ";
    $selectPlaces = "SELECT sourcename, count(*) " .
                " FROM places as pl " .
                " WHERE ".
                // " pl.city='" .$city. "' ".
                $conditionLoc .
                " GROUP BY pl.sourcename; ";

    $start = microtime(true);
    $html .= selectAndOutputValue($selectPlaces, $verbose);
    $end = microtime(true);

    $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n ";
    $start = microtime(true);

    //$html .= "Do we have places";
    $selectAllPlaces = "SELECT count(*) " .
                " FROM places as pl " .
                " WHERE " .
                // " pl.city='" .$city. "' ".
                $conditionLoc .
                ";" ;

    $result = mysql_query($selectAllPlaces) or die('Échec de la requête : ' . mysql_error() . $selectAllPlaces);
    $array = mysql_fetch_row($result);
    $NBplaces = $array[0]; 
    // $html .= selectAndOutputValue($selectAllPlaces, $verbose);
    $html .= 'nohup ~/omb/script_for_cron.sh  initialize all ' .removeWhiteSpace($city). ' & <br>';
$html .= 'nohup ~/omb/script_for_cron.sh  initialize 4sqplace ' .removeWhiteSpace($city). ' & <br>';
$html .= 'nohup ~/omb/script_for_cron.sh  initialize fbplace ' .removeWhiteSpace($city). ' & <br>';

$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

  // DESCRIPTIONS ___________________________________________________________________________
 $html .= " <br> <b>Do we have descriptions ?</b> <br> ";
$selectDescriptions = "SELECT pl.sourcename, count(*) " .
                " FROM places as pl, descriptions as d" .
                " WHERE " .
               // " pl.city='" .$city. "' ".
                $conditionLoc .
                " AND pl.place_id = d.place_id" .
                " GROUP BY pl.sourcename; ";

$html .= selectAndOutputValue($selectDescriptions, $verbose);
$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

$html .= 'nohup ~/omb/script_for_cron.sh initialize  fbdescr ' .removeWhiteSpace($city). ' & <br>';
$html .= 'nohup ~/omb/script_for_cron.sh initialize  4sqdescr ' .removeWhiteSpace($city). ' & <br>';

// SCORING CATEGORIES_______________________________________________________________
$html .= "  <br> <b>How are scoring_category distributed for the places ? </b> <br>";
$selectAllScoringCat = "SELECT count(*), d.scoring_category ".
" FROM WayWay.descriptions as d, WayWay.places as pl " . 
" where pl.place_id = d.place_id ".
" and ".
//" pl.city = '" .$city. "' ".
                $conditionLoc .
" group by d.scoring_category ".
" order by d.scoring_category;";
//$html .= selectAndOutputValue($selectAllScoringCat, $verbose);
$result = mysql_query($selectAllScoringCat) or die('Échec de la requête : ' . mysql_error() . $selectAllScoringCat);
 while ($array = mysql_fetch_row($result))
   { $html .= '' . $array[0] . ' places in category ' . $array[1] . ' <br>';  

     if ($array[1] != "")
       {
	 if ($array[1] == "1") 
	     {
	       $hourly = $array[0];
	     }
	   elseif ($array[1] == "2") 
	     {
	       $Fourhourly = $array[0];
	     }
	   elseif ($array[1] == "3") 
	     {
	       $daily = $array[0];
	     }
	   elseif ($array[1] == "4") 
	     {
	       $weekly = $array[0]; 
	     }
	   elseif ($array[1] == "5")
	     {
	       $monthly = $array[0];
	     }
	   elseif ($array[1] == "0")
	     {
	       $monthlytoo = $array[0];
	       
	     }
	   else {
	   }
        } }
 $metricsPerMonth = $hourly*24*30 + $Fourhourly*6*30 + $daily*30 + $weekly*4 + $monthly + $monthlytoo;
  $html .=  $metricsPerMonth . ' metrics added per month <br>';
  //every metric retrieval, there are 3 or 4 different metrics that are recorded (depending if 4sqr or FB place), i.e. 3.5 lines added in the metrics table on average
 $metricsLinesPerMonth = $metricsPerMonth*3.5;
  $html .=  $metricsLinesPerMonth . ' metrics lines added per month <br>';
$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

/*
scoring_category 1: metrics revrieved hourly
* scoring_category 2: every 4 hours
* scoring_category 3: every day
* scoring_category 4: every week  
* scoring_category 5 and 0 (no category): every month
*/

// METRICS ___________________________________________________________________________
$html .= "  <br> <b>Do we have metrics ? </b> <br>";
$selectMetrics = " SELECT pl.sourcename, mn.metric_name, count(*) " .
                 " FROM places pl, metric_names mn, metric_headers mh, metrics m " .
                 " WHERE ".
                 //" pl.city='" .$city. "' " .
                $conditionLoc .
                 " AND pl.place_id=mh.place_id " .
                 " AND mh.metric_id=mn.metric_id " .
                 " AND mh.metric_header_id=m.metric_header_id " .
                 " GROUP BY pl.sourcename, mn.metric_name;";
if (isset($_GET['metric']) || $all)
{
$html .= selectAndOutputValue($selectMetrics, $verbose);
$html .= '-- nohup ~/omb/script_for_cron.sh  metrics fb4sq ' .removeWhiteSpace($city). ' & <br>';
$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

//$html .= "Do we have metrics ";
$selectAllMetrics = " SELECT count(*) " .
                 " FROM places pl, metric_names mn, metric_headers mh, metrics m " .
                 " WHERE " .
                 //" pl.city='" .$city. "' " .
                 $conditionLoc .
                 " AND pl.place_id=mh.place_id " .
                 " AND mh.metric_id=mn.metric_id " .
                 " AND mh.metric_header_id=m.metric_header_id;";

$result = mysql_query($selectAllMetrics) or die('Échec de la requête : ' . mysql_error() . $selectAllMetrics);
$array = mysql_fetch_row($result);
$NBmetrics = $array[0]; 
//$html .= selectAndOutputValue($selectAllMetrics, $verbose);

$selectAllMetricHeaders = " SELECT count(*) " .
                 " FROM places pl, metric_names mn, metric_headers mh" .
                 " WHERE " .
                 //" pl.city='" .$city. "' " .
                 $conditionLoc .
                 " AND pl.place_id=mh.place_id " .
                 " AND mh.metric_id=mn.metric_id;";
$result = mysql_query($selectAllMetricHeaders) or die('Échec de la requête : ' . mysql_error() . $selectAllMetricHeaders);
$array = mysql_fetch_row($result);
$NBmetricHeaders = $array[0]; 
$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);
}
else
{
    $html .= "Add <b>metric</b> in http GET arg to have stat on metrics (takes time to run)<br>\n";
}
$html .= 'nohup ~/omb/script_for_cron.sh metrics fb4sq ' .removeWhiteSpace($city). ' -freq=month & <br>\n';
  // PHOTOS ___________________________________________________________________________
$html .= " <br> <b>Do we have photos ? </b><br>";

// $selectPic = " SELECT count(*) from photos where place_id in (select place_id from places where city = '" .$city. "' );";
$selectPic = " SELECT count(*) from photos pl where ". $conditionLoc ;
if ($verbose)
    $html .= $selectPic . "<br>\n";
if (isset($_GET['photo']) || $all)
{
    $result = mysql_query($selectPic) or die('Échec de la requête : ' . mysql_error() . $selectPic);
    $array = mysql_fetch_row($result);
    $NBPic = $array[0]; 
    $html .= $NBPic . "<br>\n" ;

    $end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);
}
else
{
    $html .= "Add <b>photo</b> in http GET arg to have stat on photo (takes time to run)";
}
$html .= 'nohup ~/omb/script_for_cron.sh metrics instPicHist ' .removeWhiteSpace($city). ' -freq=month & <br>';
$html .= 'nohup ~/omb/script_for_cron.sh metrics instPic ' .removeWhiteSpace($city). ' -freq=month & <br>';

// PHOTO GROWTH __________________________________________________________________________
$html .= " <br> <b>Do we have photos from last month ? </b>";
$selectLastMonthPhotos = "select count(*) from photos as pl WHERE " . 
                $conditionLoc .
" and date(pl.timeStamp) <= CURDATE() " .
" and date(pl.timeStamp) >= DATE_ADD(CURDATE(),INTERVAL -1 MONTH); ";
if ($verbose)
    $html .= $selectLastMonthPhotos . "<br>\n";
if (isset($_GET['photo']) || $all)
{
    $result = mysql_query($selectLastMonthPhotos) or die('Échec de la requête : ' . mysql_error() . $selectLastMonthPhotos);
    $array = mysql_fetch_row($result);
    $NBLastMonthPhotos = $array[0];

    $end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" .         $difference . "| <br>\n"; $start = microtime(true);
    $html .= $NBLastMonthPhotos . "<br>\n" ;
}
else
{
    $html .= "Add <b>photo</b> in http GET arg to have stat on photo (takes time to run)<br>\n";
}

// DISTANCES ___________________________________________________________________________
$html .= " <br> <b>Do we have distances ? </b>";
if (isset($_GET['distances']) || $all)
{
    $selectDistances = "SELECT count(*) from distances where place_id_1 in (select place_id from places where city = '" .$city . "');";

    if ($verbose)
        $html .= $selectDistances . "<br>\n";

    $result = mysql_query($selectDistances) or die('Échec de la requête : ' . mysql_error() . $selectDistances);
    $array = mysql_fetch_row($result);
    $NBDist = $array[0]; 
    $html .= $NBDist . "<br>\n" ;
    $end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);
}
else
{
    $html .= "Add distances in http GET arg to have stat on distances (takes time to run) <br>\n";
}

$html .='nohup ~/omb/script_for_cron.sh  matching  fillNMDist  ' .removeWhiteSpace($city). ' & <br>';
$html .='nohup ~/omb/script_for_cron.sh  matching  computeMatched  ' .removeWhiteSpace($city). ' & <br>';

// OMB_PLACES ___________________________________________________________________________
$prefix = "op.";
$conditionLocOmb = buildConditionLocalization($geoname, $prefix, $verbose);

$html .= " <br> <b>-- Do we have omb_places ? </b>";
$selectOmbPlaces = "SELECT count(*) " .
                   " FROM omb_places op " .
                   " WHERE " .
                   $conditionLocOmb .
                   // " op.city='" .$city. "'".
                   " ;";

if ($verbose)
    $html .= $selectOmbPlaces . "<br>\n";

$result = mysql_query($selectOmbPlaces) or die('Échec de la requête : ' . mysql_error() . $selectOmbPlaces);
$array = mysql_fetch_row($result);
$NBOmbPlaces = $array[0]; 
$html .= $NBOmbPlaces . "<br>\n" ;
$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

$html .='nohup ~/omb/script_for_cron.sh  matching  fillOmb  ' .removeWhiteSpace($city). ' -minPhoto=20 & <br>';
$html .= "Makes all : <br>\n";
$html .='nohup ~/omb/script_for_cron.sh  matching  matching  ' .removeWhiteSpace($city). ' & <br>';

  // OMB DESCRIPTIONS ___________________________________________________________________________
$html .= "<br> <b>-- Do we have omb_descriptions ? </b>";

$selectOmbDescriptions = "SELECT count(*) from omb_places op, omb_descriptions os " .
                   " where ".
                   //" op.city='" .$city. "' " .
                   $conditionLocOmb .
                   " AND op.omb_place_id = os.omb_place_id;";

if ($verbose)
    $html .= $selectOmbDescriptions . "<br>\n";

$result = mysql_query($selectOmbDescriptions) or die('Échec de la requête : ' . mysql_error() . $selectOmbDescriptions);
$array = mysql_fetch_row($result);
$NBOmbDesc = $array[0]; 
$html .= $NBOmbDesc . "<br>\n" ;
$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

$html .= 'nohup ~/omb/script_for_cron.sh  matching fillOmbDesc ' .removeWhiteSpace($city). ' & <br>';

  // OMB SCORES ___________________________________________________________________________
$html .= "<br> <b>-- Do we have omb_scores ? </b>";

$selectOmbScores = "SELECT count(*) from omb_places op, omb_scores os " .
                   " where " .
//                   " op.city='" .$city. "' " .
                   $conditionLocOmb .
                   " AND op.omb_place_id = os.omb_place_id; ";
$result = mysql_query($selectOmbScores) or die('Échec de la requête : ' . mysql_error() . $selectOmbScores);
$array = mysql_fetch_row($result);
$NBOmbScores = $array[0];
$html .= $NBOmbScores . "<br>\n" ;
$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

$html .= 'nohup ~/omb/script_for_cron.sh scores  all ' .removeWhiteSpace($city). ' -nbDays=40 -sizeBatch=1 & <br>';
$html .= 'nohup ~/omb/script_for_cron.sh scores  ombscores ' .removeWhiteSpace($city). ' & <br>';

/*
VR 12-9-13 : do we want to compute this ?

// OMB SCORES DISTRIBUTION ___________________________________________________________________________
$html .= "<br> <b>-- What is omb_scores distribution ? </b>";

$selectOmbDescriptions = "SELECT * from omb_places op, omb_descriptions os " .
                   " where ".
                   //" op.city='" .$city. "' " .
                   $conditionLocOmb .
                   " AND op.omb_place_id = os.omb_place_id;";

if ($verbose)
    $html .= $selectOmbDescriptions . "<br>\n";

$result = mysql_query($selectOmbDescriptions) or die('Échec de la requête : ' . mysql_error() . $selectOmbDescriptions);
$listScoreClassic = array();
$listScoreTrending = array();
$listScoreBoth = array();
while ($array = mysql_fetch_assoc($result))
{
    $score_classic = $array['score_classic'];
    $score_trending = $array['score_trending'];
    array_push($listScoreClassic, $score_classic);
    array_push($listScoreTrending, $score_trending);
    array_push($listScoreBoth, array($score_classic, $score_trending));
}
$grid = array();
for ()
{
    ;
}

function distribution($data, $grid)
{
    ;
}
*/
$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);



 // OMB PHOTOS ___________________________________________________________________________
$html .= "<br> <b>Do we have omb_photos ? </b> ";

$selectOmbPic = " SELECT count(*) from omb_places op, omb_photos oph " .
                  " where " .
//                  " op.city='" .$city. "' " .
                   $conditionLocOmb .
                  " AND op.omb_place_id = oph.omb_place_id; ";

if ($verbose)
    $html .= $selectOmbPic . "<br>\n";

$result = mysql_query($selectOmbPic) or die('Échec de la requête : ' . mysql_error() . $selectOmbPic);
$array = mysql_fetch_row($result);
$NBOmbPic = $array[0]; 
$html .= $NBOmbPic . "<br>\n" ;
$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

$html .= 'nohup ~/omb/script_for_cron.sh clean prepPhoto ' .removeWhiteSpace($city). ' -minNb=20 -maxNb=65 -tagNbPhotos=20000 & <br>';
$html .= 'nohup ~/omb/script_for_cron.sh clean prepPhoto ' .removeWhiteSpace($city). ' -minNb=20 -maxNb=40 -tagNbPhotos=20000 -nonpeople -photo_tag=6 & <br>';
$html .= 'nohup ~/omb/script_for_cron.sh matching fillOmbPhoto ' .removeWhiteSpace($city). ' -all & <br>';
$html .= 'nohup ~/omb/script_for_cron.sh matching fillOmbPhoto ' .removeWhiteSpace($city). ' -past=24 -all & <br>';

  // Map omb_places number omb_photos ___________________________________________________________________________
$html .= " <br> <b>How many photo by place ? </b>";
if (isset($_GET['mapPhotos']) || $all)
{
    $html .= "<a href=\"#mapPhotos\">MapPhotos</a><br>\n";

    $selectNbPhotos = " SELECT omb_place_id FROM omb_places op ".
                    " WHERE omb_place_id NOT IN (SELECT omb_place_id FROM omb_photos) ".
                    " AND " . $conditionLocOmb;


    if ($verbose)
        $html .= $selectNbPhotos . "<br>\n";

    $result = mysql_query($selectNbPhotos) or die('Échec de la requête : ' . mysql_error() . $selectNbPhotos);
    $size = mysql_num_rows($result);

    $html .= " We have " . $size . " omb_places without any photos <br>\n" ;


    $selectNbPhotos = " select omb_place_id, count(*) from omb_photos op " .
      " where "  . $conditionLocOmb .
    " group by omb_place_id " .
    " order by count(*);" ;

    if ($verbose)
        $html .= $selectNbPhotos . "<br>\n";

    $mapNumberPlacesPerNbPhotos = array();
    $result = mysql_query($selectNbPhotos) or die('Échec de la requête : ' . mysql_error() . $selectNbPhotos);
    while ($array = mysql_fetch_array($result))
    {
        $count = $array[1];
        $mapNumberPlacesPerNbPhotos[$count]++;
    }

    for ($i = 0; $i < 10; $i++)
    {
        $count = 0;
        for ($j = 0; $j < 10; $j++)
        {
            if (array_key_exists(10 * $i + $j, $mapNumberPlacesPerNbPhotos))
            {
                $count += $mapNumberPlacesPerNbPhotos[(10 * $i + $j)];
            }
        }
        $html .= " We have " . $count . " omb_places with " . (10 * $i) . " to " . (10 * $i + 9) .  " photos <br>\n" ;
    }

    $keys = array_keys($mapNumberPlacesPerNbPhotos);
    $count = 0;
    for ($i = 0 ; $i < count($keys); $i++)
    {
        if ($keys[$i] > 100)
        {
            $count += $mapNumberPlacesPerNbPhotos[$keys[$i]];
        }
    }
    $html .= " We have " . $count . " omb_places with more than 100 photos <br>\n" ;

    $end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

//    $html .= print_r($mapNumberPlacesPerNbPhotos, true) . "<br>\n";
}
else
{
    $html .= "Add <b>mapPhotos</b> in http GET arg to have stat on number of photos per places <br>\n";
}

 $html .= "nohup ~/omb/script_for_cron.sh matching fillOmbPhoto " . removeWhiteSpace($city) . " -limit=1000 -verbose -minNb=100 & <br>\n" ;

 $html .= "nohup ~/omb/script_for_cron.sh front all " . removeWhiteSpace($city) . " & <br>\n" ;


# Number of places with less than a some photos :




//Should we add an option forceFilling


// Pricing

/*
SELECT concat(table_schema,'.',table_name),
round((data_length+index_length)/(1024*1024*1024),2)/round(table_rows/1000000,2) as space_per_row
FROM information_schema.TABLES 
WHERE concat(table_schema,'.',table_name) LIKE 'WayWay%'
ORDER BY data_length+index_length DESC LIMIT 20;
*/

// tablespace in Gigabites per 1000000 row
/*

$NBplaces
'WayWay.places', '0.318182'
'WayWay.descriptions', '0.200000'
'WayWay.scores', '0.166667'


 
$NBmetricHeaders
'WayWay.metric_headers', '0.096154'


$NBmetrics
'WayWay.metrics', '0.098432'


$NBOmbPlaces 
'WayWay.omb_places', '0.230769'
'WayWay.omb_descriptions', '0.400000'
'WayWay.equivalence_table', '0.090909'


$NBOmbScores
'WayWay.omb_scores', '0.117647' 


$NBOmbPic
'WayWay.omb_photos', '0.312500'

$NBPic
'WayWay.photo_descriptions', '0.397993'
'WayWay.photos', '0.363167'
'WayWay.user_photo_categorizations', '0.296296'

$NBDist
'WayWay.distances', '0.305556'

*/
// 16 different score names
// count 2 places per omb_place
$space = ($NBplaces * (0.318182 + 0.200000+  0.166667*16) + $NBmetrics * 0.098432 + $NBmetricHeaders * 0.096154 + $NBOmbPlaces * (0.230769 + 0.400000 + 0.090909 *2) + $NBOmbScores * 0.117647 + $NBOmbPic * 0.31250 + $NBPic * (0.397993 + 0.363167 + 0.296296) + $NBDist * 0.30555)/1000000;

// 1 Giga = 10c per day
echo 'Space in DB : ';
echo round($space*100)/100 . " Gigas <br>\n";
echo 'Estimated price : ';
echo round($space*0.1*365) ;
echo " dollars per year <br>\n";

// Price growth
$addedspaceMetrics = $metricsLinesPerMonth * 0.098432/1000000;
echo "Every month, " . round( $addedspaceMetrics*0.1*365) . " extra dollars per per year due to added stored metrics <br> ";
$addedspacePhotos = $NBLastMonthPhotos * (0.397993 + 0.363167 + 0.296296)/1000000;
echo "Every month, " . round( $addedspacePhotos*0.1*365*10)/10 . " extra dollars per per year due to added stored photos <br> ";

// Checking total size

$selectTotalSize = "SELECT sum(data_length+index_length)/(1024* 1024 * 1024)
FROM information_schema.TABLES";
$result = mysql_query($selectTotalSize) or die('Échec de la requête : ' . mysql_error() . $selectTotalSize);
$array = mysql_fetch_row($result);
$TotalSize = $array[0];
echo "Total space on DB : " . $TotalSize . " Gigas <br>";






}

// Form
{
    $html .= "<br><br>Study one city <br>\n";

    $formOutput = "";

    $formOutput .= "<form method=GET  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutput .= "<input name=studyCity value=plop type=hidden /><br>\n";
    $formOutput .= "City Name :<select name=city >".buildChoiceList($listCity, "")."</select><br>\n";
    $formOutput .= "<input type=submit value=StudyCity  >";
    $formOutput .= "</form><br>\n";

    $html .= $formOutput;


    $formOutput = "";

    $formOutput .= "<form method=GET  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutput .= "<input name=addCity value=plop type=hidden /><br>\n";
    $formOutput .= "City Name :  <input name=cityname   /><br>\n";
    $formOutput .= "Area Name :  <input name=areaname   />(leave blank for city)<br>\n";
    $formOutput .= "List of latitudes :  <input name=latitudes   />(csv)<br>\n";
    $formOutput .= "List of longitudes :  <input name=longitudes   />(csv)<br>\n";
    $formOutput .= "<input type=submit value=AddCity  >";
    $formOutput .= "</form><br>\n";

    $html .= $formOutput;


    $formOutput = "<br><br>List Places By Cities\n";

    $formOutput .= "<form method=GET  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutput .= "<input name=listPlaceByCities value=plop type=hidden /><br>\n";
    $formOutput .= "<input type=submit value=ListPlacesByCities  >";
    $formOutput .= "</form><br>\n";

    $html .= $formOutput;



}

if (!$xml)
{

echo $html;

?>
</body>
</html>
<?php
}
else
echo $xmlOut;

include('include/close_db.php');
?>
