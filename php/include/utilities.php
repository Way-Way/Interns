<?php

//! used by tagging
function getUserUniqueId($whoami)
{
    $selectUserUniqueId = "SELECT min(user_id) FROM users WHERE `key`='".$whoami."'  ";
    $result = mysql_query($selectUserUniqueId) or die('Échec de la requête : ' . mysql_error() . 
         " selectUserUniqueId : " . $selectUserUniqueId . "<br>\n");
    $user_unique_id = -1;
    while ($array = mysql_fetch_row($result))
    {
        $user_unique_id = $array[0];
    }
    return $user_unique_id;
}

//! used by tagging
function buildInsertTaggingQuery($ids, $tags, $user_id, $user_unique_id)
{
	global $userTaggingTable, $tag_photo_column;

	$insertTagsFunc = "INSERT IGNORE INTO `".$userTaggingTable."` (`photo_id`, `".$tag_photo_column."` , `timestamp` , `user_id`, `user_unique_id`)"
        ." VALUES  ";
    for ($i = 0; $i < count($ids); $i++)
    {
    	if ($i > 0)
    	$insertTagsFunc .= ", ";

        $insertTagsFunc .= " ('" .$ids[$i]. "', '" .$tags[$i]. "', '".getTimeStamp()."', '" .$user_id ."', '".$user_unique_id."' ) ";
    }
    
    $insertTagsFunc .= " ON DUPLICATE KEY UPDATE `photo_tag_id`=VALUES(`photo_tag_id`), `timestamp`=VALUES(`timestamp`) ";
    $insertTagsFunc .= ";";

    return $insertTagsFunc;
}


//! used in tagging
    function createXmlContent($ids, $urls)
    {
        $xmlOut = "<photos>\n";

        for ($i = 0; $i < count($ids); $i++)
        {
            $photo_id = $ids[$i];
            $url = $urls[$i];

            $xmlOut .= "<photo".$i.">\n";
            $xmlOut .= "<id".$i.">";
            $xmlOut .= $photo_id;
            $xmlOut .= "</id".$i.">\n";
            $xmlOut .= "<url".$i.">";
            $xmlOut .= $url;
            $xmlOut .= "</url".$i.">\n";
            $xmlOut .= "</photo".$i.">\n";

        }
            $xmlOut .= "</photos>\n";
            return $xmlOut;
    }



    
//! used in tagging
function getKeyUser($ip, $browser)
{

$select_user_id = "SELECT `user_id`, `key` FROM `WayWay`.`users` WHERE `browser` = \"". $browser."\" AND `ip` = '".$ip."'; ";

$result = mysql_query($select_user_id) or die('Échec de la requête : ' . mysql_error());
$key = 0;
while ($array = mysql_fetch_row($result))
{
    //$html .= "Multiple user :" . $array[0] . " :  ".$array[1]."<br>\n";
    if ($user_id == "")
    {
        $user_id = $array[0];
        $key = $array[1];
    }
    //echo "We have this amount of metrics : " . $array[0];
}

return $key;
}

//! remove white space
function removeWhiteSpace($cityWithWhiteSpace)
{
    return str_replace (" ", "", $cityWithWhiteSpace);
}

//! buildChoiceList
function buildChoiceList($listUser, $selectedUser)
{
    $choiceList = "";
    for ($i = 0; $i < count($listUser); $i++)
    {
    	//echo " selectedUser :  " . $selectedUser."  listUser ".$listUser[$i]."<br>\n";
        $choiceList .= "<option value=\"".($listUser[$i])."\" " .($selectedUser == $listUser[$i] ? "selected" : "")."  >".$listUser[$i]."</option>\n";
    }

    return $choiceList;
}


?>
