<?php
define('SQL_INC',1);
define('CURR_MENU','users_accounts');
define('CURR_SUBMENU','users_groups');
require 'inc/common.inc.php';
check_permissions(CURR_SUBMENU,1);

$id_group = intval($_POST['id_group']) ? intval($_POST['id_group']) : intval($_GET['id_group']);
if ($_POST['modify'] || $id_group) {
	check_permissions(CURR_SUBMENU,2);
	
	if (!$_POST['confirm'] && $id_group) {
		$db->sql_query("select group_name, description, discount, change_tariff, blocked from users_groups where id='$id_group'");
		$result = $db->sql_fetchrow();
	}
	
	$group_name = $_POST['confirm'] ? addslashes($_POST['group_name']) : $result['group_name'];
	$description = $_POST['confirm'] ? addslashes($_POST['description']) : $result['description'];
	$discount = $_POST['confirm'] ? intval($_POST['discount']) : intval($result['discount']);
	$change_tariff = $_POST['confirm'] ? intval($_POST['change_tariff']) : $result['change_tariff'];
	$blocked = $_POST['confirm'] ? intval($_POST['blocked']) : $result['blocked'];
	
	if (!$group_name) {
		$errors[] = $lang['errors_group_name_empty'];
	} elseif($db->sql_numrows($db->sql_query("select * from users_groups where group_name='$group_name' and not(id='$id_group')"))) {
		$errors[] = $lang['errors_group_name_exists'];
	}
	
	if (!preg_match('/\\A[0-9]{0,3}\\z/',$discount) || $discount>100) {
		$errors[] = $lang['errors_discount_incorrect'];
	}

	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		$tpl->assign('id_group',$id_group);
		$tpl->assign('group_name',stripslashes($group_name));
		$tpl->assign('description',stripslashes($description));
		$tpl->assign('discount',$discount);
		$tpl->assign('change_tariff',$change_tariff);
		$tpl->assign('blocked',$blocked);
		$tpl->display('users_groups_modify.tpl');
		exit;
	} elseif($_POST['confirm']) {
		if ($id_group) {
			$db->sql_query("update users_groups set group_name='$group_name', description='$description', discount='$discount', change_tariff='$change_tariff', blocked='$blocked' where id='$id_group'"); 
		} else {
			$db->sql_query("insert into users_groups (group_name,description,discount,change_tariff,blocked) values('$group_name', '$description', '$discount', '$change_tariff', '$blocked')"); 	
		}
		header('location: users_groups.php');	
	}
} 

if ($_POST['delselected'] || $_GET['delselected']) {
	check_permissions(CURR_SUBMENU,2);
	
	$id=isset($_POST['id']) ? $_POST['id'] : $_GET['id'];
	if (count($id)) {
		foreach ($id as $value) {
			$value=intval($value);
			$users_res = $db->sql_query("select id from users where id_group='$value'");
			while (list($id_user)=$db->sql_fetchrow($users_res)) {
				$db->sql_query("delete from data where id_user='$id_user'");
			}
			$db->sql_query("delete from users where id_group='$value'");
			$db->sql_query("delete from users_groups where id='$value'");
		}
		header('location: users_groups.php');
		exit;
	}	
}

$groups = array();
$query_res = $db->sql_query("select id as \"id_group\", group_name, discount, change_tariff, blocked, description from users_groups");
while ($groups[] = $db->sql_fetchrow());
unset($groups[count($groups)-1]);

$tpl->assign('groups',$groups);
$tpl->display('users_groups.tpl');
?>
