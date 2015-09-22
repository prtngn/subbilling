<?php
	session_start();
	
	define("SQL_INC",1);
	require_once 'config.inc.php';
	require_once 'sql.inc.php';

	if ($_POST["signup"]) {
		$login=substr($_POST["login"],0,64);
		$pass=md5(substr($_POST["passwd"],0,64));
	} else {
		$login=substr($_SESSION["user_login"],0,64);
		$pass=substr($_SESSION["user_passwd"],0,32);
	}
	
	unset($allow);
	
	$db->sql_query('select id, login, pass from users');
	while (list($id_user, $user_login, $user_pass) = $db->sql_fetchrow()) {
		if ($allow=((strtolower($login)==strtolower($user_login)) && ($pass==md5($user_pass)))) {
			break;
		}
	}
	
	if (!$allow) {
		sleep(1);
		if ($_POST['signup']) {
			header('location: ../login.php');
		} else {
			header('location: login.php');
		}
		exit;
	} elseif ($_POST['signup']) {
		$_SESSION['user_login']=$login;
		$_SESSION['user_passwd']=$pass;
		$db->sql_query("update users set last_login='". time() ."' where id='$id_user'");
		header('location: ../index.php');
		exit;
	}
?>