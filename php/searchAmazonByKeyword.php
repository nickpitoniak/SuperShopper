<?php
include 'amazon_api_class.php';
include('phpFunctions.php');
$keyword = $_REQUEST["keyword"];

set_time_limit(0);
$obj = new AmazonProductAPI();
$obj->setKeys('AKIAI2YRYY7JLPBJBCMQ', 'OkoWSGCbiFouCJnhhXdDeI8AZ/9Ydie085HBEICc', 'pitoniak50-20');

$result = $obj->getItemByKeyword($keyword, "Grocery");

?>