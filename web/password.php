<?php
define('SQL_INC',1);
define('CURR_MENU','settings');
define('CURR_SUBMENU','password');

require 'inc/common.inc.php';

if ($_POST['change_pass']) {
	$old_pass = $_POST['old_pass'];
	$new_pass = $_POST['new_pass'];
	$pass_confirm = $_POST['pass_confirm'];
	
	$errors = array();
	if (!preg_match('/^[a-zA-Z0-9]{3,64}$/', $old_pass)) {
		$errors[] = $lang['errors_old_pass_incorrect'];
	} elseif (!$db->sql_numrows($db->sql_query("select * from users where id='$id_user' and pass='$old_pass'"))) {
		$errors[] = $lang['errors_old_pass_incorrect'];
	} elseif ($old_pass == $new_pass) {
		$errors[] = $lang['errors_old_new_passwords_match'];
	}
	
	if (!preg_match('/^[a-zA-Z0-9]{3,64}$/', $new_pass)) {
		$errors[] = $lang['errors_new_pass_incorrect'];
	} 
	
	if (!preg_match('/^[a-zA-Z0-9]{3,64}$/', $pass_confirm)) {
		$errors[] = $lang['errors_pass_confirm_incorrect'];
	} elseif ($new_pass != $pass_confirm) {
		$errors[] = $lang['errors_passwords_mismatch'];
	}

	if (count($errors)) {
		$tpl->assign('errors',$errors);
	} else {
		$db->sql_query("update users set pass='$new_pass' where id='$id_user'");
		$notices = array();
		$notices[] = $lang['notice_password_changed'];
		$tpl->assign('notices',$notices);
	}
}

$tpl->display('password.tpl');	
?>