<?php

include('phpFunctions.php');

$UPC = $_REQUEST["UPC"];
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
$itemURL = getXMLObject("thumbnailImage", $result);
echo "---ITEM---<br>";
echo "}:name:}" . $itemName . "{:name:{";
echo "<br>}:price:}" . $itemPrice . "{:price:{";
echo "<br>}:image:}" . $itemURL . "{:image:{";
echo "<br>}:UPCCode:}" . $UPC . "{:image:{";

?>