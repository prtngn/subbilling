<?php
define('SQL_INC',1);
define('CURR_MENU','machines');
require 'inc/common.inc.php';

check_permissions(CURR_MENU,1);

$users = get_users();
$groups = get_machines_groups();

$id_machine = intval($_POST['id_machine']) ? intval($_POST['id_machine']) : intval($_GET['id_machine']);
if ($_POST['search']) {
	$search_text = preg_match('/^[a-zA-Z0-9а-яА-Я_\\*\\?]+$/u', $_POST['search_text']) ? $_POST['search_text'] : '';
	$search_text=str_replace(array("*","?"),array("%","_"), $search_text);
}
if ($_POST['modify'] || $_GET['id_user']) {
	check_permissions(CURR_MENU,2);

	if (!$_POST['confirm'] && $id_machine) {
		$db->sql_query("select id_user, id_group, name, mac from machines where id='$id_machine'");
		$result = $db->sql_fetchrow();
	}
	
	$id_user = $_POST['confirm'] ? $_POST['id_user'] : $result['id_user'];
	$id_group = $_POST['confirm'] ? intval($_POST['id_group']) : $result['id_group'];
	$name = $_POST['confirm'] ? intval($_POST['name']) : $result['name'];
	$mac = $_POST['confirm'] ? intval($_POST['mac']) : $result['mac'];

	$errors = array();
	if (!$id_group) {
		$errors[] = $lang['errors_group_empty'];
	}
	
	if (!$name) {
		$errors[] = $lang['errors_name_empty'];
	} elseif (!preg_match('/^\\w{3,64}$/', $name)) {
		$errors[] = $lang['errors_name_incorrect'];
	}
	
	if (!$mac) {
		$errors[] = $lang['errors_mac_empty'];
	}
	
	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}

		$tpl->assign('id_user',$id_user);
		$tpl->assign('id_group',$id_group);
		$tpl->assign('name',$name);
		$tpl->assign('mac',$mac);
		$tpl->display('machines_modify.tpl');
		exit;
		
	} elseif($_POST['confirm']) {
		if ($id_machine) {
			$db->sql_query("update machines set id_user='$id_user', id_group='$id_group', name='$name', mac='$mac' where id='$id_machine'");
		} else {
			$db->sql_query("insert into machines (id_user, id_group, name, mac) values('$id_user', '$id_group', '$name', '$mac')");
		}
		header("location: machines.php?id_group=$id_group");
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
			$db->sql_query("delete from machines where id='$value'");
		}
		header("location: machines.php?id_group=$id_group");
		exit;
	}
}

$id_user = isset($_POST['id_user']) ? intval($_POST['id_user']) : intval($_GET['id_user']);
$id_group = isset($_POST['id_group']) ? intval($_POST['id_group']) : intval($_GET['id_group']);

$users['ids'][] = 0;
$users['names'][] = $lang['all'];

$groups['ids'][] = 0;
$groups['names'][] = $lang['all'];

$tpl->assign('users',$users);
$tpl->assign('groups',$groups);
$tpl->assign('id_user',$id_user);
$tpl->assign('id_group',$id_group);
if ($search_text) {
	$sql_where = "and ((users.login like '%$search_text%') or (users.user_name like '%$search_text%'))";
} else {
	$sql_where = $id_account ? "and id_account='$id_account'" : '';
	$sql_where .= $id_tariff ? " and id_tariff='$id_tariff'" : '';
}
$query_res = $db->sql_query("select machines.id, machines.id_user, machines.id_group, machines.name, machines.mac, machines_groups.group_name
							 from machines, machines_groups
							 where (machines.id = machines_groups.id $sql_where) order by machines.id");
$machines = array();
while ($machines[] = $db->sql_fetchrow());
unset($machines[count($machines)-1]);

$tpl->assign('machines',$machines);
$tpl->display('machines.tpl');	
?>
