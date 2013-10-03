<?php
include('include/open_db.php');


$xml = isset($_GET['xml']);
$app = isset($_GET['app']) ? $_GET['app'] : "";
$code = isset($_GET['code']) ? $_GET['code'] : "";

$addKey = 1;

?>
<meta http-equiv="content-type" content = "text/html ; charset =utf-8" />
<html>
<head>
<title>Omb Labs Registering App</title>
</head>
<body>
<br>
<?php

$html = "";

if ($addKey)
{
    $html .= $app."<br>\n";
    $html .= $code."<br>\n";

    // jSON URL which should be requested
    $json_url = 'https://api.instagram.com/oauth/access_token';

    // jSON String for request

    if ($app == "waywayrd")
    {
        $client_id = "7e704b3db2854b47b6c29b42a9bd36aa";
        $client_secret = "7b7436262ec04878817af19fe2643e10";
    }
    if ($app == "onmyway")
    {
        $client_id = "84036c1134e74f5fa64a575455286c89";
        $client_secret = "84ae4c0c47d440458575b0272294e6d8";
    }
    if ($app == "omblabs")
    {
        $client_id = "37727845e17a4f828776165c7dae4c08";
        $client_secret = "c912b0339e92439b8695658b22f7e357";
    }
    if ($app == "wayplop")
    {
       $client_id = "db2b0d685da64658bc1e853a7de4b0ae";
       $client_secret = "17a7177447d44fbba50034bff284f4f8";
    }
    if ($app == "waycool")
    {
        $client_id = "40a331f23dd3495680f7ee8af8a170ba";
        $client_secret = "0562ae2900384b6fad5bc7441f92c822";
    }

    $redirect = "http://".$_SERVER['SERVER_NAME'].$_SERVER['PHP_SELF'] . "?app=".$app;

    $json_string = "{\"client_id\":\"".$client_id."\", \"client_secret\":\"".$client_secret."\", "
      . " \"grant_type\":\"authorization_code\", \"redirect_uri\":\"".$redirect."\", \"code\":\"".$code."\" }";
    $json_string_post = "client_id=".$client_id."&client_secret=".$client_secret.
     "&grant_type=authorization_code&code=".$code."&redirect_uri=".$redirect;

    $html .= $json_string."<br>\n";

    // Initializing curl
    $ch = curl_init( $json_url );

    // Configuring curl options
    $options = array(
    CURLOPT_RETURNTRANSFER => true,
//    CURLOPT_USERPWD => $username . ":" . $password,   // authentication
    CURLOPT_HTTPHEADER => array('Content-type: application/json') ,
    CURLOPT_POSTFIELDS => $json_string_post);

    // Setting curl options
    curl_setopt_array( $ch, $options );

    // Getting results
    $result =  curl_exec($ch); // Getting jSON result string

//    print_r($result);
    $html .= $result;

     echo "$result<br>\n";

    if (0 == substr_count($result, "error"))
{
    $json = json_decode($result);

    $key1 = $json->{'access_token'};

    $key2 = $app;
    $key3 = $json->{'user'}->{'username'};
    $key4 = $json->{'user'}->{'full_name'}; 

    $insertQuery = "INSERT INTO `source_keys` (`sourcename`, `key1`, `key2`, `key3`, `key4`) VALUE ('Instagram', ".
    "'".$key1."', ".
   "'".$key2."', ".
   "'".$key3."', ".
   "'".$key4."'".
    ") ".
   " ON DUPLICATE KEY UPDATE key2=VALUES(key2), key3=VALUES(key3), key4=VALUES(key4);";

           $html .= $insertQuery . "<br>\n";

        $result = mysql_query($insertQuery) or die('Échec de la requête : ' . mysql_error() . " insertQuery : " .$insertQuery);
        $nbAFfectedRows = 0;
        if ($result)
        {
            $html .= " result : " . $result . "<br>\n";
            $nbAFfectedRows = mysql_affected_rows();
            $html .= " number rows affected : " . $nbAFfectedRows . "<br>\n";
        }
}
else
{
    echo "ERROR CONTACT VICTOR <br>\n";
}

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
