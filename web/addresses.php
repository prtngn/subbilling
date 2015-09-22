<?php
define('SQL_INC',1);
define('CURR_MENU','settings');
define('CURR_SUBMENU','addresses');
require 'inc/common.inc.php';


$id_addr = intval($_POST['id_addr']) ? intval($_POST['id_addr']) : intval($_GET['id_addr']);

if ($_POST['set_security']) {
	$enabled = $_POST['enabled'] ? 1 : 0;
	$db->sql_query("update users set security='$enabled' where id='$id_user'");
}

if ($_POST['confirm'] || $_POST['modify'] || $_GET['id_addr']) {
	
	if (!$_POST['confirm'] && $id_addr) {
		$db->sql_query("select inet_ntoa(addr) as \"addr\" from users_addr where id='$id_addr' and id_user='$id_user'");
		$result = $db->sql_fetchrow();
	}
	
	$addr = $_POST['confirm'] ? $_POST['addr'] : $result['addr'];
	$sprintf_1 = sprintf("%u", ip2long($addr));
	if (!$addr) {
		$errors[] = $lang['errors_addr_empty'];
	} elseif (!preg_match('/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/', $addr)) {
		$errors[] = $lang['errors_addr_incorrect'];
	} elseif($db->sql_numrows($db->sql_query("select * from users_addr where addr='$sprintf_1' and id_user='$id_user' and not(id='$id_addr')"))) {
		$errors[] = $lang['errors_addr_exists'];
	}
	
	
	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		
		$tpl->assign('addr',$addr);
		$tpl->assign('id_addr',$id_addr);
		$tpl->display('addresses_modify.tpl');
		exit;
		
	} elseif($_POST['confirm']) {
		if ($id_addr) {
			$db->sql_query("update users_addr set addr='$sprintf_1' where id='$id_addr' and id_user='$id_user'"); 
		} else {
			$db->sql_query("insert into users_addr (addr, id_user) values('$sprintf_1', '$id_user')"); 	
		}
		header('location: addresses.php');
		exit;
	}
}

if ($_POST['delselected'] || $_GET['delselected']) {
	
	$id=isset($_POST['id']) ? $_POST['id'] : $_GET['id'];
	if (count($id)) {
		foreach ($id as $value) {
			$value=intval($value);
			$db->sql_query("delete from users_addr where id='$value'");
		}
		header('location: addresses.php');
		exit;
	}
}

$db->sql_query("select security from users where id='$id_user'");
list($enabled) = $db->sql_fetchrow();
$db->sql_query("select id, inet_ntoa(addr) as \"addr\" from users_addr where id_user='$id_user'");
$addresses = array();
while ($addresses[] = $db->sql_fetchrow());
unset($addresses[count($addresses)-1]);
$tpl->assign('enabled',$enabled);
$tpl->assign('addresses',$addresses);
$tpl->display('addresses.tpl');
?>