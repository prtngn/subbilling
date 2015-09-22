<?php
define('SQL_INC',1);
define('CURR_MENU','money');
require 'inc/common.inc.php';

check_permissions(CURR_MENU,1);

$groups = get_users_groups();

$db->sql_query("select id, deposit from users_accounts where id='$_POST[account_id]'");
while (list($id, $depos, $name, $surname, $lastname) = $db->sql_fetchrow()) {
	$ids[] = $id;
	$deposit[] = $depos;
}

if ($_POST["okey"]) {
	check_permissions(CURR_MENU,2);
	$account_id = $_POST["account_id"];
	$cash = $_POST["cash"];

	if (!preg_match('/\\A[-+]?\\b[0-9]+(\\.[0-9]+)?\\b\\z/', $cash)) {
		$errors[] = $lang["errors_money_incorrect"];
	}
	
	if (count($errors)) {
		$tpl->assign('errors',$errors);
		$tpl->assign('account_id',$account_id);
		$tpl->assign('cash',$cash);
	} else {
		$deposit = (float)$deposit[0] + (float)$cash;
		$adm = $_SESSION['login'];
		$db->sql_query("update users_accounts set deposit='$deposit' where id='$ids[0]'");
		$db->sql_query("insert into payments (id_user, pay_value, pay_time, action, who) values('$ids[0]', '$cash', '". time() ."', '3', '$login')");
		header("location: money.php?touser=$ids[0]&tocash=$cash");
		exit;
	}
}

$db->sql_query('select id, lastname, name from users_accounts');
while (list($account_id, $lastname, $name) = $db->sql_fetchrow()) {
	$users['ids'][] = $account_id;
	$users['names'][] = $lastname." ".$name;
}

if ($touser and $tocash) {
	$db->sql_query("select name, lastname, surname from users_accounts where id='$touser'");
	while (list($lastname, $name, $surname) = $db->sql_fetchrow()) {
		$stats_name = $lastname." ".$name." ".$surname;
	}
	$tpl->assign('stats_id', $touser);
	$tpl->assign('stats_name', $stats_name);
	$tpl->assign('stats_cash', $tocash);
}
$tpl->assign('users', $users);
$tpl->display('money.tpl');
?>
