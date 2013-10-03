<?php
if (isset($_SERVER["USER"]))//== "victor")
    parse_str(implode('&', array_slice($argv, 1)), $_GET);

error_reporting(E_ERROR | E_WARNING | E_PARSE);
include('include/open_db.php');
include('include/utilities.php');

$userTaggingTable = "user_photo_categorizations";
$tag_photo_column = "photo_tag_id";

$defaultProba = 0.05;

$folderWorkGnuplot = "data";

$xml = isset($_GET['xml']);

$compareUsers = isset($_GET['compareUsers']);
$debug = isset($_GET['debug']);

$studyUser = isset($_GET['studyUser']);

$checkAuto = isset($_GET['checkAuto']);
$limit = isset($_GET['limit']) ? $_GET['limit'] : 100;
$offset = isset($_GET['offset']) ? $_GET['offset'] : 0;

// default behavior, if $studyUser we want to ahve the listuser
$listUsers = !$compareUsers;

if (!$xml)
{
?>
 <meta http-equiv="content-type" content = "text/html ; charset =utf-8" />
<html>
<head>
  <title>Omb Labs Quality Assurance for Photo Categorization</title>
<?php
}
else
    header("Content-type: text/xml; charset=utf-8");


$xmlOut = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";

if (!$xml)
{
?>
<style>
table {
 border-width:1px; 
 border-style:solid; 
 border-color:black;
 width:50%;
 }
td { 
 border-width:1px;
 border-style:solid; 
 border-color:red;
 width:50%;
 }
</style>
</head>
<body>
<br>
<br>
<?php
}

$html = "";

$ip = $_SERVER['REMOTE_ADDR'];
$browser = $_SERVER['HTTP_USER_AGENT'];

$keyUserConnected = getKeyUser($ip, $browser);
$user_unique_id = getUserUniqueId($keyUserConnected);

//mail('inscription@moilerat.com','phpinfo',phpinfo(),'From : test@omblabs.co');

$defaultDate="yyyy-mm-dd";

function completeDate($date, $endOrNot, $defaultDate)
{
    if ($date == $defaultDate)
    {
        return "";
    }
    else if (strlen($date) == strlen($defaultDate))
    {
    	//echo "date : $date, defaultDate : $defaultDate <br>\n";
        if ($endOrNot)
            return $date . " 23:59:59";
        else
            return $date . " 00:00:00";
    }
    else
        return $date;
}



if ($compareUsers)
{
    $user1 = $_GET['user1'];
    $user2 = $_GET['user2'];

    $begin = completeDate($_GET['begin'], false, $defaultDate);
    $end = completeDate($_GET['end'], true, $defaultDate);

    $html .= " begin : $begin <br>\n";
    $html .= " end : $end <br>\n";

    $html .= "user1 : " . $user1 . "<br>";
    $html .= "user2 : " . $user2 . "<br>";
    $user_unique_id1 = getUserUniqueId($user1);
    $user_unique_id2 = getUserUniqueId($user2);

    $selectDiffUser = " FROM photos ph, `".$userTaggingTable."`  pd1, `".$userTaggingTable."`  pd2 " .
    "WHERE ph.photo_id = pd1.photo_id " .
    "AND ph.photo_id = pd2.photo_id " .
    "AND pd1.user_unique_id = '". $user_unique_id1 ."' " .
    "AND pd2.user_unique_id = '". $user_unique_id2 ."' " .
    " AND pd1.`".$tag_photo_column."` < '4' " .
    " AND pd2.`".$tag_photo_column."` < '4' ";

// .   "AND pd1.tag = pd2.tag;";

    if ($begin != "")
        $selectDiffUser .= "AND pd1.timestamp >= '".$begin."'   "; 

    if ($end != "")
    	$selectDiffUser .= "AND pd1.timestamp <= '".$end."'   "; 

    $selectDiffUserSameTag = "SELECT  DISTINCT COUNT(ph.photo_id) ". $selectDiffUser . "AND pd1.`".$tag_photo_column."` = pd2.`".$tag_photo_column."` ;";

    //$html .= "selectDiffUserSameTag : " . $selectDiffUserSameTag . "<br>";
    $html .= "user2 : " . $user2 . "<br>";

$result = mysql_query($selectDiffUserSameTag) or die('Échec de la requête : ' . mysql_error() . ", selectDiffUserSameTag : " . $selectDiffUserSameTag);

$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

//$size = ;
while ($array = mysql_fetch_row($result))
{
	echo "You have this amount of same tag : ". $array[0] ."<br>";
    //echo "You have this amount of same tag : ". mysql_num_rows($result) ."<br>";
}


    $selectDiffUserDiffTag = "SELECT  DISTINCT COUNT(ph.photo_id) ". $selectDiffUser . "AND pd1.`".$tag_photo_column."` <> pd2.`".$tag_photo_column."`;";

    $html .= "selectDiffUserDiffTag : <br>" .$selectDiffUserDiffTag . "<br>\n";

    $result = mysql_query($selectDiffUserDiffTag) or die('Échec de la requête : ' . mysql_error() . ", selectDiffUserDiffTag : " . $selectDiffUserDiffTag);
    $end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

    while ($array = mysql_fetch_row($result))
    {
	echo "You have this amount of different tag : ". $array[0] ."<br>";
        // echo "You have this amount of different tag : ". mysql_num_rows($result) ."<br>";
    }

    $selectDiffUserAllTag = "SELECT   DISTINCT COUNT(ph.photo_id) ". $selectDiffUser . " ;";

    $result = mysql_query($selectDiffUserAllTag) or die('Échec de la requête : ' . mysql_error() . ", selectDiffUserAllTag : " . $selectDiffUserAllTag);
    $end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

    while ($array = mysql_fetch_row($result))
    {
	echo "You have this amount of tag made by both : ". ($array[0]) ."<br>";
    //echo "You have this amount of tag made bu both : ". mysql_num_rows($result) ."<br>";
    }

    $selectDiffUserDiffTag = "SELECT DISTINCT ph.url, pd1.`".$tag_photo_column."`, pd2.`".$tag_photo_column."`, ph.place_id ".
        $selectDiffUser . "AND pd1.`".$tag_photo_column."` <> pd2.`".$tag_photo_column."`;";

    $result = mysql_query($selectDiffUserDiffTag) or die('Échec de la requête : ' . mysql_error() . ", selectDiffUserDiffTag : " . $selectDiffUserDiffTag);
    $end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

function tagToString($tagAsInt)
{
    // should be initialized form the database...
    if ($tagAsInt == 0)
        return "PEOPLE";
    if ($tagAsInt == 1)
        return "FOOD";
    if ($tagAsInt == 2)
        return "FEEL";
    if ($tagAsInt == 3)
        return "ERROR_LOADING";

    return $tagAsInt;
}

    $i = 0;
    while ($array = mysql_fetch_row($result))
{
    $url = $array[0];
    $tag1 = $array[1];
    $tag2 = $array[2];
    $place_id = $array[3];

    $html .= $user1 . " : " . tagToString($tag1)."\n ";
    $html .= $user2 . " : " . tagToString($tag2)."\n ";

 //   $html .= "<img src='" . $url . "' alt='Photo Instagram' height='300' width='300' >"; 

    $link = "metrics.php?id=" . $place_id;
// . ($omb ? "&omb" : "");
    $html .= "<a  href='$link' ><img src='" . $url . "' alt='Photo Instagram' height='300' width='300' ></a><br>\n";


    $html .= "<br>";
}

}

$beginHistoricalDateTime = "";
$endHistoricalDateTime = "";
$user = "";

if ($studyUser)
{
    $user = $_GET['user'];
    $begin = completeDate($_GET['begin'], false, $defaultDate);
    $end = completeDate($_GET['end'], true, $defaultDate);
    $proba = $_GET['proba'];
    $nbPhotos = isset($_GET['nbPhotos']) ? $_GET['nbPhotos'] : 500;

    $user_unique_id = getUserUniqueId($user);

    $sqlSelectTagByUser = "SELECT `pd`.`timestamp`, `pd`.`photo_id`, `pd`.`photo_tag_id` " .
    " , `ph`.`url` " .
    " FROM `".$userTaggingTable."` pd, `photos` ph " .
    "WHERE pd.user_unique_id = '". $user_unique_id ."' " .
    "AND pd.photo_tag_id < 3 " .
    " AND ph.photo_id=pd.photo_id " ;

    if ($begin != "")
        $sqlSelectTagByUser .= "AND pd.timestamp >= '".$begin."'   ";

    if ($end != "")
    	$sqlSelectTagByUser .= "AND pd.timestamp <= '".$end."'   ";


    if ($debug)
        $html .= $sqlSelectTagByUser . "<br>\n";

    $result = mysql_query($sqlSelectTagByUser) or die('Échec de la requête : ' . mysql_error() . ", sqlSelectTagByUser has a Pb : " . $sqlSelectTagByUser);
    $end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

    $i = 0;
    $outputData = "";

    $beginHistoricalForGnuplot = "";
    $endHistoricalForGnuplot = "";
    $formatTime = "d-m-Y H:M:S";
    $arrayPhotoIds = array();
    $arrayUrl = array();

    while ($array = mysql_fetch_row($result))
    {
        $date = $array[0];
        $photo_id = $array[1];
        $photo_tag_id = $array[2];
        $url = $array[3];
        if ($date != "0000-00-00 00:00:00")
//        if ($date != "0000-00-00")
{
//       $dateToFormat = DateTime::createFromFormat( $formatTime, $date);
  //      $CountToTime[$i] = $dateToFormat->format('U');

       $dateToFormat =  new DateTime($date);
       $CountToTime[$i] = $dateToFormat->format('U');
       $arrayPhotoIds[$i] = $photo_id;
       $arrayUrl[$i] = $url;

//       $dateToFormat = date_parse_from_format('d-m-Y H:M:S', $date);
//        $CountToTime[$i] = date_format($dateToFormat, 'U');

        $date = str_replace (" ", "_", $date);
        $outputData .= $date. " ".$i."\n";
        if ($beginHistoricalForGnuplot == "")
        {
            $beginHistoricalForGnuplot = $date;
        }
        $endHistoricalForGnuplot = $date;
}

//        echo "You have this amount of different tag : ". $array[0] ."<br>";
        $i++;
    }

    $beginHistoricalDateTime = str_replace ("_", " ", $beginHistoricalForGnuplot);
    $endHistoricalDateTime = str_replace ("_", " ", $endHistoricalForGnuplot);

    $nbTag = $i;
    $beginHistoricalTimeStamp = $CountToTime[0];
    $endHistoricalTimeStamp = $CountToTime[$nbTag - 1];
    $interval = ($endHistoricalTimeStamp - $beginHistoricalTimeStamp);

    $fileName = "graph.data";
    file_put_contents($folderWorkGnuplot."/".$fileName, $outputData);

    $graphName = "sample.gif";

    $gnuplotCommand = "";
    $gnuplotCommand .= "set timefmt \"%Y-%m-%d_%H:%M:%S\" \n";
    $gnuplotCommand .= "set xdata time \n";

//    $gnuplotCommand .= "set xrange ['2013-05-14-00:00:00': '2013-05-16-00:00:00']\n";

     $gnuplotCommand .= "set xrange ['".$beginHistoricalForGnuplot."': '".$endHistoricalForGnuplot."']\n";

//    $gnuplotCommand .= "set xtics format \"%b %y %H h\" \n";

    $discretizationTic = 3600;
    if ($interval < 10000)
    {
       $discretizationTic = 600;
       $gnuplotCommand .= "set xtics format \" %H h %M mn\" \n";
    }
    else if ($interval < 100000)
    {
          $discretizationTic = 7200;
       $gnuplotCommand .= "set xtics format \" %H h\" \n";
    }
    else
    {
           $discretizationTic = 21600;
       $gnuplotCommand .= "set xtics format \"%d %b %Y %H h\" \n";
    }

   // intval($interval / 10)
// $discretizationTic
    $gnuplotCommand .= "set xtics \"$beginHistoricalForGnuplot\", " . intval($discretizationTic) . ", \"$endHistoricalForGnuplot\" \n";

    $gnuplotCommand .= "set term gif \n";
    $gnuplotCommand .= "set output '".$folderWorkGnuplot."/".$graphName."' \n";
//    $gnuplotCommand .= "set logscale y \n";
    $gnuplotCommand .= "set title 'How did $user worked between \\n $beginHistorical and $endHistorical' \n";
    $gnuplotCommand .= "set grid \n";
    $gnuplotCommand .= "plot '".$folderWorkGnuplot."/"."graph.data' u 1:2 w l\n";

    $gnupotCommandName = "gnuplotCommand.cm";

    file_put_contents($folderWorkGnuplot."/".$gnupotCommandName, $gnuplotCommand);

    $cmd = "gnuplot '".$folderWorkGnuplot."/".$gnupotCommandName."'  - &";

    echo "cmd : ". $cmd."<br>\n";

    $output = "";
    exec($cmd, $output);
    for ($i = 0; $i < count($output) ; $i++)
    {
        echo $output[$i]."<br>\n";
    }

    $html .= "<img src='" . $folderWorkGnuplot."/".$graphName . "' alt='Work' height='500' width='500' >"; 

    $numberDiscretization = 10;
    $interval = ($nbTag) / $numberDiscretization;

    $html .= " i : " . $nbTag . "<br>\n";
    $html .= " interval : " . $interval . "<br>\n";

    $Nis = array();
    $idsBegin = array();
    $precCount = 0.;
    $SumNi2 = 0.;

    $outputDebug = "";
    for ($j = 0; $j < $numberDiscretization; $j++)
    {
        $idx = $j * $interval;
        $currCount = $CountToTime[$idx];
        $outputDebug .= $idx . "  " . $currCount . "<br>\n";

        array_push($idsBegin, $currCount);

        if ($j > 0)
        {
    		$outputDebug .= " currCount : " . $currCount . "<br>\n";
    		$outputDebug .= " precCount : " . $precCount . "<br>\n";
        	$Ni = ($currCount - $precCount);
            array_push($Nis, $Ni);
            $SumNi2 += $Ni * $Ni;
        }
        $precCount = $currCount;
    }

/*
We have t_i instant of tagging.
We have N_i for different interval with Sum N_i = N, number of tag.

We have p a probability of tag to take.

We want to select p_i such that Sum p_i N_i = p N but with p_i / N_i = lambda constant.
p_i = lambda N_i

We want 
lambda SUM N_i^2 = p N

therefore lambda = p * N / (SUM N_i^2)

p_i = p * N * N_i / (SUM N_i^2)
*/

    $maxRand = getrandmax();
    $selectedIds = array();

/*
    $lambda = $proba * $nbTag / $SumNi2;
    for ($i = 0; $i < $numberDiscretization - 1; $i++)
    {
    	$currentProba = $Nis[$i] * $lambda;
    	if ($currentProba > 0.)
    	{
    	    $intervalI = ($Nis[$i] + 0.) / $currenProba;
            $numberChoosen = $currenProba * $Nis[$i];
    		$outputDebug .= " Nis[$i] : " . $Nis[$i] . "<br>\n";
    		$outputDebug .= " numberChoosen : " . $numberChoosen . "<br>\n";
    		$outputDebug .= " intervalI : " . $intervalI . "<br>\n";
    		$outputDebug .= " currentProba : " . $currentProba . "<br>\n";

            for ($j = 0; $j < $numberChoosen; $j++)
            {
    	        $id = $idsBegin[$i] + $j * $intervalI;
    	        array_push($selectedIds, $arrayPhotoIds[$id]);
    	    }
            // $arrayPhotoIds[$i]
    	}
    }
    */

    // $arrayPhotoIds[$i] = $photo_id;
    // $arrayUrl[$i] = $url;

    $selectedUrls = array();
    for ($id = 0; $id < sizeof($arrayPhotoIds); $id++)
    {
    	if (count($selectedIds) >= $nbPhotos)
    	{
    	    break;
    	}
        if (rand() < $proba * $maxRand)
        {
            array_push($selectedIds, $arrayPhotoIds[$id]);
            array_push($selectedUrls, $arrayUrl[$id]);
        }
    }

    $xmlOutputFile = createXmlContent($selectedIds, $selectedUrls);


    $time = isset($_GET['ts']) ? $_GET['ts'] : time(0);
    $filePath = "listPhotos/" . $keyUserConnected . "_" . $time;
    mkdir($filePath);
    $fileName = $filePath . ".xml";
    file_put_contents($fileName, $xmlOutputFile);

    $html .="<a href='$fileName' >Download xml file for Quality sheikh !</a><br>\n";

    $querySelectedIds = dirname($_SERVER['PHP_SELF']) . "?";
    $nbSelectedPhoto = sizeof($selectedIds);
    $querySelectedIds .= "nbPhotos=" . $nbSelectedPhoto;
    /*
    for ($i = 0; $i < $nbSelectedPhoto; $i++)
    {
        $querySelectedIds .= "&ids[" . $i . "]=" . $selectedIds[$i];
    }
    */
    //$querySelectedIds .= "&selectedIds=" . urlencode(serialize($selectedIds));
    $querySelectedIds .= "&selectedIds=" . implode(",", $selectedIds);

    echo "  strlen querySelectedIds (should be smaller than 10000 to work ! ) " . strlen($querySelectedIds) . "<br>\n";

//    $html .= "<a href='" . $querySelectedIds . "' >Tag selected Photos then compare with the form below</a><br><br>\n";
    $html .= "http://" . $_SERVER['HTTP_HOST'] . $querySelectedIds . "<br>\n";



   $user_unique_id = getUserUniqueId($user);
if (isset($_GET['nbPhotoHistUser']))
{

   $html .= "Just for $user : ";

    $QueryNumberPhoto = "SELECT Date(timestamp), photo_tag_id, count(*) "
       . " FROM WayWay.user_photo_categorizations "
       . " WHERE user_unique_id='".$user_unique_id."' "
       . " AND photo_tag_id < 3 "
       . " GROUP BY Date(timestamp), photo_tag_id "
       . " ORDER BY Date(timestamp) desc, photo_tag_id; ";

$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

    $result = mysql_query($QueryNumberPhoto) or die('Échec de la requête : ' . mysql_error() . ", QueryNumberPhoto : " . $QueryNumberPhoto);

$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

    $total = 0;
    $outputNumerPhoto = "";
    $arrayCountByTag = array();
    $arrayCountByTag[0] = 0;
    $arrayCountByTag[1] = 0;
    $arrayCountByTag[2] = 0;
    while ($array = mysql_fetch_row($result))
{
	$nbFromSelect = $array[2];
	$tagFromSelect = $array[1];
    $total += $nbFromSelect;
    $arrayCountByTag[$tagFromSelect] += $nbFromSelect;

    $outputNumberPhoto .= $array[0]. " : " .$tagFromSelect . " : " .$nbFromSelect. "<br>\n";
//        echo "You have this amount of tag made by both : ". ($array[0]) ."<br>";
    //echo "You have this amount of tag made bu both : ". mysql_num_rows($result) ."<br>";
}

    $html .= "The guy tagged altogether : " .  $total . " photos <br>\n";
    $html .= print_r($arrayCountByTag, true) . "<br>\n";
    $html .= $outputNumberPhoto;
    
}
}


if ($checkAuto)
{
    $html .= "WE CHECK AUTO <br>\n";
    $sqlSelectCheckAuto = "SELECT ph.photo_id, ph.url, pd.custom_description FROM photos ph, photo_descriptions pd "
    . " WHERE ph.photo_id=pd.photo_id AND pd.custom_description<>'' LIMIT $limit OFFSET $offset ; ";

    $html .= "$sqlSelectCheckAuto <br>\n";

    $result = mysql_query($sqlSelectCheckAuto) or die('Échec de la requête : ' . mysql_error(). $sqlSelectCheckAuto);

$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

    $tableOutput = "";
    $tableOutput .= "<table id='autoTagginPhotoTable' ><br>\n";

    $sizePhoto = 100;

    $i = 0;

        $cascadeKeys = array();

    while ($array = mysql_fetch_row($result))
    {
        $photo_id = $array[0];
        $url = $array[1];
        $custom_description = $array[2];
        $custom_description  = str_replace("'", "\"", $custom_description);
        $json = json_decode($custom_description, true);

//        print_r($json);
//        echo "$custom_description <br>\n";


        $NumberItems = $json['NumberItems'];

//        print_r($NumberItems);

        $nbCascadeClassifier = count($NumberItems);

  //      $key_json = array_keys($NumberItems);
	
        if ($i ==  0)
        {
            for ($j = 0; $j < $nbCascadeClassifier; $j++)
            {
                $keys = array_keys($NumberItems[$j]);
                array_push($cascadeKeys, $keys[0]);
            }
        }

        if (($i % 10)  == 0)
	{
             $tableOutput .= "<tr>";
		    $tableOutput .= "<td>";
		    $tableOutput .= "Images";
		    $tableOutput .= "</td>";

                    $tableOutput .= "<td>";
                    $tableOutput .= "Photo Id";
                    $tableOutput .= "</td>";

		    for ($j = 0; $j < $nbCascadeClassifier; $j++)
		    {
			    $tableOutput .= "<td>";
		        $tableOutput .= $cascadeKeys[$j];
			    $tableOutput .= "<td>";
		    }
		    $tableOutput .= "</tr>";
	    }

	    $tableOutput .= "<tr>";
	    // <td>
		$tableOutput .= "<td>";
        $tableOutput .= "<img src='" . $url . "' alt='Photo Instagram' height='$sizePhoto' width='$sizePhoto' >";
		$tableOutput .= "</td>";
        $tableOutput .= "<td>$photo_id</td>";
        for ($j = 0; $j < $nbCascadeClassifier; $j++)
        {
//			$keyJson = $NumberItems->key($j);
            $tableOutput .= "<td>";
            
//            $tableOutput .= print_r($NumberItems[$j], true);
            $tableOutput .= $NumberItems[$j][$cascadeKeys[$j]];
             $tableOutput .= "<td>"; 
        }
        $tableOutput .= "</tr>";

        $photo_id. " " . $custom_description. "<br>\n";
        $i++;
    }
    $tableOutput .= "</table><br>\n";

    $html .= $tableOutput;
}






if ($listUsers)
{
    $sqlSelectUser = "SELECT DISTINCT `key` FROM `users`; ";
    $result = mysql_query($sqlSelectUser) or die('Échec de la requête : ' . mysql_error());

$end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

    $listUser = Array();
    while ($array = mysql_fetch_row($result))
    {
        if ($array[0] != "")
        {
            array_push($listUser, $array[0]);
        }
    }

    $html .= "<br><br>Check one user and prepare Quality assurance <br>\n";

    $formOutput = "";

    $formOutput .= "<form method=GET  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutput .= "<input name=studyUser value=plop type=hidden /><br>\n";
    $formOutput .= "User <select name=user >".buildChoiceList($listUser, $user)."</select><br>\n";
    $formOutput .= "Begin  <input name=begin value='".($beginHistoricalDateTime == "" ? $defaultDate : $beginHistoricalDateTime)."'  />(opt : ' H:M:S')<br>\n";
    $formOutput .= "End  <input name=end value='".($endHistoricalDateTime == "" ? $defaultDate : $endHistoricalDateTime)."'  />(opt : ' H:M:S')<br>\n";
    $formOutput .= "Proba Selection <input name=proba value='".$defaultProba."'  />(between 0 and 1)<br>\n";
    $formOutput .= "Number Photos Maximum <input name=nbPhotos value='500'  />(Integer)<br>\n";
    $formOutput .= "<input type='checkbox' name='nbPhotoHistUser' value='nbPhotoHistUser'>Get Historical Number Of Photo Tagged Altogether<br>";
    $formOutput .= "<input type=submit value=study  ><br>";
    $formOutput .= "</form><br>\n";

    $html .= $formOutput;


    $html .= "<br><br>Compare between users <br>\n";

    $formOutput = "";

    $formOutput .= "<form method=GET  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutput .= "<input name=compareUsers value=plop type=hidden /><br>\n";
    $formOutput .= "First User <select name=user1 >".buildChoiceList($listUser, $user)."</select><br>\n";
    $formOutput .= "Second User <select name=user2 >".buildChoiceList($listUser, '')."</select><br>\n";
    $formOutput .= "Begin (For First User)  <input name=begin value='".($beginHistoricalDateTime == "" ? $defaultDate : $beginHistoricalDateTime)."'  />(opt : ' H:M:S')<br>\n";
    $formOutput .= "End  (For First User) <input name=end value='".($endHistoricalDateTime == "" ? $defaultDate : $endHistoricalDateTime)."'  />(opt : ' H:M:S')<br>\n";
    $formOutput .= "<input type=submit value=compare  >";
    $formOutput .= "</form><br>\n";

    $html .= $formOutput;


    $formOutput = "";

    $formOutput .= "<form method=GET  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutput .= "<input name=checkAuto value=plop type=hidden /><br>\n";

    $formOutput .= "<input type=submit value=CheckAuto  ><br>";
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
