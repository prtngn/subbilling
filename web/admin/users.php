<?php
define('SQL_INC',1);
define('CURR_MENU','users_accounts');
define('CURR_SUBMENU','users');
require 'inc/common.inc.php';

check_permissions(CURR_SUBMENU,1);

$accounts = get_users_accounts();
$tariffs = get_tariffs();
$route = get_route();

$id_user = intval($_POST['id_user']) ? intval($_POST['id_user']) : intval($_GET['id_user']);
if ($_POST['search']) {
	$search_text = preg_match('/^[a-zA-Z0-9а-яА-Я_\\*\\?]+$/u', $_POST['search_text']) ? $_POST['search_text'] : '';
	$search_text=str_replace(array("*","?"),array("%","_"), $search_text);
}
if ($_POST['modify'] || $_GET['id_user']) {
	check_permissions(CURR_MENU,2);

	if (!$_POST['confirm'] && $id_user) {
		$db->sql_query("select login, pass, id_account, id_tariff, inet_ntoa(addr) as \"addr\", p_in, p_out, inet_ntoa(eth_ip) as \"eth_ip\", eth_mac, nat, route as \"id_route\" from users where users.id='$id_user'");
		$result = $db->sql_fetchrow();
	}

	$user_login = $_POST['confirm'] ? $_POST['user_login'] : $result['login'];
	$id_account = $_POST['id_account'] ? intval($_POST['id_account']) : $result['id_account'];
	$id_tariff = $_POST['id_tariff'] ? intval($_POST['id_tariff']) : $result['id_tariff'];
	$p_in = $_POST['confirm'] ? intval($_POST['p_in'])*1024*1024 : $result['p_in'];
	$p_out = $_POST['confirm'] ? $_POST['p_out']*1024*1024 : $result['p_out'];
	$password1 = $_POST['confirm'] ? $_POST['password1'] : $result['pass'];
	$password2 = $_POST['confirm'] ? $_POST['password2'] : $result['pass'];
	$addr = $_POST['confirm'] ? $_POST['addr'] : $result['addr'];
	$eth_ip = $_POST['confirm'] ? addslashes($_POST['eth_ip']) : $result['eth_ip'];
	$eth_mac = $_POST['confirm'] ? addslashes($_POST['eth_mac']) : $result['eth_mac'];
	$eth_mac_0 = $_POST['confirm'] ? addslashes($_POST['eth_mac_0']) : $result['eth_mac_0'];
	$eth_mac_1 = $_POST['confirm'] ? addslashes($_POST['eth_mac_1']) : $result['eth_mac_1'];
	$eth_mac_2 = $_POST['confirm'] ? addslashes($_POST['eth_mac_2']) : $result['eth_mac_2'];
	$eth_mac_3 = $_POST['confirm'] ? addslashes($_POST['eth_mac_3']) : $result['eth_mac_3'];
	$eth_mac_4 = $_POST['confirm'] ? addslashes($_POST['eth_mac_4']) : $result['eth_mac_4'];
	$eth_mac_5 = $_POST['confirm'] ? addslashes($_POST['eth_mac_5']) : $result['eth_mac_5'];
	$nat = $_POST['confirm'] ? addslashes($_POST['nat']) : $result['nat'];
	$id_route = $_POST['confirm'] ? addslashes($_POST['id_route']) : $result['id_route'];

	$eth_mac = $eth_mac_0.":".$eth_mac_1.":".$eth_mac_2.":".$eth_mac_3.":".$eth_mac_4.":".$eth_mac_5;

	if ($_POST['id_user'] or $_GET['id_user']) {
                $addrs = get_ips_from_net($id_user);
		$netaddrs = get_ips2_from_net($id_user);
        } else {
		$addrs = get_ips_from_net("new");
		$netaddrs = get_ips2_from_net("new");
	}

	$errors = array();
	if (!$user_login) {
		$errors[] = $lang['errors_login_empty'];
	} elseif (!preg_match('/^\\w{3,64}$/', $user_login)) {
		$errors[] = $lang['errors_login_incorrect'];
	} elseif($db->sql_numrows($db->sql_query("select * from users where login='$user_login' and not(id='$id_user')"))) {
		$errors[] = $lang['errors_login_exists'];
	}

	if (!$password1 || !$password2) {
		$errors[] = $lang['errors_passwords_empty'];
	} elseif (!preg_match('/^\\w{3,64}$/', $password1) || !preg_match('/^\\w{3,64}$/', $password2)) {
		$errors[] = $lang['errors_passwords_incorrect'];
	} elseif ($password1 != $password2) {
		$errors[] = $lang['errors_passwords_mismatch'];
	}

	if (!$id_account) {
		$errors[] = $lang['errors_account_empty'];
	}
	
	if (!$id_tariff) {
		$errors[] = $lang['errors_tariff_id_empty'];
	} elseif (!$db->sql_numrows($db->sql_query("select * from tariffs where id='$id_tariff'"))) {
		$errors[] = $lang['errors_tariff_id_incorrect'];
	}
	
	if (!$addr) {
		$errors[] = $lang['errors_addr_empty'];
	}

        if (!$eth_ip) {
                $errors[] = $lang['errors_ethip_empty'];
        }

	if (!$eth_mac) {
                $errors[] = $lang['errors_mac_empty'];
	} elseif (!preg_match('/[\d|A-F]{2}\:[\d|A-F]{2}\:[\d|A-F]{2}\:[\d|A-F]{2}\:[\d|A-F]{2}\:[\d|A-F]{2}/i', $eth_mac)) {
		$errors[] = $lang['errors_mac_incorrect'];
	}

	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}

		$tpl->assign('id_user',$id_user);
		$tpl->assign('id_account',$id_account);
		$tpl->assign('id_tariff',$id_tariff);
		$tpl->assign('user_login',$user_login);
		$tpl->assign('password1',$password1);
		$tpl->assign('password2',$password2);
		$tpl->assign('p_in',$p_in/1024/1024);
		$tpl->assign('p_out',$p_out/1024/1024);
		$tpl->assign('addr',$addr);
		$tpl->assign('addrs',$addrs);
		$tpl->assign('accounts',$accounts);
		$tpl->assign('netaddrs',$netaddrs);
		$tpl->assign('tariffs',$tariffs);
		$tpl->assign('eth_ip',$eth_ip);
		$tpl->assign('eth_mac_0',$eth_mac_0);
		$tpl->assign('eth_mac_1',$eth_mac_1);
		$tpl->assign('eth_mac_2',$eth_mac_2);
		$tpl->assign('eth_mac_3',$eth_mac_3);
		$tpl->assign('eth_mac_4',$eth_mac_4);
		$tpl->assign('eth_mac_5',$eth_mac_5);
		$tpl->assign('nat',$nat);
                $tpl->assign('route',$route);
		$tpl->assign('id_route',$id_route);
		$tpl->display('users_modify.tpl');
		exit;
		
	} elseif($_POST['confirm']) {
		if ($id_user) {
			$sprintf_addr = sprintf("%u", ip2long($addr));
			$sprintf_ethip = sprintf("%u", ip2long($eth_ip));
			$db->sql_query("update users set login='$user_login', pass='$password1', id_account='$id_account', id_tariff='$id_tariff', addr='$sprintf_addr', p_in='$p_in', p_out='$p_out', eth_ip='$sprintf_ethip', eth_mac='$eth_mac', nat='$nat', route='$id_route' where id='$id_user'");
		} else {
			$sprintf_addr = sprintf("%u", ip2long($addr));
			$sprintf_ethip = sprintf("%u", ip2long($eth_ip));
			$db->sql_query("insert into users (login, pass, id_account, id_tariff, id_next, addr, p_in, p_out, registered, last_period, eth_ip, eth_mac, nat, route) values('$user_login', '$password1', '$id_account', '$id_tariff', '$id_tariff', '$sprintf_addr', '$p_in', '$p_out', '". time() ."','". time() ."', '$sprintf_ethip', '$eth_mac', '$nat', '$id_route')");
		}
		header("location: users.php?id_group=$id_group");
		exit;
	}
}

if ($_POST['delselected'] || $_GET['delselected']) {
	check_permissions(CURR_MENU,2);
	
	$id=isset($_POST['id']) ? $_POST['id'] : $_GET['id'];
	$id_group=intval($_POST['id_group']);
	if (count($id)) {
		foreach ($id as $value) {
			$value=intval($value);
			list($iface) = $db->sql_fetchrow($db->sql_query("select iface from sessions where id_user='$value'"));
			if ($iface) {
				system("/usr/bin/sudo /bin/kill `cat /var/run/$iface.pid`");
			}
			$db->sql_query("delete from data where id_user='$value'");
			$db->sql_query("delete from payments where id_user='$value'");
			$db->sql_query("delete from history where id_user='$value'");
			$db->sql_query("delete from users where id='$value'");
			$db->sql_query("delete from traff where uid='$value'");
		}
		header("location: users.php?id_group=$id_group");
		exit;
	}
}

$id_account = isset($_POST['id_account']) ? intval($_POST['id_account']) : intval($_GET['id_account']);
$id_tariff = isset($_POST['id_tariff']) ? intval($_POST['id_tariff']) : intval($_GET['id_tariff']);

$accounts['ids'][] = 0;
$accounts['names'][] = $lang['all'];

$tariffs['ids'][] = 0;
$tariffs['names'][] = $lang['all'];

$tpl->assign('accounts',$accounts);
$tpl->assign('tariffs',$tariffs);
$tpl->assign('route',$route);
$tpl->assign('id_account',$id_account);
$tpl->assign('id_tariff',$id_tariff);
if ($search_text) {
	$sql_where = "and users.login like '%$search_text%'";
} else {
	$sql_where = $id_account ? "and id_account='$id_account'" : '';
	$sql_where .= $id_tariff ? " and id_tariff='$id_tariff'" : '';
}
$query_res = $db->sql_query("select users.id as \"id_user\", users.login, users.id_account, users.id_tariff, inet_ntoa(users.addr) as \"addr\", tariffs.tariff_name, inet_ntoa(users.eth_ip) as \"eth_ip\", users.eth_mac, users.nat, users_accounts.name, users_accounts.lastname, users.route
							 from users, tariffs, users_accounts
							 where (users.id_tariff=tariffs.id and users.id_account=users_accounts.id $sql_where) order by users.id_account, users.id");
$users = array();
while ($users[] = $db->sql_fetchrow());
unset($users[count($users)-1]);
$eth_macc = explode(":", $eth_mac);

$tpl->assign('users',$users);
$tpl->assign('eth_mac_0',$eth_macc[0]);
$tpl->assign('eth_mac_1',$eth_macc[1]);
$tpl->assign('eth_mac_2',$eth_macc[2]);
$tpl->assign('eth_mac_3',$eth_macc[3]);
$tpl->assign('eth_mac_4',$eth_macc[4]);
$tpl->assign('eth_mac_5',$eth_macc[5]);

$tpl->display('users.tpl');	
?>
