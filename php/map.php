<?php
error_reporting(E_ERROR | E_WARNING | E_PARSE);
include('include/open_db.php');

$xml = isset($_GET['xml']);
$omb = isset($_GET['omb']);

$getCoor = 1; // isset($_GET['getCoor']);

$nbPlacesDefault = 100;
$offsetPlaceDefault = 0;


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
{
    header("Content-type: text/xml; charset=utf-8");
    header("Access-Control-Allow-Origin:*");
    header("Access-Control-Request-Method:*");
}

$xmlOut = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";

if (!$xml)
{
?>
<script language="javascript" SRC="script/md5.js"></script>
</head>
<body>
<br>
<br>
<?php
}

$html = "";


//if ($getCoord)
{
    $nbPlaces = isset($_GET['nbPlaces']) ? $_GET['nbPlaces'] : $nbPlacesDefault;
    $offsetPlace = isset($_GET['offsetPlace']) ? $_GET['offsetPlace'] : $offsetPlaceDefault;


$AndCoordinate = "";


    if (isset($_GET['a']))
    {
$AndCoordinate =  " `pl`.`longitude` < ".$_GET['d']." " .
          " AND `pl`.`longitude` > ".$_GET['c']."  " .
          " AND `pl`.`latitude` < ".$_GET['b']."  " .
         " AND `pl`.`latitude` > ".$_GET['a']." ";
}

if ($omb)
{
    $sqlSelectCoordinate = "SELECT `pl`.`name`, `pl`.`longitude`, `pl`.`latitude`, " .
" log(s.value)/(SELECT max(log(value)) FROM omb_scores) * 100 , `pl`.`omb_place_id` ".
"  FROM `".($omb ? "omb_" : "")."places`  pl , omb_scores s " .
" WHERE s.omb_place_id = pl.omb_place_id ".
( $AndCoordinate != "" ? " AND " . $AndCoordinate  : "") .
" ORDER BY s.value desc  ";


}
else
{
    $sqlSelectCoordinate = "SELECT `pl`.`name`, `pl`.`longitude`, `pl`.`latitude`, 0, `pl`.`place_id`  FROM `".($omb ? "omb_" : "")."places`  pl ";

    if ($AndCoordinate != "")
{
        $sqlSelectCoordinate .= " WHERE " . $AndCoordinate;
}

}


    $sqlSelectCoordinate .= 
//"  ORDER BY `pl`.`name` " .
    "LIMIT " . $nbPlaces . " OFFSET ".$offsetPlace ;

    $html .= $sqlSelectCoordinate . "<br>\n";

    $result = mysql_query($sqlSelectCoordinate) or die('Échec de la requête : ' . mysql_error() . $sqlSelectCoordinate);

    $xmlOut .= "<places>";
     $i = 0;
    while ($array = mysql_fetch_row($result))
    {
        $xmlOut .= "<place$i>";
        $xmlOut .= "<name$i>";
        $xmlOut .= "<![CDATA[";
        $xmlOut .=  $array[0];
        $xmlOut .= "]]>";
        $xmlOut .= "</name$i>";
        $xmlOut .= "<longitude$i>";
        $xmlOut .=  $array[1];
        $xmlOut .= "</longitude$i>";
        $xmlOut .= "<latitude$i>";
        $xmlOut .=  $array[2];
        $xmlOut .= "</latitude$i>";
//if ($omb)
{
    
        $xmlOut .= "<score$i>";
        $xmlOut .=  $array[3];
        $xmlOut .= "</score$i>";
}

        $xmlOut .= "<id$i>";
        $xmlOut .=  $array[4];
        $xmlOut .= "</id$i>";


        $xmlOut .= "</place$i>\n";

        $html .= "Place $i : $array[0] : lat " . $array[1] . " long : " . $array[2] ." ";
         if ($omb)
{
$html .= " score : " . $array[3];
}

$html .= "<br>\n";

        $i++;
    }
    $xmlOut .= "</places>";

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
