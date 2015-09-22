<?php
function smarty_modifier_fbytes($string) {
	$units = array("", "k", "M", "G", "T");
	if ($string) {
		$index = min(((int)log($string, 1024)), count($units)-1);
		$result = round($string/pow(1024, $index), 2);
	} else {
		$result = 0;
	}
	return $result.' '.$units[$index].'b';
}
?>