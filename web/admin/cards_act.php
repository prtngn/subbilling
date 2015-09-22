<?php
define('SQL_INC',1);
define('CURR_MENU','cards');
require 'inc/common.inc.php';

check_permissions(CURR_MENU,2);

$id_card = isset($_POST['id_card']) ? intval($_POST['id_card']) : intval($_GET['id_card']);

if ($_POST['activate']) {
	$id_user = intval($_POST['id_user']);
	$card_res = $db->sql_query("select price from cards where id='$id_card'");
	$user_res = $db->sql_query("select * from users where id='$id_user'");
	if (!$db->sql_numrows($card_res)) {
		$errors[] = $lang['errors_card_incorrect'];
	} elseif (!$db->sql_numrows($user_res)) {
		$errors[] = $lang['errors_user_incorrect'];
	} else {
		list($price) = $db->sql_fetchrow($card_res);
		$db->sql_query("delete from cards where id='$id_card'");
		$db->sql_query("update users set deposit=deposit+$price where id='$id_user'");
		$db->sql_query("insert into payments (id_user, pay_value, pay_time, action, who) values('$id_user', '$price', '". time() ."', '1', '$login')");
	}
	
	if (count($errors)) {
		$tpl->assign('errors', $errors);
	} else {
		header('location: cards.php');
		exit;
	}
} elseif (!$id_card) {
	header('location: cards.php');
	exit;
}


$db->sql_query('select id, login from users');
while (list($id_user, $user_login) = $db->sql_fetchrow()) {
	$users['ids'][] = $id_user;
	$users['names'][] = $user_login;
}

$tpl->assign('users', $users);
$tpl->assign('id_card', $id_card);
$tpl->display('cards_act.tpl');
?>