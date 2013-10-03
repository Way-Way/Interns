<?php
include('include/open_db.php');

$xml = isset($_GET['xml']);

$studyMissingMetrics = isset($_GET['missingmetrics'])

  /* Page functionalities:

- with $studyMissingMetrics, we look at the list of places which don't have any metrics recorded in our database. Here we hardcoded to look at Facebook in NY in alphabetical order of the places' names. Clicking on the links brings you on the facebook page of the place

   */

?>
<meta http-equiv="content-type" content = "text/html ; charset =utf-8" />
<html>
<head>
<title>Places with no metrics</title>
<script language="javascript" SRC="script/md5.js"></script>
</head>
<body>
<br>
<?php

if ($studyMissingMetrics)

{
{
	$sqlMissingMetrics = "SELECT pl.source_id, pl.name, pl.address, pl.place_id
FROM places as pl
WHERE city= 'New York'
AND pl.sourcename = 'Facebook'
AND pl.place_id NOT IN
(SELECT place_id FROM metric_headers)
order by pl.name
limit 1000;";
    }
    $result = mysql_query($sqlMissingMetrics) or die('Échec de la requête : ' . mysql_error()). $sqlMissingMetrics;

    while ($array = mysql_fetch_row($result))
    {
	$sourceid = $array[0];
	$name = $array[1];
    	$address = $array[2];
	$placeid = $array[3];

        echo "<a href='http://www.facebook.com/$sourceid'> $sourceid, <b> $name </b>, $address, $placeid, $sourceid    <br>\n <br>\n ";

 }
}
$html = "That's it ";

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
