<?php
define('SQL_INC',1);
define('CURR_MENU','admins');
require 'inc/common.inc.php';
check_permissions(CURR_MENU,1);

$groups = get_admins_groups();

$id_admin = intval($_POST['id_admin']) ? intval($_POST['id_admin']) : intval($_GET['id_admin']);
if ($_POST['modify'] || $id_admin) {
	check_permissions(CURR_MENU,2);
	
	if (!$_POST['confirm'] && $id_admin) {
		$db->sql_query("select login, passwd, id_group from admins where id='$id_admin'");
		$result = $db->sql_fetchrow();
	}
	
	$login = $_POST['confirm'] ? $_POST['login'] : $result['login'];
	$id_group = $_POST['id_group'] ? intval($_POST['id_group']) : $result['id_group'];
	$password1 = $_POST['pass1'];
	$password2 = $_POST['pass2'];
	
	if (!$_POST['change_pass']) {
		if (!$login) {
			$errors[] = $lang['errors_login_empty'];
		} elseif (!preg_match('/^[\\w]{3,64}$/', $login)) {
			$errors[] = $lang['errors_login_incorrect'];
		} elseif($db->sql_numrows($db->sql_query("select * from admins where login='$login' and not(id='$id_admin')"))) {
			$errors[] = $lang['errors_login_exists'];
		}
		
		if (!$id_group) {
			$errors[] = $lang['errors_group_id_empty'];
		} elseif (!$db->sql_numrows($db->sql_query("select * from admins_groups where id='$id_group'"))) {
			$errors[] = $lang['errors_group_id_incorrect'];
		}
	}
	
	if (!$id_admin || $_POST['change_pass']) {
		if (!$password1 || !$password2) {
			$errors[] = $lang['errors_passwords_empty'];
		} elseif ($password1 != $password2) {
			$errors[] = $lang['errors_passwords_mismatch'];
		}
	}
	
	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		
		$tpl->assign('id_admin',$id_admin);
		$tpl->assign('id_group',$id_group);
		$tpl->assign('login',$login);
		$tpl->assign('groups',$groups);
		$tpl->display('admins_modify.tpl');
		exit;
		
	} elseif($_POST['confirm']) {
		if ($id_admin) {
			if ($_POST['change_pass']) {
				$db->sql_query("update admins set passwd='". md5($password1). "' where id='$id_admin'");
			} else {
				$db->sql_query("update admins set login='$login', id_group='$id_group' where id='$id_admin'");
			}
		} else {
			$db->sql_query("insert into admins (login, passwd, id_group) values('$login', '". md5($password1). "', '$id_group')"); 	
		}
		header("location: admins.php?id_group=$id_group");
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
			$db->sql_query("delete from admins where id='$value'");
		}
		header("location: admins.php?id_group=$id_group");
		exit;
	}
}

$id_group = intval($_POST['id_group']) ? intval($_POST['id_group']) : intval($_GET['id_group']);

$groups['ids'][] = 0;
$groups['names'][] = $lang['all'];

$sql_where = $id_group ? "and id_group='$id_group'" : '';
$db->sql_query("select admins.id as \"id_admin\", admins.id_group, admins.login, admins.last_login, admins_groups.group_name
				from admins, admins_groups
				where (admins.id_group=admins_groups.id $sql_where) 
				order by admins.id_group, admins.id");
$admins = array();
while ($admins[] = $db->sql_fetchrow());
unset($admins[count($admins)-1]);

$tpl->assign('groups',$groups);
$tpl->assign('id_group',$id_group);
$tpl->assign('admins',$admins);
$tpl->display('admins.tpl');	
?>