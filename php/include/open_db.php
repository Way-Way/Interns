<?php
// Victor Reutenauer 30-08-2006 - 3-10-3013
//if ($_SERVER['HTTP_HOST']=="www.reutenauer.eu") {
	$login = "root";
	$password = "renxiao";
        $servername = "intern.sql.omblabs.org";
	$dbname = "WayWay" ;  /// sur free peut etre n'importe quoi
	$db=mysql_connect($servername,$login,$password);
	if(!$db){
		print "erreur connection $db  ".mysql_error()." <br>"; 
		exit;
	}

	if(!mysql_select_db($dbname,$db))
	{  // Cela n'a vraiemnt l'air de servir a rien, ah ha ah
		print "erreur ".mysql_error()."<br>";
		mysql_close($db);
		exit;
	}
	else
	{
		define ("utf8", true);  // pour le php
		mysql_query("SET NAMES, 'utf8'");
		mysql_query( "SET CHARACTER SET utf8" ) ;  // tres important !!	
		mysql_query('SET character_set_client = utf8') ;
   $result = mysql_query('SET character_set_results = utf8') ;
   $result = mysql_query('SET character_set_connection = utf8') ;
	}

	unset($login, $password, $servername, $dbname) ;
//}
?>
