<?php

$username = $_REQUEST["username"];

$databaseName = "pantry";
$databaseHost = "localhost";
$databasePassword = "";
$databaseUsername = "root";

mysql_connect($databaseHost, $databaseUsername, $databasePassword)
	or die ("DatabaseError");
mysql_select_db($databaseName) 
	or die ("DatabaseError");

$getListSQL = "SELECT * FROM foodWatch WHERE watcher='" . $username . "'";
$result = mysql_query($getListSQL);
if($result) {
	while($row = mysql_fetch_array($result)) {
		echo "---ITEM---<br>";
		echo "}:id:}" . $row["productId"] . "{:id:{";
		echo "}:image:}" . $row["imageURL"] . "{:image:{";
		echo "}:name:}" . $row["productName"] . "{:name:{";
		echo "}:amazon:}" . $row["amazonPrice"] . "{:amazon:{";
		echo "}:walmart:}" . $row["walmartPrice"] . "{:walmart:{";
		echo "}:image:}" . $row["imageURL"] . "{:image:{";
	}
}

?>