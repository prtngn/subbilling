<?php
define('SQL_INC',1);
define('CURR_MENU','settings');
define('CURR_SUBMENU','tariff');

require 'inc/common.inc.php';

$db->sql_query("select users_groups.change_tariff, users.id_tariff, (users.last_period+tariffs.period) from users_groups, users, tariffs, users_accounts where users.id_account=users_accounts.id and users_accounts.id_group=users_groups.id and users.id_tariff=tariffs.id and users.id='$id_user'");
list($change_tariff, $id_current, $next_period) = $db->sql_fetchrow();

$id_tariff = intval($_POST['id_tariff']) ? intval($_POST['id_tariff']) : (intval($_GET['id_tariff']) ? intval($_GET['id_tariff']) : $id_current);

if ($_POST['set_now'] && $change_tariff) {
	$db->sql_query("select * from tariffs where id='$id_tariff' and (pub>0 or id='$id_current')");
	if ($db->sql_numrows()) {
		$db->sql_query("update users set id_next='$id_tariff', id_tariff='$id_tariff' where id='$id_user'");
	}
}

if ($_POST['set_next'] && $change_tariff) {
	$db->sql_query("select * from tariffs where id='$id_tariff' and (pub>0 or id='$id_current')");
	if ($db->sql_numrows()) {
		$db->sql_query("update users set id_next='$id_tariff' where id='$id_user'");
	}
}

$db->sql_query("select users.id_next, tariffs.tariff_name  from users, tariffs where users.id_next=tariffs.id and users.id='$id_user'");
list($id_next, $next_tariff) = $db->sql_fetchrow();


$db->sql_query("select id, tariff_name from tariffs where pub>0 or id='$id_current'");
while (list($id_trf,$tariff_name) = $db->sql_fetchrow()) {
	$tariffs['ids'][] = $id_trf;
	$tariffs['names'][] = $tariff_name;
}

$db->sql_query("select * from tariffs where id='$id_tariff' and (pub>0 or id='$id_current')");
$tariff = $db->sql_fetchrow();

$groups = array(); $i=0;
$groups_res = $db->sql_query("select id, group_name from routes_groups where id_tariff='$id_tariff' order by prio");
while (list($id_group, $group_name) = $db->sql_fetchrow($groups_res)) {
	$groups[$i]['group_name'] = $group_name;
	$groups[$i]['timers'] = array();
	$timers_res = $db->sql_query("select * from timers where id_group='$id_group'");
	while ($groups[$i]['timers'][] = $db->sql_fetchrow($timers_res));
	unset($groups[$i]['timers'][count($groups[$i]['timers'])-1]);
	$i++;
}

$holidays = array();
$db->sql_query("select day, discount_in, discount_out, description from holidays where id_tariff='$id_tariff'");
while ($holidays[] = $db->sql_fetchrow());
unset($holidays[count($holidays)-1]);

$tpl->assign('id_tariff', $id_tariff);
$tpl->assign('id_current', $id_current);
$tpl->assign('id_next', $id_next);
$tpl->assign('next_tariff', $next_tariff);
$tpl->assign('change_tariff', $change_tariff);
$tpl->assign('next_period', $next_period);
$tpl->assign('tariff', $tariff);
$tpl->assign('groups', $groups);
$tpl->assign('holidays', $holidays);
$tpl->assign('tariffs', $tariffs);
$tpl->display('tariff.tpl');
?>