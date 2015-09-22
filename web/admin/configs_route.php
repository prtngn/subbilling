<?php
define('SQL_INC',1);
define('CURR_MENU','configs');
define('CURR_SUBMENU','configs_route');
require 'inc/common.inc.php';

check_permissions(CURR_SUBMENU,1);

if ($_POST['modify'] || $id) {
	check_permissions(CURR_SUBMENU,2);
	
	if (!$_POST['confirm'] && $id) {
		$db->sql_query("select id, name, inet_ntoa(ip) as \"ip\", dev from configs_route where id='$id'");
		$result = $db->sql_fetchrow();
	}

	$id = $_POST['confirm'] ? addslashes($_POST['id']) : $result['id'];
	$name = $_POST['confirm'] ? addslashes($_POST['name']) : $result['name'];
	$ip = $_POST['confirm'] ? addslashes($_POST['ip']) : $result['ip'];
	$dev = $_POST['confirm'] ? addslashes($_POST['dev']) : $result['dev'];

	if (!$name) {
		$errors[] = $lang['errors_route_name_empty'];
	} elseif(($db->sql_numrows($db->sql_query("select * from configs_route where name='$name' and not(id='$id')")))) {
		$errors[] = $lang['errors_route_name_exists'];
		$errors[] = $_POST['id'];
	}

	if (!$dev) {
		$errors[] = $lang['errors_route_dev_empty'];
	} elseif(($db->sql_numrows($db->sql_query("select * from configs_route where dev='$dev' and not(id='$id')")))) {
		$errors[] = $lang['errors_route_dev_exists'];
	}

	$sprintf_1 = sprintf("%u", ip2long($ip));
	if (!$ip) {
		$errors[] = $lang['errors_addr_empty'];
	} elseif (!preg_match('/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/', $ip)) {
		$errors[] = $lang['errors_addr_incorrect'];
	} elseif(($db->sql_numrows($db->sql_query("select * from configs_route where ip='$sprintf_1'"))) && !$_POST['id']) {
		$errors[] = $lang['errors_addr_exists'];
	}

	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		
		$tpl->assign('id',$id);
		$tpl->assign('name',$name);
		$tpl->assign('ip',$ip);
		$tpl->assign('dev',$dev);
		$tpl->display('configs_route_modify.tpl');
		exit;
		
	} elseif($_POST['confirm']) {
		if ($id) {
			$sprintf_1 = sprintf("%u", ip2long($ip));
			$db->sql_query("update configs_route set name='$name', ip='$sprintf_1', dev='$dev', changed='1' where id='$id'");
		} else {
			$sprintf_1 = sprintf("%u", ip2long($ip));
			$db->sql_query("insert into configs_route (name, ip, dev, changed) values('$name', '$sprintf_1', '$dev', '1')");
		}
		header("location: configs_route.php");
		exit;
	}
}

if ($_POST['delselected'] || $_GET['delselected']) {
	check_permissions(CURR_SUBMENU,2);

	$id=isset($_POST['id']) ? $_POST['id'] : $_GET['id'];
	if (count($id)) {
		$db->sql_query("delete from configs_route where id='$id'");
		header("location: configs_route.php");
	}
}

$query_res = $db->sql_query("select id, name, inet_ntoa(ip) as \"ip\", dev from configs_route order by id");
$route = array();
while ($route[] = $db->sql_fetchrow());
unset($route[count($route)-1]);

$tpl->assign('route', $route);
$tpl->display('configs_route.tpl');
?>
