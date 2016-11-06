<?php
include 'amazon_api_class.php';

set_time_limit(0);
$obj = new AmazonProductAPI();
$obj->setKeys('AKIAI2YRYY7JLPBJBCMQ', 'OkoWSGCbiFouCJnhhXdDeI8AZ/9Ydie085HBEICc', 'pitoniak50-20');
try {

  $result = $obj->getItemByUpc("015000047689", "Grocery");
  
} catch (Exception $e) {
  echo $e;
}
?>