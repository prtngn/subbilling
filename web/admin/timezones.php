<?php
define('SQL_INC',1);
define('CURR_MENU','tariffs');
define('CURR_SUBMENU','tariffs_routes');
require 'inc/common.inc.php';
check_permissions(CURR_SUBMENU,1);

$id_tariff = intval($_POST['id_tariff']) ? intval($_POST['id_tariff']) : intval($_GET['id_tariff']);
$id_group = intval($_POST['id_group']) ? intval($_POST['id_group']) : intval($_GET['id_group']);
$id_timer = intval($_POST['id_timer']) ? intval($_POST['id_timer']) : intval($_GET['id_timer']);

$groups = get_routes_groups(false, $id_tariff);

$tpl->assign('groups',$groups);
$tpl->assign('id_group',$id_group);
$tpl->assign('id_tariff',$id_tariff);

if ($_POST['modify'] || $id_timer) {
	check_permissions(CURR_SUBMENU,2);
	
	if (!$_POST['confirm'] && $id_timer) {
		$db->sql_query("select id_group, time_from, time_to, cost_in, cost_out, prepaid, speed from timers where id='$id_timer'");
		$result = $db->sql_fetchrow();
		$range = $result['time_from'] .'-'. $result['time_to'];
	}
	
	$id_group = isset($_POST['id_group']) ? intval($_POST['id_group']) : $result['id_group'];
	$range = isset($_POST['range']) ? $_POST['range'] : $range;
	$cost_in = $_POST['confirm'] ? $_POST['cost_in'] : $result['cost_in'];
	$cost_out = $_POST['confirm'] ? $_POST['cost_out'] : $result['cost_out'];
	$prepaid = $_POST['confirm'] ? intval($_POST['prepaid']) : $result['prepaid'];
	$speed = $_POST['confirm'] ? $_POST['speed'] : $result['speed'];	

	if (!$range) {
		$errors[] = $lang['errors_range_empty'];
	} elseif (preg_match('/^([01]?[0-9]|2[0-3])-([01]?[0-9]|2[0-3])$/', $range)) {
		list($time_from,$time_to) = split('-',$range);
		if($db->sql_numrows($db->sql_query("select * from timers where time_from='$time_from' and time_to='$time_to' and id_group='$id_group' and not(id='$id_timer')"))) {
			$errors[] = $lang['errors_range_exists'];
		} elseif($time_from > $time_to) {
			$errors[] = $lang['errors_range_incorrect'];
		}
	} else {
		$errors[] = $lang['errors_range_incorrect'];	
	}
	
	if (!$id_group) {
		$errors[] = $lang['errors_group_id_empty'];
	} elseif (!$db->sql_numrows($db->sql_query("select * from routes_groups where id='$id_group'"))) {
		$errors[] = $lang['errors_group_id_incorrect'];
	}
	
	if (!preg_match('/^\\d+(\\.\\d+)?$/', $cost_in)) {
		$errors[] = $lang['errors_cost_in_incorrect'];
	}
	
	if (!preg_match('/^\\d+(\\.\\d+)?$/', $cost_out)) {
		$errors[] = $lang['errors_cost_out_incorrect'];
	}

	if (!preg_match('/^(\\d{1,9}|\\d{1,9}-\\d{1,9})$/', $speed) && $speed) {
		$errors[] = $lang['errors_speed_incorrect'];
	}
	if (!$speed) $speed=0;
	
	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		
		
		$tpl->assign('id_timer',$id_timer);
		$tpl->assign('id_group',$id_group);
		$tpl->assign('range',$range);
		$tpl->assign('cost_in',$cost_in);
		$tpl->assign('cost_out',$cost_out);
		$tpl->assign('prepaid',$prepaid);
		$tpl->assign('speed',$speed);
		$tpl->display('timezones_modify.tpl');
		exit;
		
	} elseif($_POST['confirm']) {
		if ($id_timer) {
			$db->sql_query("update timers set id_group='$id_group', time_from='$time_from', time_to='$time_to', cost_in='$cost_in', cost_out='$cost_out', prepaid='$prepaid', speed='$speed' where id='$id_timer'"); 
		} else {
			$db->sql_query("insert into timers (id_group, time_from, time_to, cost_in, cost_out, prepaid, speed) values('$id_group', '$time_from', '$time_to', '$cost_in', '$cost_out', '$prepaid', '$speed')"); 	
		}
		header("location: timezones.php?id_tariff=$id_tariff&id_group=$id_group");
		exit;
	}
}

if ($_POST['delselected'] || $_GET['delselected']) {
	check_permissions(CURR_SUBMENU,2);
	
	$id=isset($_POST['id']) ? $_POST['id'] : $_GET['id'];
	$id_group=intval($_POST['id_group']);
	if (count($id)) {
		foreach ($id as $value) {
			$value=intval($value);
			$db->sql_query("delete from timers where id='$value'");
		}
		header("location: timezones.php?id_tariff=$id_tariff&id_group=$id_group");
		exit;
	}
}

if (!$id_group) {
	header('location: routes_groups.php');
	exit;
}

$timezones = array();
$db->sql_query("select timers.id as \"id_timer\", timers.id_group, timers.time_from, timers.time_to, timers.cost_in, timers.cost_out, timers.prepaid, timers.speed, routes_groups.group_name
							from timers, routes_groups
							where timers.id_group=routes_groups.id and id_group='$id_group'
							order by timers.time_from");
while ($timezones[] = $db->sql_fetchrow());
unset($timezones[count($timezones)-1]);

$tpl->assign('timezones',$timezones);
$tpl->display('timezones.tpl');
?>