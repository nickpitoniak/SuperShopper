<?php
include 'amazon_api_class.php';
include('phpFunctions.php');
$UPC = $_REQUEST["UPC"];

set_time_limit(0);
$obj = new AmazonProductAPI();
$obj->setKeys('XXX', 'XXX', 'XXX');

$result = $obj->getItemByUpc($UPC, "Grocery");
$price = html_entity_decode($result->Items->Item->ItemAttributes->ListPrice->Amount);
echo $price;

?>
