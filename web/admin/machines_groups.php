<?php
define('SQL_INC',1);
define('CURR_MENU','machines');
define('CURR_SUBMENU','machines_groups');
require 'inc/common.inc.php';
check_permissions(CURR_SUBMENU,1);

$id_group = intval($_POST['id_group']) ? intval($_POST['id_group']) : intval($_GET['id_group']);
if ($_POST['modify'] || $id_group) {
	check_permissions(CURR_SUBMENU,2);
	
	if (!$_POST['confirm'] && $id_group) {
		$db->sql_query("select group_name, description from machines_groups where id='$id_group'");
		$result = $db->sql_fetchrow();
	}
	
	$group_name = $_POST['confirm'] ? addslashes($_POST['group_name']) : $result['group_name'];
	$description = $_POST['confirm'] ? addslashes($_POST['description']) : $result['description'];
	
	if (!$group_name) {
		$errors[] = $lang['errors_group_name_empty'];
	} elseif($db->sql_numrows($db->sql_query("select * from machines_groups where group_name='$group_name' and not(id='$id_group')"))) {
		$errors[] = $lang['errors_group_name_exists'];
	}
	
	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		$tpl->assign('id_group',$id_group);
		$tpl->assign('group_name',stripslashes($group_name));
		$tpl->assign('description',stripslashes($description));
		$tpl->display('machines_groups_modify.tpl');
		exit;
	} elseif($_POST['confirm']) {
		if ($id_group) {
			$db->sql_query("update machines_groups set group_name='$group_name', description='$description' where id='$id_group'"); 
		} else {
			$db->sql_query("insert into machines_groups (group_name,description) values('$group_name', '$description')"); 	
		}
		header('location: machines_groups.php');
	}
} 

if ($_POST['delselected'] || $_GET['delselected']) {
	check_permissions(CURR_SUBMENU,2);
	
	$id=isset($_POST['id']) ? $_POST['id'] : $_GET['id'];
	if (count($id)) {
		foreach ($id as $value) {
			$value=intval($value);
			$db->sql_query("delete from machines where id_group='$value'");
			$db->sql_query("delete from machines_groups where id='$value'");
		}
		header('location: machines_groups.php');
		exit;
	}	
}

$groups = array();
$query_res = $db->sql_query("select id as \"id_group\", group_name, description from machines_groups");
while ($groups[] = $db->sql_fetchrow());
unset($groups[count($groups)-1]);

$tpl->assign('groups',$groups);
$tpl->display('machines_groups.tpl');
?>
