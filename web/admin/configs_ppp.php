<?php
define('SQL_INC',1);
define('CURR_MENU','configs');
define('CURR_SUBMENU','configs_ppp');
require 'inc/common.inc.php';

check_permissions(CURR_SUBMENU,1);

if ($_POST['modify'] || $id) {
	check_permissions(CURR_SUBMENU,2);
	
	if (!$_POST['confirm'] && $id) {
		$db->sql_query("select id, name, nat, mppe, inet_ntoa(dns_one) as \"dns_one\", inet_ntoa(dns_two) as \"dns_two\", radius, detailed, used from configs_ppp where id='$id'");
		$result = $db->sql_fetchrow();
	}

	$id = $_POST['confirm'] ? addslashes($_POST['id']) : $result['id'];
	$name = $_POST['confirm'] ? addslashes($_POST['name']) : $result['name'];
	$nat = $_POST['confirm'] ? addslashes($_POST['nat']) : $result['nat'];
	$mppe = $_POST['confirm'] ? addslashes($_POST['mppe']) : $result['mppe'];
	$dns_one = $_POST['confirm'] ? addslashes($_POST['dns_one']) : $result['dns_one'];
	$dns_two = $_POST['confirm'] ? addslashes($_POST['dns_two']) : $result['dns_two'];
	$radius = $_POST['confirm'] ? addslashes($_POST['radius']) : $result['radius'];
	$detailed = $_POST['confirm'] ? addslashes($_POST['detailed']) : $result['detailed'];
	$used = $_POST['confirm'] ? addslashes($_POST['used']) : $result['used'];

	$errors = array();
	if (!$name) {
		$errors[] = $lang['errors_conf_name_empty'];
	} elseif($db->sql_numrows($db->sql_query("select * from configs_ppp where name='$name'")) && !$id) {
		$errors[] = $lang['errors_conf_name_exists'];
	}

	$sprintf_1 = sprintf("%u", ip2long($dns_one));
	if (!$dns_one) {
		$errors[] = $lang['errors_conf_dns_one_empty'];
	} elseif (!preg_match('/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/', $dns_one)) {
		$errors[] = $lang['errors_conf_dns_one_incorrect'];
	}

        if ($dns_two) {
        	if (!preg_match('/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/', $dns_two)) {
                	$errors[] = $lang['errors_conf_dns_two_incorrect'];
		}
        }

	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		
		if (!$id) {
			$tpl->assign('id',$id);
		} else {
			$tpl->assign('id',$id);
		}
		$tpl->assign('name',$name);
		$tpl->assign('nat',$nat);
		$tpl->assign('mppe',$mppe);
		$tpl->assign('dns_one',$dns_one);
		$tpl->assign('dns_two',$dns_two);
		$tpl->assign('radius',$radius);
		$tpl->assign('detailed',$detailed);
		$tpl->assign('used',$used);
		$tpl->display('configs_ppp_modify.tpl');
		exit;
		
	} elseif($_POST['confirm']) {
		if ($id) {
			$sprintf_1 = sprintf("%u", ip2long($ppp_server));
			$sprintf_2 = sprintf("%u", ip2long($dns_one));
			$sprintf_3 = sprintf("%u", ip2long($dns_two));
			if ($used == 1) {
#				$db->sql_query("update configs_ppp set used='0' where used='1'");
				$db->sql_query("update configs_ppp set name='$name', nat='$nat', mppe='$mppe', dns_one='$sprintf_2', dns_two='$sprintf_3', radius='$radius', detailed='$detailed', used='1', changed='1' where id='$id'");
			} else {
				$db->sql_query("update configs_ppp set name='$name', nat='$nat', mppe='$mppe', dns_one='$sprintf_2', dns_two='$sprintf_3', radius='$radius', detailed='$detailed' used='0', changed='1' where id='$id'");
			}
		} else {
			$sprintf_1 = sprintf("%u", ip2long($ppp_server));
			$sprintf_2 = sprintf("%u", ip2long($dns_one));
			if ($dns_two) {
				$sprintf_3 = sprintf("%u", ip2long($dns_two));
			} else {
				$sprintf_3 = "0.0.0.0";
			}
			if ($used == 1) {
#				$db->sql_query("update conf set used='0' where used='1'");
				$db->sql_query("insert into configs_ppp (name, nat, mppe, dns_one, dns_two, radius, detailed, used, changed) values('$name', '$nat', '$mppe', '$sprintf_2', '$sprintf_3', '$radius', '$detailed', '1', '1')");
			} else {
				$db->sql_query("insert into configs_ppp (name, nat, mppe, dns_one, dns_two, radius, detailed, used, changed) values('$name', '$nat', '$mppe', '$sprintf_2', '$sprintf_3', '$radius', '$detailed', '0', '1')");
			}
		}
		header("location: configs_ppp.php");
		exit;
	}
}

if ($_POST['delselected'] || $_GET['delselected']) {
	check_permissions(CURR_SUBMENU,2);

	$id=isset($_POST['id']) ? $_POST['id'] : $_GET['id'];
	if (count($id)) {
		#$db->sql_query("delete from configs_ppp where id='$id'");
		#$db->sql_query("update configs_ppp set changed='1'");
		header("location: configs_ppp.php");
	}
}


if (!$db->sql_numrows($db->sql_query("select mppe, inet_ntoa(dns_one) as \"dns_one\", inet_ntoa(dns_two) as \"dns_two\", radius from configs_ppp where used='1'"))){
	 $error = 1;
}

$query_res = $db->sql_query("select id, name, nat, mppe, inet_ntoa(dns_one) as \"dns_one\", inet_ntoa(dns_two) as \"dns_two\", radius, detailed, used from configs_ppp");
$conf = array();
while ($conf[] = $db->sql_fetchrow());
unset($conf[count($conf)-1]);

$tpl->assign('conf', $conf);
$tpl->assign('error', $error);
$tpl->display('configs_ppp.tpl');
?>
