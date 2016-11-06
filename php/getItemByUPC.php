<?php
include 'amazon_api_class.php';
$UPC = $_REQUEST["UPC"];

set_time_limit(0);
$obj = new AmazonProductAPI();
$obj->setKeys('XXXX', 'XXXXX', 'XXXX');
try {

  $result = $obj->getItemByUpc($UPC, "Grocery");
  $listPrice = html_entity_decode($result->Items->Item->ItemAttributes->ListPrice->Amount);
  echo $listPrice;
  if($listPrice == null) {
    echo "Error";
  }

} catch (Exception $e) {
  echo "Error";
}
?>
