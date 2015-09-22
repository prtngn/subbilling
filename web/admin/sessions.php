<?php
define('SQL_INC',1);
define('CURR_MENU','sessions');
require 'inc/common.inc.php';

check_permissions(CURR_MENU,1);

if ($_POST['kill_sessions'] || $_GET['kill_sessions']) {
	check_permissions(CURR_MENU,2);
	
	$interfaces=isset($_POST['interfaces']) ? $_POST['interfaces'] : $_GET['interfaces'];
	if (count($interfaces)) {
		foreach ($interfaces as $iface) {
			if (preg_match('/^ppp[\\d]{1,4}$/',$iface)) {
				system("/usr/bin/sudo /bin/kill `cat /var/run/$iface.pid`");
				//$db->sql_query("delete from sessions where iface='$iface'");
			}
		}
		header('location: sessions.php');
	}
}

$sessions = array();
$sess_res = $db->sql_query("select sessions.id as \"id_session\", sessions.id_user, sessions.iface, inet_ntoa(sessions.addr) as \"addr\", sessions.connected, users.login, users_accounts.deposit, users_accounts.id_group, users.id_account, users_groups.group_name
				from sessions,users,users_accounts,users_groups
				where sessions.id_user = users.id and users_groups.id = users_accounts.id_group and users.id_account = users_accounts.id
				order by sessions.connected");
$i=0;
while ($sessions[$i] = $db->sql_fetchrow($sess_res)) {
	$stats_res = $db->sql_query("select sum(incoming), sum(outgoing) from data where id_user='". $sessions[$i]['id_user'] ."' and (log_time between '". $sessions[$i]['connected'] ."' and '". time() ."')");
	list($sessions[$i]['traff_in'], $sessions[$i]['traff_out']) = $db->sql_fetchrow($stats_res);
	$i++;
}
unset($sessions[count($sessions)-1]);

$tpl->assign('sessions',$sessions);
$tpl->display('sessions.tpl');	
?>
