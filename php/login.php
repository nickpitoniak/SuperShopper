<?php

$usernameURL = $_REQUEST['username'];
$passwordURL = $_REQUEST['password'];

$databaseName = "pantry";
$databaseHost = "localhost";
$databasePassword = "";
$databaseUsername = "root";

mysql_connect($databaseHost, $databaseUsername, $databasePassword)
	or die ("DatabaseError");
mysql_select_db($databaseName) 
	or die ("DatabaseError");

$loginSQL = "SELECT * FROM users WHERE username='" . $usernameURL . "' AND password='" . $passwordURL . "'";
$result = mysql_query($loginSQL);
if($result) {
	if(mysql_num_rows($result) == 0) {
		exit("DNE");
	} else {
		echo "Success";
	}
} else {
	exit("Error");
}


?>