<?php
define('SQL_INC',1);
define('CURR_MENU','configs');
define('CURR_SUBMENU','configs_block_ip');
require 'inc/common.inc.php';

check_permissions(CURR_SUBMENU,1);

if (($_POST['modify'] || $id) and !$delselected) {
	check_permissions(CURR_SUBMENU,2);
	
	if (!$_POST['confirm'] && $id) {
		$db->sql_query("select id, inet_ntoa(net) as \"net\", mask, inet_ntoa(ip) as \"ip\", inet_ntoa(ip_first) as \"ip_first\", inet_ntoa(ip_last) as \"ip_last\", uid, gid, port, proto from blocked_ip where id='$id'");
		$result = $db->sql_fetchrow();
	}

	$id = $_POST['confirm'] ? addslashes($_POST['id']) : $result['id'];
	$net = $_POST['confirm'] ? addslashes($_POST['net']) : $result['net'];
	$mask = $_POST['confirm'] ? addslashes($_POST['mask']) : $result['mask'];
	$ip = $_POST['confirm'] ? addslashes($_POST['ip']) : $result['ip'];
	$ip_first = $_POST['confirm'] ? addslashes($_POST['ip_first']) : $result['ip_first'];
	$ip_last= $_POST['confirm'] ? addslashes($_POST['ip_last']) : $result['ip_last'];
	$uid = $_POST['confirm'] ? addslashes($_POST['uid']) : $result['uid'];
	$gid = $_POST['confirm'] ? addslashes($_POST['gid']) : $result['gid'];
	$port = $_POST['confirm'] ? addslashes($_POST['port']) : $result['port'];
	$proto = $_POST['confirm'] ? addslashes($_POST['proto']) : $result['proto'];

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
                $tpl->assign('ip_first',$ip_first);
                $tpl->assign('ip_last',$ip_last);
                $tpl->assign('uid',$uid);
                $tpl->assign('gid',$gid);
                $tpl->assign('port',$port);
                $tpl->assign('proto',$proto);
                $tpl->assign('action',$action);

		$tpl->display('configs_block_ip_modify.tpl');
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
		$db->sql_query("delete from blocked_ip where id='$id'");
#		$db->sql_query("update blocked_ip set changed='1'");
		header("location: configs_block_ip.php");
	}
}

$query_res = $db->sql_query("select id, inet_ntoa(net) as \"net\", mask, inet_ntoa(ip) as \"ip\", inet_ntoa(ip_first) as \"ip_first\", inet_ntoa(ip_last) as \"ip_last\", uid, gid, port, proto, action from blocked_ip");
while ($blocked_ip[] = $db->sql_fetchrow());
unset($blocked_ip[count($blocked_ip)-1]);

$tpl->assign('blocked_ip', $blocked_ip);
$tpl->display('configs_block_ip.tpl');
?>
