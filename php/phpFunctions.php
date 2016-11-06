<?php

function getXMLObject($tag, $xml) {
	if(strpos($xml, "<" . $tag . ">") === false || strpos($xml, "</" . $tag . ">") === false) {
		echo false;
	}
	$tagSplit1 = explode("<" . $tag . ">", $xml);
	$tagSplit2 = explode("</" . $tag . ">", $tagSplit1[1]);
	$data = $tagSplit2[0];
	if($data == "") {
		echo false;
	}
	return $data;
}

?>