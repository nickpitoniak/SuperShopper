<?php
include('phpFunctions.php');

$keyword = $_REQUEST["keyword"];
$request = "http://api.walmartlabs.com/v1/search?apiKey=v5mgc7kn3cyju9bj94as4gxy&query=" . $keyword . "&sort=price&order=asc&format=xml";
echo $request;
echo $request;

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL,$request);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_TIMEOUT, 15);
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);

$result = curl_exec($ch);

if(strpos($result, "<errors>") !== false || strpos($result, "<error>") !== false) {
	exit("Error");
}

$itemCount = getXMLObject("numItems", $result);
if(!$itemCount || $itemCount == "0") {
	exit("ItemVoid");
}
echo "}:numRows:}" . $itemCount;
$items = explode("<item>", $result);
unset($items[0]);
foreach($items as $item) {
	$itemName = getXMLObject("name", $item);
	$itemPrice = getXMLObject("salePrice", $item);
	$itemURL = getXMLObject("thumbnailImage", $item);
	$UPC = getXMLObject("upc", $item);
	echo "---ITEM---<br>";
	echo "}:name:}" . $itemName . "{:name:{";
	echo "<br>}:price:}" . $itemPrice . "{:price:{";
	echo "<br>}:image:}" . $itemURL . "{:image:{";
	echo "<br>}:UPCCode:}" . $UPC . "{:UPCCode:{";
}

?>