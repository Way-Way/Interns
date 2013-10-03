<?php
include('include/open_db.php');
include('include/utilities.php');

$xml = isset($_GET['xml']);
$omb = isset($_GET['omb']);

$studyPlace = isset($_GET['id']);
$idPlace = $studyPlace ? $_GET['id'] : "";

$getPicture = 1;
$getMenu = 1;

// VR 28-6-13 : here we study the city metrics per each date, in city.php we will study them for all step to be published
$studyCity = isset($_GET['city']);

if (!$xml)
{
?>
<meta http-equiv="content-type" content = "text/html ; charset =utf-8" />
<html>
<head>
<title>Omb Labs Menu Matching</title>
<?php
}
else
    header("Content-type: text/xml; charset=utf-8");

$xmlHeader = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
$html = "";

if ($getMenu)
{
	$FoursqId = $idPlace;
	if ($omb)
	{
        $select4SqEq = "SELECT et.omb_place_id, et.place_id FROM equivalence_table et, places pl " .
        " WHERE et.et.omb_place_id = '" . $idPlace . "' ".
        " AND pl.sourcename='Foursquare' ".
        " ;";
        $result = mysql_query($select4SqEq) or die('Échec de la requête : ' . mysql_error()). $select4SqEq;
        while ($array = mysql_fetch_row($result))
        {
            $FoursqId = $array[1];
            $html .= " 4sqId : " . $FoursqId . " <br>\n";
        }
	}

    $selectJsonMenu = " SELECT custom_description ".
                      " FROM descriptions  ".
     	" WHERE place_id='". $FoursqId ."' " .
     	"; ";
    $result = mysql_query($selectJsonMenu) or die('Échec de la requête : ' . mysql_error()). $selectJsonMenu;
    while ($array = mysql_fetch_row($result))
    {
    	$jsonMenuString = $array[0];
    }

     $html .= " jsonMenuString : " . $jsonMenuString . " <br>\n";
    $jsonMenuString = str_replace ( "'" , "\"" , $jsonMenuString);
    // $html .= " jsonMenuString : " . $jsonMenuString . " <br>\n";

    $jsonMenuArray = json_decode($jsonMenuString, true);
    $jsonMenuJson = json_decode($jsonMenuString);
    //$html .= " jsonMenu as it : " . $jsonMenu . "<br>\n";

      $html .= " jsonMenuArray : " . print_r(array_keys($jsonMenuArray), true) . "<br>\n";

    $html .= " count(jsonMenuArray) : " . count($jsonMenuArray) . " <br>\n";
    
     //$html .= " jsonMenuJson : " . $jsonMenuJson . " <br>\n";


    // $html .= " jsonMenuJson->{'menus'} : " . ($jsonMenuJson->{'menus'}) . " <br>\n";
   // $html .= " count(jsonMenu) : " . count($jsonMenuJson->{'menus'}) . " <br>\n";
//    $menus = $jsonMenu->{'menus'};
//    $html .= " count(menus) : " . count($menus) . " <br>\n";
    // $html .= " jsonMenu-> 'menus' : " . $jsonMenu->{'menus'}->count() . " <br>\n";

    $html .= " jsonMenuArray : " . print_r(array_keys($jsonMenuArray['menus']), true) . "<br>\n";
    $html .= " jsonMenuArray : " . print_r(array_keys($jsonMenuArray['menus'][0]), true) . "<br>\n";
    $html .= " count jsonMenuArray entries : " . count(array_keys($jsonMenuArray['menus'][0]['entries'])) . "<br>\n";

    $nbEntries = count(array_keys($jsonMenuArray['menus'][0]['entries']));

    // title, desc
    $listItems = array();
    for ($i = 0; $i < $nbEntries; $i++)
    {
        $html .= " count jsonMenuArray entries : " . count(array_keys($jsonMenuArray['menus'][0]['entries'][$i])) . "<br>\n";
        $html .= " count jsonMenuArray entries : " . print_r(array_keys($jsonMenuArray['menus'][0]['entries'][$i]), true) . "<br>\n";

        $entry = $jsonMenuArray['menus'][0]['entries'][$i];
        $html .= "title : " . $entry['title'] . "<br>\n";
        $html .= "name : " . $entry['name'] . "<br>\n";
        $html .= "type : " . $entry['type'] . "<br>\n";
        $html .= "orderNum : " . $entry['orderNum'] . "<br>\n";
        $html .= "desc : " . $entry['desc'] . "<br>\n";
        $html .= "id : " . $entry['id'] . "<br>\n";

        $id = $entry['id'];
        $item = $entry['title'] . " " . $entry['desc'];
        $listItems[$id] = $item;
    }



function displayList($listItems)
{
    $selectList = "<input type=select name=menu_item >";
	$keys = array_keys($listItems);
    for ($i = 0; $i < count($keys); $i++)
    {
        $selectList .= "<option value='".$keys[$i]."' >".$listItems[$keys[$i]]."</option>";
    }
    $selectList .= "</input>";
}



/*
    $key3 = $json->{'user'}->{'username'};
    $key4 = $json->{'user'}->{'full_name'}; 
    */

}

if ($getPicture)
{
	if ($omb)
	{
            $selectPictureFromThisPlace = " SELECT ph.omb_photo_id, ph.omb_place_id, ph.url, ph.category FROM omb_photos ph " .
            "  WHERE ph.omb_place_id='" . $idPlace . "' " .
            "  AND photo_tag='FOOD'   " .
            " ; ";
	}
	else
	{
            $selectPictureFromThisPlace = " SELECT DISTINCT ph.photo_id, ph.place_id, ph.url, u.photo_tag_id " .
            " FROM photos ph, user_photo_categorizations u " .
            " WHERE ph.place_id='" . $idPlace . "' ".
            " AND u.photo_id=ph.photo_id " .
            " AND u.photo_tag_id='1' " .
            " ; ";
	}

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
	    for ($i = 0; $i < count($ids); $i++)
	    {
		    $link = "metrics.php?id=" . $place_ids[$i] . ($omb ? "&omb" : "");
//                    echo  " : " .  $urls[$i] . "<br>\n";
		    $html .= "<a  href='$link' ><img src='" . $urls[$i] . "' alt='$ids[$i]' height='300' width='300' /></a>".$ids[$i].", ".$tags[$i]."<br>\n";
		    $html .= "<form target=".$_SERVER['PHP_SELF']." >";
		    $html .= displayList($listItems);
		    $html .= "<input type=submit value= />";
		    $html .= "</form>";
	    }
    }
}

$html .= "<br>\n";
$html .= "<br>\n";
$html .= "<br>\n";

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
