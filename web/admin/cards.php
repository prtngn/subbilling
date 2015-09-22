<?php
define('SQL_INC',1);
define('CURR_MENU','cards');
require 'inc/common.inc.php';

check_permissions(CURR_MENU,1);

$id=isset($_POST['id']) ? $_POST['id'] : $_GET['id'];

if ($_POST['delselected'] || $_GET['delselected']) {
	check_permissions(CURR_MENU,2);
	if (count($id)) {
		foreach ($id as $value) {
			$value=intval($value);
			$db->sql_query("delete from cards where id='$value'");
		}
		header('location: cards.php');
		exit;
	}	
}

$prices['ids'][] = 0;
$prices['names'][] = $lang['all'];

$db->sql_query('select distinct price from cards');
while (list($price) = $db->sql_fetchrow()) {
	$prices['ids'][] = $price;
	$prices['names'][] = $price;
}

$cards = array();
if ($_POST['print'] || $_GET['print']) {
	if (count($id)) {
		foreach ($id as $value) {
			$value=intval($value);
			$db->sql_query("select * from cards where id='$value'");
			$cards[] = $db->sql_fetchrow();
		}
	} else {
		header('location: cards.php');
		exit;
	}
	$tpl->assign('cards', $cards);
	$tpl->display('cards_print.tpl');
} else {
	$db->sql_query('select * from cards order by generated desc');
	while ($cards[] = $db->sql_fetchrow());
	unset($cards[count($cards)-1]);
	$tpl->assign('cards', $cards);
	$tpl->assign('prices', $prices);
	$tpl->display('cards.tpl');
}
?>