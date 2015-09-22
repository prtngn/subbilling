<?php
define('SQL_INC',1);
define('CURR_MENU','configs');
define('CURR_SUBMENU','configs_ip');
require 'inc/common.inc.php';

check_permissions(CURR_SUBMENU,1);

if ($_POST['modify'] || $id_route) {
	check_permissions(CURR_SUBMENU,2);
	
	if (!$_POST['confirm'] && $id_route) {
		$db->sql_query("select id, inet_ntoa(net) as \"net\", mask, nat from configs_ip where id='$id_route'");
		$result = $db->sql_fetchrow();
	}

	$id = $_POST['confirm'] ? addslashes($_POST['id']) : $result['id'];
	$net = $_POST['confirm'] ? addslashes($_POST['net']) : $result['net'];
	$mask = $_POST['confirm'] ? addslashes($_POST['mask']) : $result['mask'];
	$nat = $_POST['confirm'] ? addslashes($_POST['nat']) : $result['nat'];

	list($nets,$masks) = split('/',$ip_zone);
	if (!$nets) {
		$errors[] = $lang['errors_ip_empty'];
	} elseif (preg_match('/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/', $nets)) {
		$sprintf_1 = sprintf("%u", ip2long($nets));
		if($db->sql_numrows($db->sql_query("select * from configs_ip where net='$sprintf_1'")) && !$_POST['id_route']) {
			$errors[] = $lang['errors_ip_exists'];
		}
	} else {
		$errors[] = $lang['errors_ip_incorrect'];
	}

	if ($nat == 0 and ($masks < 19 or $masks > 30)) {
		$errors[] = $lang['errors_ppp_masks_incorrect'];
	}

	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		
		$tpl->assign('id',$id);
		$tpl->assign('net',$net);
		$tpl->assign('mask',$mask);
		$tpl->assign('nat',$nat);
		$tpl->display('configs_ip_modify.tpl');
		exit;
		
	} elseif($_POST['confirm']) {
		list($net,$mask) = split('/',$ip_zone);
		if ($id_route) {
			$sprintf_5 = sprintf("%u", ip2long($net));
			if ($old_net) {
				list($old_net,$old_mask) = split('/',$old_net);
				$old_net = sprintf("%u", ip2long($old_net));
				$razn = $old_net - $sprintf_5;
				if ($nat == 0) {
					$ips = get_first_and_last_ip($old_net, $old_mask);
					if ($razn < 0) {
						$razn = $razn * (-1);
						$db->sql_query("update users set addr=addr+'$razn' where addr>='$ips[first]' and addr<='$ips[last]'");
					}
					if ($razn > 0) {
						$db->sql_query("update users set addr=addr-'$razn' where addr>='$ips[first]' and addr<='$ips[last]'");
					}
				}
				if ($nat == 1) {
					$ips = get_first_and_last_ip($old_net, $old_mask);
                                        if ($razn < 0) {
                                                $razn = $razn * (-1);
                                                $db->sql_query("update users set eth_ip=eth_ip+'$razn' where eth_ip>='$ips[first]' and eth_ip<='$ips[last]'");
                                        }
                                        if ($razn > 0) {
                                                $db->sql_query("update users set eth_ip=eth_ip-'$razn' where eth_ip>='$ips[first]' and eth_ip<='$ips[last]'");
                                        }
				}
			}
			$db->sql_query("update configs_ip set net='$sprintf_5', mask='$mask', nat='$nat', changed='1' where id='$id_route'");
		} else {
			$sprintf_8 = sprintf("%u", ip2long($net));
			$db->sql_query("insert into configs_ip (net, mask, nat, changed) values('$sprintf_8', '$mask', '$nat', '1')");
		}
		header("location: configs_ip.php");
		exit;
	}
}

if ($_POST['delselected'] || $_GET['delselected']) {
	check_permissions(CURR_SUBMENU,2);

	$id=isset($_POST['id']) ? $_POST['id'] : $_GET['id'];
	if (count($id)) {
		$db->sql_query("delete from configs_ip where id='$id'");
		$db->sql_query("update configs_ip set changed='1'");
		header("location: configs_ip.php");
	}
}

$query_res = $db->sql_query("select id, inet_ntoa(net) as \"net\", mask, nat from configs_ip order by id");
$route = array();
while ($ip[] = $db->sql_fetchrow());
unset($ip[count($ip)-1]);

$tpl->assign('ip', $ip);
$tpl->display('configs_ip.tpl');
?>
