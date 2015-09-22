<?php
define('SQL_INC',1);
define('CURR_MENU','configs');
define('CURR_SUBMENU','configs_dhcpd');
require 'inc/common.inc.php';

check_permissions(CURR_SUBMENU,1);

if ($_POST['modify'] || $id) {
	check_permissions(CURR_SUBMENU,2);
	
	if (!$_POST['confirm'] && $id) {
		$db->sql_query("select configs_dhcpd.id, configs_dhcpd.name, configs_dhcpd.interface, configs_dhcpd.network, configs_dhcpd.gateway, configs_dhcpd.dns1, configs_dhcpd.dns2, configs_dhcpd.nbios1, configs_dhcpd.nbios2, configs_dhcpd.time, configs_dhcpd.ntp, configs_dhcpd.domain from configs_dhcpd where configs_dhcpd.id='$id'");
		$result = $db->sql_fetchrow();
	}

	$networks = get_networks();
	$id = $_POST['confirm'] ? addslashes($_POST['id']) : $result['id'];
	$name = $_POST['confirm'] ? addslashes($_POST['name']) : $result['name'];
	$interface = $_POST['confirm'] ? addslashes($_POST['interface']) : $result['interface'];
	$network = $_POST['confirm'] ? addslashes($_POST['network']) : $result['network'];
	$gateway = $_POST['confirm'] ? addslashes($_POST['gateway']) : $result['gateway'];
	$dns1 = $_POST['confirm'] ? addslashes($_POST['dns1']) : $result['dns1'];
	$dns2 = $_POST['confirm'] ? addslashes($_POST['dns2']) : $result['dns2'];
	$nbios1 = $_POST['confirm'] ? addslashes($_POST['nbios1']) : $result['nbios1'];
	$nbios2 = $_POST['confirm'] ? addslashes($_POST['nbios2']) : $result['nbios2'];
	$time = $_POST['confirm'] ? addslashes($_POST['time']) : $result['time'];
	$ntp = $_POST['confirm'] ? addslashes($_POST['ntp']) : $result['ntp'];
	$domain = $_POST['confirm'] ? addslashes($_POST['domain']) : $result['domain'];

	if (!$name) {
		$errors[] = $lang['errors_route_name_empty'];
	} elseif(($db->sql_numrows($db->sql_query("select * from configs_dhcpd where name='$name'"))) && !$_POST['id']) {
		$errors[] = $lang['errors_route_name_exists'];
	}

	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		
		$tpl->assign('id',$id);
		$tpl->assign('name',$name);
		$tpl->assign('interface',$interface);
		$tpl->assign('network',$network);
		$tpl->assign('gateway',$gateway);
		$tpl->assign('dns1',$dns1);
		$tpl->assign('dns2',$dns2);
		$tpl->assign('nbios1',$nbios1);
		$tpl->assign('nbios2',$nbios2);
		$tpl->assign('time',$time);
		$tpl->assign('ntp',$ntp);
		$tpl->assign('domain',$domain);
		$tpl->assign('networks',$networks);
		$tpl->display('configs_dhcpd_modify.tpl');
		exit;
		
	} elseif($_POST['confirm']) {
		if ($id) {
			$db->sql_query("update configs_dhcpd set name='$name', interface='$interface', network='$network', gateway='$gateway', dns1='$dns1', dns2='$dns2', nbios1='$nbios1', nbios2='$nbios2', time='$time', ntp='$ntp', domain='$domain', changed='1' where id='$id'");
		} else {
			$db->sql_query("insert into configs_dhcpd (name, interface, network, gateway, dns1, dns2, nbios1, nbios2, time, ntp, domain, changed) values('$name', '$interface', '$network', '$gateway', '$dns1', '$dns2', '$nbios1', '$nbios2', '$time', '$ntp', '$domain', '1')");
		}
		header("location: configs_dhcpd.php");
		exit;
	}
}

if ($_POST['delselected'] || $_GET['delselected']) {
	check_permissions(CURR_SUBMENU,2);

	$id=isset($_POST['id']) ? $_POST['id'] : $_GET['id'];
	if (count($id)) {
		$db->sql_query("delete from configs_dhcpd where id='$id'");
		$db->sql_query("update configs_dhcpd set changed='1'");
		header("location: configs_dhcpd.php");
	}
}

$query_res = $db->sql_query("select configs_dhcpd.id, configs_dhcpd.name, configs_dhcpd.interface, configs_dhcpd.gateway, configs_dhcpd.dns1, configs_dhcpd.dns2, configs_dhcpd.nbios1, configs_dhcpd.nbios2, configs_dhcpd.time, configs_dhcpd.ntp, configs_dhcpd.domain, inet_ntoa(configs_ip.net) as \"net\", configs_ip.mask from configs_dhcpd, configs_ip where configs_dhcpd.network = configs_ip.id order by id");
$dhcpd = array();
while ($dhcpd[] = $db->sql_fetchrow());
unset($dhcpd[count($dhcpd)-1]);

$tpl->assign('dhcpd', $dhcpd);
$tpl->display('configs_dhcpd.tpl');
?>