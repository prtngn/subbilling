<?php
define('SQL_INC',1);
define('CURR_MENU','cards');
define('CURR_SUBMENU','cards_gen');
require 'inc/common.inc.php';

check_permissions(CURR_SUBMENU,1);

$pins = array();
$secrets = array();

$db->sql_query("select pin, secret from cards");
while (list($pin, $secret) = $db->sql_fetchrow()) {
	$pins[] = $pin;
	$secrets[] = $secret;
}

function get_pin() {
	global $pins;
	
	unset($pin);
	for ($i=0;$i<16;$i++)$pin .= mt_rand(0,9);
	
	if (in_array($pin, $pins)) {
		return get_pin();
	} else {
		$pins[] = $pin;
		return $pin;
	}
}

function get_secret() {
	global $secrets;
	
	// Если указать слишком большое кол-во карт возможно зацикливание
	$chars = str_split('0123456789');

	unset($secret);
	for ($i=0;$i<16;$i++) $secret .= $chars[mt_rand(0,count($chars)-1)];
	
	if (in_array($secret, $secrets)) {
		return get_secret();
	} else {
		$secrets[] = $secret;
		return $secret;
	}
}

if ($_POST["generate"]) {

	$price = $_POST["price"];
	$count = $_POST["count"];

	if (!preg_match('/\\A[-+]?\\b[0-9]+(\\.[0-9]+)?\\b\\z/', $price)) {
		$errors[] = $lang["errors_price_incorrect"];
	}

	if (!preg_match('/\\A[0-9]{1,11}\\z/', $count)) {
		$errors[] = $lang["errors_count_incorrect"];
	}
	
	if (count($errors)) {
		$tpl->assign('errors',$errors);
		$tpl->assign('price',$price);
		$tpl->assign('count',$count);
	} else {
		for ($i=0;$i<$count;$i++) {
			$pin = get_pin();
			$secret = get_secret();
			$db->sql_query("insert into cards (pin, secret, price, generated) values('$pin', '$secret', '$price', '". time() ."')");
		}
		header("location: cards.php");
		exit;
	}
}
$tpl->display('cards_gen.tpl');
?>