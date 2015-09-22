<?php
	session_start();
	
	define("SQL_INC",1);
	require_once 'config.inc.php';
	require_once 'sql.inc.php';

	if ($_POST["signup"]) {
		$login=substr($_POST["login"],0,64);
		$pass=md5(substr($_POST["passwd"],0,64));
	} else {
		$login=substr($_SESSION["admin_login"],0,64);
		$pass=substr($_SESSION["admin_passwd"],0,32);
	}
	
	unset($allow);
	
	$db->sql_query('select id, id_group, login, passwd from admins');
	while (list($my_id, $my_group, $admin_login, $admin_pass)=$db->sql_fetchrow()) {
		if ($allow=((strtolower($login)==strtolower($admin_login)) && ($pass==$admin_pass))) {
			$db->sql_query("select * from admins_groups where id='$my_group'");
			$perms = $db->sql_fetchrow();
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
		$_SESSION['admin_login']=$login;
		$_SESSION['admin_passwd']=$pass;
		$db->sql_query("update admins set last_login='". time() ."' where id='$my_id'");
		header('location: ../index.php');
		exit;
	}
?>