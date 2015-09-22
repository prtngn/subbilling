<?php
define('SQL_INC',1);
define('CURR_MENU','paycard');

require 'inc/common.inc.php';

if ($_POST['activate']) {
	$pin = $_POST['pin'];
	$secret = $_POST['secret'];
	
	if (!preg_match('/^\d+$/',$pin) || !preg_match('/^[a-zA-Z0-9]+$/',$secret)) {
		$errors[] = $lang['errors_card_incorrect'];
	} else {
		$db->sql_query("select id, price from cards where pin='$pin' and secret='$secret'");
		if ($db->sql_numrows()) {
			list($id_card, $price) = $db->sql_fetchrow();
			$db->sql_query("delete from cards where id='$id_card'");
			$db->sql_query("update users set deposit=deposit+$price where id='$id_user'");
			$db->sql_query("insert into payments (id_user, pay_value, pay_time, action) values('$id_user', '$price', '". time() ."', '0')");
			$notices[] = $lang['notice_card_activated'];
		} else {
			$errors[] = $lang['errors_card_incorrect'];
		}
	}
	
	if (count($errors)) {
		sleep(3); // в дальнейшем заменить картинкой с кодом
		$tpl->assign('errors', $errors);
	} else {
		$tpl->assign('notices', $notices);
	}
}

$tpl->display('paycard.tpl');
?>