<?php
$batch = (isset($_SERVER['USER']));
// && $_SERVER['USER'] == "victor");
//if (isset($_SERVER['USER']) && $_SERVER['USER'] == "victor")
if ($batch)
{
    parse_str(implode('&', array_slice($argv, 1)), $_GET);
    print_r($_GET);
/*
    $keysGets = array_keys($_GET);
    for ($i = 0; $i < count($keysGets); $i++)
    {
        echo " $i : " . $keyGets[$i] . " : " .$_GET[$keyGets[$i]]."   <br>\n";
    }
*/
//    echo " argv : " . $argv."<br>\n";
}

error_reporting(E_ERROR | E_WARNING | E_PARSE);
include('include/open_db.php');
include('include/utilities.php');

$userTaggingTable = "user_photo_categorizations";
$tag_photo_column = "photo_tag_id";

$debugger_email = "inscription@moilerat.com";

$default_user_unique_id = 0;


$howManyPhotos = 1000;
$logFile = "sessions.tag.log";
//$defaultCity = "Manhattan";
$defaultCity = "New York";
//echo "Hello<br>\n";

$xml = isset($_GET['xml']);
//echo " xml : $xml  <br>\n";
$debug = isset($_GET['debug']);

$doListPhotos = isset($_GET['photos']);
$tag = isset($_GET['tag']) ? $_GET['tag'] : "";
$idToTag = isset($_GET['id']) ? $_GET['id'] : "";

$tagPhoto = isset($_GET['tag']) || isset($_GET['tags']);

$whoami = isset($_GET['whoami']) ? $_GET['whoami'] : "";
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : "";

$getPhotos = isset($_GET['getPhotos']) || (!$xml && !$tagPhoto);

$mailSession = isset($_GET['session_start']);

$listPhotos = isset($_GET['selectedIds']);

$dontUpdate = isset($_GET['dontUpdate']);

$outputEmail = $xml && !$getPhotos && !$mailSession;

$WaitingForTagging_Four = 4;
$ToBeTagged_Five = 5;
// People : 0
// Food : 1
// Feel : 2
// Error_loading : 3
// Waiting_For_Tagging : 4
// TO_BE_TAGGED : 5

function getTimeStamp()
{
    $now = new DateTime();
    return $now->format('Y-m-d G:i:s');
//.'.'.$now->millisecond;
}


function getTimeFromMilliSecond($milliSecond)
{
    return date('Y-m-d G:i:s', $milliSecond / 1000);
}

if (!$xml)
{
?>
 <meta http-equiv="content-type" content = "text/html ; charset =utf-8" />
<html>
<head>
  <title>Omb Labs Photo Categorization Interface Server Side</title>
<?php
}
else
    header("Content-type: text/xml; charset=utf-8");


$xmlHeader = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";

//include('style/format.css') ;
//include('script/library.js') ;

if (!$xml)
{
?>
</head>
<body>
<br>
<br>
<br>
<br>
<?php
}

$html = "";

$ip = $_SERVER['REMOTE_ADDR'];
$browser = $_SERVER['HTTP_USER_AGENT'];

$key = getKeyUser($ip, $browser);

if ($key == "")
{
    $insert_current_user_id = "INSERT IGNORE INTO `WayWay`.`users` ( `ip` , `browser` , `key`, `timestamp`)  VALUES (\"". $ip ."\", \"". $browser ."\", \"". $whoami ."\" , '".getTimeStamp()."' ) ;";
    $html .=  $insert_current_user_id."<br>\n";
    mysql_query($insert_current_user_id);
}

 /* mail('inscription@moilerat.com','phpinfo',phpinfo(),'From : phpinfo@zeroemission.fr') ; */

if ($outputEmail)
//($xml && !$getPhotos)
{
    $xmlOut .= "<email>";
    $xmlOut .= $key;
    $xmlOut .= "</email>";
}


if ($whoami != "")
{
    $updateCurrentUser = "UPDATE `WayWay`.`users` SET `key` = '".$whoami."' WHERE `users`.`user_id` ='".$user_id."' ; ";

    mysql_query($updateCurrentUser);
    $html .= $updateCurrentUser."<br>\n";

    $key = $whoami;
}
else
    $whoami = $key;

$user_unique_id = getUserUniqueId($whoami);

if ($tagPhoto)
{

      $html .= "selectUserUniqueId : $selectUserUniqueId";

    if (isset($_GET['tag']))
    {
     $tags = array(0 => $tag);
    $ids = array(0 => $idToTag);
/*
        $insertTag = "INSERT INTO `".$userTaggingTable."` (`photo_id`, `".$tag_photo_column."` , `timestamp` , `user_id`, `user_unique_id`)"
        ." VALUES ( '" .$idToTag. "', '" .$tag. "', '".getTimeStamp()."', '" .$user_id. "' , '".$user_unique_id."');";

        $html .=  " " .$insertTag. "<br>\n";

        $result = mysql_query($insertTag) or die('Échec de la requête : ' . mysql_error() . " insertTag :  " .$insertTag);
        if ($result)
        {
            $html .=  " result : " . $result . "<br>\n";
            $xmlOutput .= "<log>";
            $xmlOutput .= $result;
            $xmlOutput .= "</log>";
        
*/
    }

    if (isset($_GET['tags']))
    {
    	$tagsToExplode = $_GET['tags'];
    	$idsToExplode = $_GET['ids'];

    	$html .=  "  tagsToExplode : " . $tagsToExplode . "<br>\n";
    	$html .=  "  idsToExplode : " . $idsToExplode . "<br>\n";

        //echo $html . "<br>\n";

        $tags = explode(",", $tagsToExplode);
        $ids = explode(",", $idsToExplode);
    }

    $insertTags = buildInsertTaggingQuery($ids, $tags, $user_id, $user_unique_id);

        $html .= $insertTags . "<br>\n";

        $result = mysql_query($insertTags) or die('Échec de la requête : ' . mysql_error() . " insertTags :  " .$insertTags);
        $nbAFfectedRows = 0;
        $taggingRecorded = 0;
        if ($result)
        {
            $html .=  " result : " . $result . "<br>\n";
            $nbAFfectedRows = mysql_affected_rows(); 
            $html .=  " number rows affected : " . $nbAFfectedRows . "<br>\n";
            $taggingRecorded = 1;
        }

        $xmlOut = "<xml><user>" . $xmlOut ."</user>";
        $xmlOut .= "<log>";
        $xmlOut .= "<TaggingRecorded>";
        $xmlOut .= ($taggingRecorded ? "YES" : "NO");
        $xmlOut .= "</TaggingRecorded>";
        $xmlOut .= "<nbAffectedRows>";
        $xmlOut .= $nbAFfectedRows;
        $xmlOut .= "</nbAffectedRows>";
        $xmlOut .= "</log>";
        $xmlOut .= "</xml>";

        //$xmlOutput .= "<User>" . $xmlOutput ."</User>";
//    }
}





if ($getPhotos)
{

    if ($debug)
    {
        $howManyPhotos  =10;
    }

    $city = isset($_GET['city']) ? $_GET['city'] : $defaultCity;
    $nbPhotos = isset($_GET['nbPhotos']) ? $_GET['nbPhotos']  : $howManyPhotos;
    $offsetPhotos = isset($_GET['offsetPhotos']) ? $_GET['offsetPhotos'] : 0;
    $initIdFile = isset($_GET['idFile']) ? $_GET['idFile'] : 0;
    $nbOfFiles = isset($_GET['nbFiles']) ? $_GET['nbFiles'] : 1;
    $time = isset($_GET['ts']) ? $_GET['ts'] : time(0);
    $tobetagged = isset($_GET['TBT']);

    if (!$xml && !$debug)
    {
        $sqlCountPhotoATagger =
        "SELECT COUNT(*) ".
        "FROM photos ph " .
        "WHERE NOT EXISTS (SELECT pd.photo_id FROM `".$userTaggingTable."` pd WHERE pd.photo_id=ph.photo_id);";

        $html.= $sqlCountPhotoATagger . "<br>\n";

        $result = mysql_query($sqlCountPhotoATagger) or die('Échec de la requête : ' . mysql_error() . " sqlCountPhotoATagger :  " .$sqlCountPhotoATagger);
        while ($array = mysql_fetch_row($result))
        {
            $html .=  $array[0] . "<br>\n";
            $html .=  "We still have this amount of photo un tagged : " . $array[0] . "<br>\n";
        }

        $sqlPlaceHistoricFinished = "SELECT count(*) FROM WayWay.descriptions WHERE photo_history_complete=1; ";
        $result = mysql_query($sqlPlaceHistoricFinished) or die('Échec de la requête : ' . mysql_error() . " sqlPlaceHistoricFinished :  " .$sqlPlaceHistoricFinished);
        while ($array = mysql_fetch_row($result))
        {
            $html .=  $array[0] . "<br>\n";
            $html .=  "We have this amount of place for which we got all the photo history : " . $array[0] . "<br>\n";
        }

        //echo $html;
    }

    $filePath = "listPhotos/" . $whoami . "_" . $time;
    mkdir($filePath);

    if (isset($_GET['nbFiles']))
    {
        echo "<a href='" . $filePath . "' >Please find the files here</a>";
    }

    // select id of the user
    $sqlSelectIdOfTheUser = "SELECT user_id FROM users WHERE `key` = '" . $key . "';";
    $result = mysql_query($sqlSelectIdOfTheUser) or die('Échec de la requête : ' . mysql_error() . " sqlSelectIdOfTheUser :  " .$sqlSelectIdOfTheUser);

    $listIdsThisUser = array();
    while ($array = mysql_fetch_row($result))
    {
    	array_push($listIdsThisUser, $array[0]);
    }

    $userCondition = "";
    for ($i = 0; $i < count($listIdsThisUser); $i++)
    {
    	if ($i > 0)
            $userCondition .= " OR ";

        $userCondition .= " pd.user_id = '" . $listIdsThisUser[$i] . "' ";
    }

    for ($idFile = $initIdFile; $idFile < $nbOfFiles; $idFile++)
    {
        $sqlCountPhotoATagger =
        " SELECT ph.`photo_id`, ph.`url` ".
        " FROM photos ph, places pl " .
        // "WHERE NOT EXISTS (SELECT pd.photo_id FROM `".$userTaggingTable."` pd WHERE pd.photo_id=i.photo_id AND pd.user_id = '" . $user_id . "' ) AND url <> '' LIMIT 15;";
        " WHERE `photo_id` NOT IN " .
        " (SELECT pd.photo_id FROM `".$userTaggingTable."` pd  WHERE `user_unique_id`='".$user_unique_id."'  )  ".
//         " (SELECT pd.photo_id FROM `".$userTaggingTable."` pd WHERE ".$userCondition." ) " .
        " AND url <> '' ".
        " AND pl.source_id = ph.foursquare_id ".
        " AND pl.city='" . $city . "' ";

        if ($tobetagged)
        {
            // Soon when using the photo to be tagged :
            $sqlCountPhotoATagger =
            "SELECT ph.`photo_id`, ph.`url`, upc.user_photo_categorization_id " .
            " FROM `photos` ph, `user_photo_categorizations` upc " .
            " WHERE upc.`photo_id` = ph.`photo_id` ".
            " AND upc.`user_unique_id`='" . $default_user_unique_id . "' ".
            " AND upc.`photo_tag_id`='" . $ToBeTagged_Five . "' ";
        }

        if (!$xml)
            echo $sqlCountPhotoATagger;

        if ($tobetagged)
        {
            $sqlCountPhotoATagger .= " LIMIT ".$nbPhotos. "; ";
        }
        else if (!$listPhotos)
        {
            $sqlCountPhotoATagger .= " LIMIT ".$nbPhotos. " OFFSET ".$offsetPhotos;
        }
        else
        {
            $nbPhotos = $_GET['nbPhotos'];
            //$ids = $_GET['ids'];

            $toUnSerialize = $_GET['selectedIds'];
            $html .= " toUnSerialize : " . $toUnSerialize ."<br>\n";
            $html .= " nbPhotos : " . $nbPhotos ."<br>\n";

            $selectedIds = explode(",", $toUnSerialize);
            $html .= " sizeof selectedIds : " . count($selectedIds) ."<br>\n";

            for ($i = 0; $i < count($selectedIds); $i++)
            {
                if ($i > 0)
                    $conditionList .= " OR ";

                    //$getArg = "ids[" . $i . "]"

                //$conditionList = " `pd`.`photo_id` = '".$_GET['$getArg']."' ";
                $conditionList .= " ph.`photo_id` = '".$selectedIds[$i]."' ";
            }
            $sqlCountPhotoATagger .= " AND (" . $conditionList . ") ";
        }

        $sqlCountPhotoATagger .= ";";

        $html .= $sqlCountPhotoATagger . "<br>\n";

        $result = mysql_query($sqlCountPhotoATagger) or die('Échec de la requête : ' . mysql_error() . ", sqlCountPhotoATagger : " . $sqlCountPhotoATagger . $html);

        if (mysql_num_rows($result) < $nbPhotos && $tobetagged)
        {
           if (!$xml)
           {
               echo "We stop to be tagged ! <br>\n";
           }
//	   $tobetagged = 0;
//	   $idFile--;
//	   continue;
           break;
        }
        $i = 0;

        $ids = array();
        $tags = array();
        $urls = array();
        $upc_ids = array();

        while ($array = mysql_fetch_row($result))
        {
            $photo_id = $array[0];
            $url = $array[1];
            $html .= "Photo : " . $array[0] . " " . $array[1] . "<br>\n";
            $html .= "<img src='" . $array[1] . "' alt='Photo Instagram' height='300' width='300' />\n"; 
        // height='42' width='42'
            $html .= "<a href='".$PHP_SELF."?id=".$array[0]."&tag=0' >People</a>   " ;
            $html .= "<a href='".$PHP_SELF."?id=".$array[0]."&tag=1' >Food and Drink</a>  " ;
            $html .= "<a href='".$PHP_SELF."?id=".$array[0]."&tag=2' >Feel</a>  " ;

            $html .= "<br>\n";

//            $ids[$i] = $array[0];
//            $tags[$i] = $WaitingForTagging_Four;

            array_push($ids, $photo_id);
            array_push($urls, $url);
            array_push($tags, $WaitingForTagging_Four);
            if ($tobetagged)
             {
    array_push($upc_ids, $array[2]);
           }

            $i++;
        }

        $xmlOut = createXmlContent($ids, $urls);

        $fileName = $filePath . ".xml";
        file_put_contents($filePath . "/listPhotos" . $idFile . ".xml", $xmlOut);
        $offsetPhotos += $nbPhotos;

        // Now we tag the photo with 5 (WAITING_FOR_TAGGING) only if we are in xml mode
        if ($xml || $batch)
        {

//        	print_r($ids);
 //       	print_r($tags);
//if (!$xml)  
//echo ("   We need to take care and be sure we do not have selected tagge in 0,1 or 2 since the following will update on duplicate and therefore loose the tagging");
         
      $insertWaitingForTag = buildInsertTaggingQuery($ids, $tags, $user_id, $user_unique_id);

        if ($tobetagged)
        {
	        $deleteTagToBeTagged = "DELETE FROM `user_photo_categorizations` WHERE user_photo_categorization_id IN ";
	        for ($i = 0; $i < count($ids); $i++)
	        {
    if ($i == 0)
{
    $deleteTagToBeTagged .= "(";
}
else
        $deleteTagToBeTagged .= ", ";

//		        $deleteTagToBeTagged .= "DELETE FROM `user_photo_categorizations` " .
//		        " WHERE user_unique_id='". $default_user_unique_id."' AND photo_id='".$ids[$i]."'; ";
    $deleteTagToBeTagged .= $upc_ids[$i];
	        }
     $deleteTagToBeTagged .= ")";
	        mysql_query($deleteTagToBeTagged) or die('Échec de la requête : ' . mysql_error() . " deleteTagToBeTagged :  " .$deleteTagToBeTagged);

         if (!$xml)
         {
  //          echo  " deleteTagToBeTagged : " . $deleteTagToBeTagged . "<br>\n";
         }
        }

//echo $insertWaitingForTag . "<br>\n";

            $html .= $insertWaitingForTag . "<br>\n";

            $result = mysql_query($insertWaitingForTag) or die('Échec de la requête : ' . mysql_error() . " insertWaitingForTag :  " .$insertWaitingForTag);
            $nbAFfectedRows = 0;
            $taggingRecorded = 0;
            if ($result)
            {
        	    $html .=  " result : " . $result . "<br>\n";
                $nbAFfectedRows = mysql_affected_rows(); 
                $html .=  " number rows affected : " . $nbAFfectedRows . "<br>\n";
                $taggingRecorded = 1;
            }
        }
    }

    if ($nbOfFiles > 1)
        $html = "";

} // ask photo to tag


if ($mailSession)
{
    $user_mail = $key;

    $session_start = $_GET['session_start'];
    $session_end = $_GET['session_end'];
    $nbPhotoTagged = $_GET['nbPhotoTagged'];

    $session_start_datetime = getTimeFromMilliSecond($session_start - 5000);
    $session_end_datetime = getTimeFromMilliSecond($session_end + 5000);

    $mail = "victor@omblabs.co";
    $subject = "End Tagging Session For " . $key . "| ";
    $body = "This guy worked hard : " . $key . "| ";
    $body .= "session_start : " . $session_start . " " . $session_start_datetime  .  "| ";
    $body .= "session_end : " . $session_end . " " . $session_end_datetime . "| ";
    $body .= "nbPhotoTagged : " . $nbPhotoTagged . "| ";

    $selectTagInOurDataBase = "SELECT count(*) ". 
 "FROM WayWay.`".$userTaggingTable."`  " .
 "WHERE timeStamp > \"". $session_start_datetime ."\" ".
  "AND `timeStamp` < \"". $session_end_datetime ."\" ".
"AND `user_id` = \"". $user_id."\" ;";

    if (!$xml)
        echo $selectTagInOurDataBase."<br>\n";

    $numberPhotoTaggedInOurDataBase = 0;
    $result = mysql_query($selectTagInOurDataBase) or die('Échec de la requête : ' . mysql_error() . " selectTagInOurDataBase :  " .$selectTagInOurDataBase);
    while ($array = mysql_fetch_row($result))
    {
        $numberPhotoTaggedInOurDataBase = $array[0];
//    $html .=  $array[0] . "<br>\n";
//    $html .=  "We still have this amount of photo un tagged : " . $array[0] . "<br>\n";
}

    $body .= " numberPhotoTaggedInOurDataBase : " . $numberPhotoTaggedInOurDataBase ;

    $body .= "|rate per hour : " . ($nbPhotoTagged)/(($session_end - $session_start) / (3600 * 1000) ) ;

    $body .= "\n";
    file_put_contents($logFile, $body, FILE_APPEND | LOCK_EX);

    $res = "";
    if (!mail ($mail, $subject, $body, 'From : victor@reutenauer.eu'))
    {
        $res = "Mail wasn't sent ... \n";
    }
    else
    {
        $res = "Email was sent !";
    }

    mail ($user_mail, $subject, $body);

    $xmlOut .= "<email>";
    $xmlOut .= "<confirmation>";
    $xmlOut .= $res;
    $xmlOut .= "</confirmation>";
    $xmlOut .= "<body>";
    $xmlOut .= $body;
    $xmlOut .= "</body>";
    $xmlOut .= "</email>";


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
    echo $xmlHeader . $xmlOut;

include('include/close_db.php');
?>
