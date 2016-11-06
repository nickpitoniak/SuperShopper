<?php
include 'amazon_api_class.php';
include('phpFunctions.php');
$keyword = $_REQUEST["keyword"];

set_time_limit(0);
$obj = new AmazonProductAPI();
$obj->setKeys('XXXXX', 'XXXXX', 'XXXX');

$result = $obj->getItemByKeyword($keyword, "Grocery");

?>
