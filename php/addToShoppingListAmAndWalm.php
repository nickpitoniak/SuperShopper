<?php

include('phpFunctions.php');
include('amazon_api_class.php');

$databaseName = "pantry";
$databaseHost = "localhost";
$databasePassword = "";
$databaseUsername = "root";

mysql_connect($databaseHost, $databaseUsername, $databasePassword)
	or die ("DatabaseError");
mysql_select_db($databaseName) 
	or die ("DatabaseError");

$UPC = $_REQUEST["UPC"];
$username = $_REQUEST["username"];
$request = "http://api.walmartlabs.com/v1/search?format=xml&apiKey=v5mgc7kn3cyju9bj94as4gxy&query=" . $UPC;
$ch = curl_init();

curl_setopt($ch, CURLOPT_URL,$request);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_TIMEOUT, 15);
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);

$result = curl_exec($ch);

$itemCount = getXMLObject("numItems", $result);
if($itemCount == 0) {
	exit("DNE");
}

$itemName = getXMLObject("name", $result);
$itemPrice = getXMLObject("salePrice", $result);
//$itemPrice = str_replace(".", "", $itemPrice);
$itemURL = getXMLObject("thumbnailImage", $result);

if($itemName != "" && $itemPrice != "" && $itemURL != "") {
	set_time_limit(0);
	$obj = new AmazonProductAPI();
	$obj->setKeys('XXXXX', 'XXXX', 'XXXXX');

	$result = $obj->getItemByUpc($UPC, "Grocery");
	$price = html_entity_decode($result->Items->Item->ItemAttributes->ListPrice->Amount);
	$insertToShoppingListSQL = "INSERT INTO foodWatch (productId, watcher, productName, amazonPrice, walmartPrice, imageURL) VALUES ('" . $UPC . "', '" . $username . "', '" . $itemName . "', '" . $price . "', '" . $itemPrice . "', '" . $itemURL . "')";
	$result = mysql_query($insertToShoppingListSQL);
	if($result) {
		echo "success";
	} else {
		echo "error";
	}
}

?>
