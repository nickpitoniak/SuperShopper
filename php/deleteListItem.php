<?php
$username = $_REQUEST["username"];
$UPC = $_REQUEST["UPC"];

$databaseName = "pantry";
$databaseHost = "localhost";
$databasePassword = "";
$databaseUsername = "root";

mysql_connect($databaseHost, $databaseUsername, $databasePassword)
	or die ("DatabaseError");
mysql_select_db($databaseName) 
	or die ("DatabaseError");

$deleteQuery = "DELETE FROM foodWatch WHERE watcher='" . $username . "' AND productId='" . $UPC . "'";
echo $deleteQuery;
$result = mysql_query($deleteQuery);

if($result) {
	echo "Success";
} else {
	echo mysql_error($result);
	echo "Error";
}

?>