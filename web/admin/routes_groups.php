<?php

define('SQL_INC',1);
define('CURR_MENU','tariffs');
define('CURR_SUBMENU','tariffs_routes');
require 'inc/common.inc.php';
check_permissions(CURR_SUBMENU,1);

$id_tariff = isset($_POST['id_tariff']) ? intval($_POST['id_tariff']) : intval($_GET['id_tariff']);
$id_group = isset($_POST['id_group']) ? intval($_POST['id_group']) : intval($_GET['id_group']);

$tariffs = get_tariffs();

if ($_POST['modify'] || $id_group) {
	check_permissions(CURR_SUBMENU,2);
	
	if (!$_POST['confirm'] && $id_group) {
		$db->sql_query("select group_name, id_tariff, prio from routes_groups where id='$id_group'");
		$result = $db->sql_fetchrow();
	}
	
	$group_name = $_POST['confirm'] ? addslashes($_POST['group_name']) : $result['group_name'];
	$id_tariff = isset($_POST['id_tariff']) ? intval($_POST['id_tariff']) : $result['id_tariff'];

	$prio = $_POST['confirm'] ? $_POST['prio'] : $result['prio'];
	
	if ($_POST['autoprio']) {
		list($prio) = $db->sql_fetchrow($db->sql_query("select max(prio)+1 from routes_groups where id_tariff='$id_tariff'"));
		$prio = $prio ? $prio : 1;
	}
	
	if (!$group_name) {
		$errors[] = $lang['errors_group_name_empty'];
	} elseif($db->sql_numrows($db->sql_query("select * from routes_groups where group_name='$group_name' and id_tariff='$id_tariff' and not(id='$id_group')"))) {
		$errors[] = $lang['errors_group_name_exists'];
	}
	
	if (!$id_tariff) {
		$errors[] = $lang['errors_tariff_id_empty'];
	} elseif (!$db->sql_numrows($db->sql_query("select * from tariffs where id='$id_tariff'"))) {
		$errors[] = $lang['errors_tariff_id_incorrect'];
	}
	
	if (!preg_match('/^\\d{1,11}$/', $prio)) {
		$errors[] = $lang['errors_prio_incorrect'];
	}	
	

	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		
		$tpl->assign('id_group',$id_group);
		$tpl->assign('id_tariff',$id_tariff);
		$tpl->assign('tariffs',$tariffs);
		$tpl->assign('group_name',stripslashes($group_name));
		$tpl->assign('prio',$prio);
		$tpl->display('routes_groups_modify.tpl');
		exit;
		
	} elseif($_POST['confirm']) {
		if ($id_group) {
			$db->sql_query("update routes_groups set group_name='$group_name', id_tariff='$id_tariff', prio='$prio' where id='$id_group'"); 
		} else {
			$db->sql_query("insert into routes_groups (group_name, id_tariff, prio) values('$group_name', '$id_tariff', '$prio')"); 	
		}
		header("location: routes_groups.php?id_tariff=$id_tariff");
		exit;
	}
}

if ($_POST['delselected'] || $_GET['delselected']) {
	check_permissions(CURR_SUBMENU,2);
	
	$id=isset($_POST['id']) ? $_POST['id'] : $_GET['id'];
	if (count($id)) {
		foreach ($id as $value) {
			$value=intval($value);
			$db->sql_query("delete from routes where id_group='$value'");
			$db->sql_query("delete from routes_groups where id='$value'");
		}
		header("location: routes_groups.php?id_tariff=$id_tariff");
	}
}

$tariffs['ids'][] = 0;
$tariffs['names'][] = $lang['all'];


$sql_where = $id_tariff ? "and id_tariff='$id_tariff'" : '';

$tpl->assign('id_tariff',$id_tariff);
$tpl->assign('tariffs',$tariffs);

$groups = array();
$db->sql_query("select routes_groups.id as \"id_group\", routes_groups.group_name, routes_groups.id_tariff, routes_groups.prio, tariffs.tariff_name
				from routes_groups, tariffs
				where routes_groups.id_tariff=tariffs.id $sql_where
				order by routes_groups.id_tariff, routes_groups.prio");
while ($groups[] = $db->sql_fetchrow());
unset($groups[count($groups)-1]);

$tpl->assign('groups',$groups);
$tpl->display('routes_groups.tpl');
?>