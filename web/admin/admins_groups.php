<?php
define('SQL_INC',1);
define('CURR_MENU','admins');
define('CURR_SUBMENU','admins_groups');
require 'inc/common.inc.php';

check_permissions(CURR_SUBMENU,1);

$id_group = intval($_POST['id_group']) ? intval($_POST['id_group']) : intval($_GET['id_group']);

if ($_POST['modify'] || $id_group) {
	check_permissions(CURR_SUBMENU,2);
	
	if (!$_POST['confirm'] && $id_group) {
		$db->sql_query("select group_name, description, def_page, sessions, users_accounts, users, users_groups, machines, machines_groups, tariffs, tariffs_routes, tariffs_holidays, stats, stats_detailed, cards, cards_gen, money, news, tickets, admins, admins_groups, payments, connections, configs, configs_ppp, configs_route, configs_ip, configs_dhcpd, configs_block_ip, configs_block_mac from admins_groups where id='$id_group'");
		$result = $db->sql_fetchrow();
	}
	
	$group_name = $_POST['confirm'] ? addslashes($_POST['group_name']) : $result['group_name'];
	$description = $_POST['confirm'] ? addslashes($_POST['description']) : $result['description'];
	$def_page = $_POST['confirm'] ? $_POST['def_page'] : $result['def_page'];
	
	$perm['sessions'] = $_POST['confirm'] ? intval($_POST['perm_sessions']) : $result['sessions'];
		$perm['connections'] = $_POST['confirm'] ? intval($_POST['perm_connections']) : $result['connections'];
	$perm['users_accounts'] = $_POST['confirm'] ? intval($_POST['perm_users_accounts']) : $result['users_accounts'];
		$perm['users'] = $_POST['confirm'] ? intval($_POST['perm_users']) : $result['users'];
		$perm['users_groups'] = $_POST['confirm'] ? intval($_POST['perm_users_groups']) : $result['users_groups'];
	$perm['machines'] = $_POST['confirm'] ? intval($_POST['perm_machines']) : $result['machines'];
		$perm['machines_groups'] = $_POST['confirm'] ? intval($_POST['perm_machines_groups']) : $result['machines_groups'];
	$perm['payments'] = $_POST['confirm'] ? intval($_POST['perm_payments']) : $result['payments'];
	$perm['tariffs'] = $_POST['confirm'] ? intval($_POST['perm_tariffs']) : $result['tariffs'];
		$perm['tariffs_routes'] = $_POST['confirm'] ? intval($_POST['perm_tariffs_routes']) : $result['tariffs_routes'];
		$perm['tariffs_holidays'] = $_POST['confirm'] ? intval($_POST['perm_tariffs_holidays']) : $result['tariffs_holidays'];
	$perm['stats'] = $_POST['confirm'] ? intval($_POST['perm_stats']) : $result['stats'];
		$perm['stats_detailed'] = $_POST['confirm'] ? intval($_POST['perm_stats_detailed']) : $result['stats_detailed'];
	$perm['cards'] = $_POST['confirm'] ? intval($_POST['perm_cards']) : $result['cards'];
		$perm['cards_gen'] = $_POST['confirm'] ? intval($_POST['perm_cards_gen']) : $result['cards_gen'];
	$perm['money'] = $_POST['confirm'] ? intval($_POST['perm_money']) : $result['money'];
	$perm['news'] = $_POST['confirm'] ? intval($_POST['perm_news']) : $result['news'];
	$perm['tickets'] = $_POST['confirm'] ? intval($_POST['perm_tickets']) : $result['tickets'];
	$perm['configs'] = $_POST['confirm'] ? intval($_POST['perm_configs']) : $result['configs'];
		$perm['configs_ppp'] = $_POST['confirm'] ? intval($_POST['perm_configs_ppp']) : $result['configs_ppp'];
		$perm['configs_route'] = $_POST['confirm'] ? intval($_POST['perm_configs_route']) : $result['configs_route'];
		$perm['configs_ip'] = $_POST['confirm'] ? intval($_POST['perm_configs_ip']) : $result['configs_ip'];
		$perm['configs_dhcpd'] = $_POST['confirm'] ? intval($_POST['perm_configs_dhcpd']) : $result['configs_dhcpd'];
		$perm['configs_block_ip'] = $_POST['confirm'] ? intval($_POST['perm_configs_block_ip']) : $result['configs_block_ip'];
		$perm['configs_block_mac'] = $_POST['confirm'] ? intval($_POST['perm_configs_block_mac']) : $result['configs_block_mac'];
	$perm['admins'] = $_POST['confirm'] ? intval($_POST['perm_admins']) : $result['admins'];
		$perm['admins_groups'] = $_POST['confirm'] ? intval($_POST['perm_admins_groups']) : $result['admins_groups'];
		
	if (!$group_name) {
		$errors[] = $lang['errors_group_name_empty'];
	} elseif($db->sql_numrows($db->sql_query("select * from users_groups where group_name='$group_name' and not(id='$id_group')"))) {
		$errors[] = $lang['errors_group_name_exists'];
	}
	
	if (!$def_page) {
		$errors[] = $lang['errors_defpage_empty'];
	} elseif (!preg_match('/^\\w{3,64}$/', $def_page)) {
		$errors[] = $lang['errors_defpage_incorrect'];
	}
	
	
	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		
		$tpl->assign('id_group',$id_group);
		$tpl->assign('group_name',stripslashes($group_name));
		$tpl->assign('description',stripslashes($description));
		$tpl->assign('def_page',$def_page);
		$tpl->assign('perm',$perm);
		
		$tpl->display('admins_groups_modify.tpl');
		exit;
	} elseif($_POST['confirm']) {
		if ($id_group) {
			$sql_query="update admins_groups set group_name='$group_name', description='$description', def_page='$def_page'";
			foreach ($perm as $key => $value) {
				$sql_query.=", $key='$value'";
			}
			$sql_query.=" where id='$id_group'";
			$db->sql_query($sql_query); 
		} else {
			$sql_names='group_name, description, def_page';
			$sql_values="'$group_name', '$description', '$def_page'";
			foreach ($perm as $key => $value) {
				$sql_names.=", $key";
				$sql_values.=",'$value'";
			}
			$db->sql_query("insert into admins_groups ($sql_names) values($sql_values)"); 	
		}
		header('location: admins_groups.php');	
	}
} 

if ($_POST['delselected'] || $_GET['delselected']) {
	check_permissions(CURR_SUBMENU,2);
	
	$id=isset($_POST['id']) ? $_POST['id'] : $_GET['id'];
	if (count($id)) {
		foreach ($id as $value) {
			$value=intval($value);
			$db->sql_query("delete from admins where id_group='$value'");
			$db->sql_query("delete from admins_groups where id='$value'");
		}
		header('location: admins_groups.php');
		exit;
	}	
}

$groups = array();
$db->sql_query("select id as \"id_group\", group_name, description, def_page from admins_groups");
while ($groups[] = $db->sql_fetchrow());
unset($groups[count($groups)-1]);

$tpl->assign('groups',$groups);
$tpl->display('admins_groups.tpl');
?>
