<?php

error_reporting(E_ERROR | E_WARNING | E_PARSE);
include('include/open_db.php');
include('include/utilities.php');

$verbose = isset($_GET['verbose']);
$html = "";
if ($verbose)
{
    $html .= "Verbose mode ! <br>\n";
}

if (!$xml)
{
?>
 <meta http-equiv="content-type" content = "text/html ; charset =utf-8" />
<html>
<head>
    <title> Query Back - OMB LABS </title>
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

$query = "SELECT";
if ($_POST['query'])
{
    $query = $_POST['query'];
    $html .= $query . "<br>\n";

    $start = microtime(true);

    $result = mysql_query($query) or die('Échec de la requête : ' . mysql_error() . $query);

    $end = microtime(true); $startD = $start + 0.; $endD = $end + 0.; $difference = $endD - $startD; $html .= " elapsed :" . $difference . "| <br>\n "; $start = microtime(true);

    while ($array = mysql_fetch_row($result))
    {
    	$html .= print_r($array, true) . "<br>\n";
    }

}


// Form
{
    $html .= "<br><br>Query<br>\n";

    $formOutput = "";

    $formOutput .= "<form method=POST  action=".$_SERVER['PHP_SELF']." ><br>\n";
    $formOutput .= "<textarea name=query value=\"".$query."\" type=text cols='40' rows='5' style=\"width:200px; height:50px;\" > </textarea><br>\n";
    $formOutput .= "<input type=submit value=Query  >";
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
