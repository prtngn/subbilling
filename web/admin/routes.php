<?php
define('SQL_INC',1);
define('CURR_MENU','tariffs');
define('CURR_SUBMENU','tariffs_routes');
require 'inc/common.inc.php';
check_permissions(CURR_SUBMENU,1);

$id_tariff = intval($_POST['id_tariff']) ? intval($_POST['id_tariff']) : intval($_GET['id_tariff']);

$groups = get_routes_groups(false, $id_tariff);

$tpl->assign('groups',$groups);
$tpl->assign('id_tariff',$id_tariff);

$id_route = intval($_POST['id_route']) ? intval($_POST['id_route']) : intval($_GET['id_route']);

if ($_POST['modify'] || $id_route) {
	check_permissions(CURR_SUBMENU,2);
	
	if (!$_POST['confirm'] && $id_route) {
		$db->sql_query("select id_group, inet_ntoa(net) as \"net\", mask, inet_ntoa(ip_first) as \"ip_first\", inet_ntoa(ip_last) as \"ip_last\", dest_type from routes where id='$id_route'");
		$result = $db->sql_fetchrow();
		$route = $result['dest_type'] ? $result['ip_first'].'-'.$result['ip_last'] : $route = $result['net'].'/'.$result['mask'];
	}
	
	$route = $_POST['route'] ? $_POST['route'] : $route;
	$id_group = $_POST['id_group'] ? intval($_POST['id_group']) : $result['id_group'];
	
	if (!$route) {
		$errors[] = $lang['errors_route_empty'];
	} elseif (preg_match('/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)-((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/', $route)) {
		list($ip_first,$ip_last) = split('-',$route);
		$net='0.0.0.0'; $mask=0;
		$dest_type = 1;
		$sprintf_1 = sprintf("%u", ip2long($ip_first));
		$sprintf_2 = sprintf("%u", ip2long($ip_last));
		if($db->sql_numrows($db->sql_query("select * from routes where ip_first='$sprintf_1' and ip_last='$sprintf_2' and id_group='$id_group' and not(id='$id_route')"))) {
			$errors[] = $lang['errors_route_exists'];
		}
	} elseif (preg_match('/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\/(3[0-2]|[012]?[0-9])$/', $route)) {
		list($net,$mask) = split('\/',$route);
		$ip_first='0.0.0.0'; $ip_last='0.0.0.0';
		$dest_type = 0;
		$sprintf_3 = sprintf("%u", ip2long($net));
		if($db->sql_numrows($db->sql_query("select * from routes where net='$sprintf_3' and mask='$mask' and id_group='$id_group' and not(id='$id_route')"))) {
			$errors[] = $lang['errors_route_exists'];
		}
	} else {
		$errors[] = $lang['errors_route_incorrect'];	
	}
	
	if (!$id_group) {
		$errors[] = $lang['errors_group_id_empty'];
	} elseif (!$db->sql_numrows($db->sql_query("select * from routes_groups where id='$id_group'"))) {
		$errors[] = $lang['errors_group_id_incorrect'];
	}
	
	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		
		$tpl->assign('id_group',$id_group);
		$tpl->assign('id_route',$id_route);
		$tpl->assign('route',$route);
		$tpl->display('routes_modify.tpl');
		exit;
		
	} elseif($_POST['confirm']) {
		if ($id_route) {
			$sprintf_4 = sprintf("%u", ip2long($net));
			$sprintf_5 = sprintf("%u", ip2long($ip_first));
			$sprintf_6 = sprintf("%u", ip2long($ip_last));
			$db->sql_query("update routes set id_group='$id_group', net='$sprintf_4', mask='$mask', ip_first='$sprintf_5', ip_last='$sprintf_6', dest_type='$dest_type' where id='$id_route'"); 
		} else {
			$sprintf_7 = sprintf("%u", ip2long($net));
			$sprintf_8 = sprintf("%u", ip2long($ip_first));
			$sprintf_9 = sprintf("%u", ip2long($ip_last));
			$db->sql_query("insert into routes (id_group, net, mask, ip_first, ip_last, dest_type) values('$id_group', '$sprintf_7', '$mask', '$sprintf_8', '$sprintf_9', '$dest_type')"); 	
		}
		header("location: routes.php?id_tariff=$id_tariff&id_group=$id_group");
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
			$db->sql_query("delete from routes where id='$value'");
		}
		header("location: routes.php?id_tariff=$id_tariff&id_group=$id_group");
		exit;
	}
}

$id_group = intval($_POST['id_group']) ? intval($_POST['id_group']) : intval($_GET['id_group']);
$tpl->assign('id_group',$id_group);

if (!$id_group) {
	header('location: routes_groups.php');
	exit;
}

$routes = array();
$db->sql_query("select routes.id as \"id_route\", routes.id_group, inet_ntoa(routes.net) as \"net\", routes.mask, inet_ntoa(routes.ip_first) as \"ip_first\", inet_ntoa(routes.ip_last) as \"ip_last\", routes.dest_type, routes_groups.group_name
							 from routes, routes_groups
							 where routes.id_group=routes_groups.id and id_group='$id_group'
							 order by routes_groups.id_tariff, routes.id");
while ($routes[] = $db->sql_fetchrow());
unset($routes[count($routes)-1]); 
$tpl->assign('routes',$routes);
$tpl->display('routes.tpl');
?>