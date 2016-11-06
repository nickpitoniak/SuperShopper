<?php

$databaseName = "pantry";
$databaseHost = "localhost";
$databasePassword = "";
$databaseUsername = "root";

mysql_connect($databaseHost, $databaseUsername, $databasePassword)
	or die ("DatabaseError");
mysql_select_db($databaseName) 
	or die ("DatabaseError");

// check that username does not exist
	//create user

?>