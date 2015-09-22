<?php
define('SQL_INC',1);
define('CURR_MENU','users_accounts');
require 'inc/common.inc.php';

check_permissions(CURR_MENU,1);

$groups = get_users_groups();

$id_account = intval($_POST['id_account']) ? intval($_POST['id_account']) : intval($_GET['id_account']);
if ($_POST['search']) {
	$search_text = preg_match('/^[a-zA-Z0-9а-яА-Я_\\*\\?]+$/u', $_POST['search_text']) ? $_POST['search_text'] : '';
	$search_text=str_replace(array("*","?"),array("%","_"), $search_text);
}
if ($_POST['modify'] || $_GET['id_account']) {
	check_permissions(CURR_MENU,2);

	if (!$_POST['confirm'] && $id_account) {
		$db->sql_query("select * from users_accounts where users_accounts.id='$id_account'");
		$result = $db->sql_fetchrow();
	}

	$id_group = $_POST['id_group'] ? intval($_POST['id_group']) : $result['id_group'];
	$password1 = $_POST['confirm'] ? $_POST['password1'] : $result['password'];
	$password2 = $_POST['confirm'] ? $_POST['password2'] : $result['password'];
	$deposit = $_POST['confirm'] ? $_POST['deposit'] : $result['deposit'];
	$max_credit = $_POST['confirm'] ? $_POST['max_credit'] : $result['max_credit'];
	$lastname = $_POST['confirm'] ? addslashes($_POST['lastname']) : $result['lastname'];
	$name = $_POST['confirm'] ? addslashes($_POST['name']) : $result['name'];
	$surname = $_POST['confirm'] ? addslashes($_POST['surname']) : $result['surname'];
	$address = $_POST['confirm'] ? addslashes($_POST['address']) : $result['address'];
	$phone = $_POST['confirm'] ? addslashes($_POST['phone']) : $result['phone'];
        $passport = $_POST['confirm'] ? addslashes($_POST['passport']) : $result['passport'];

	$errors = array();
	
	if (!$id_group) {
		$errors[] = $lang['errors_group_id_empty'];
	} elseif (!$db->sql_numrows($db->sql_query("select * from users_groups where id='$id_group'"))) {
		$errors[] = $lang['errors_group_id_incorrect'];
	}
	
	if (!$password1 || !$password2) {
		$errors[] = $lang['errors_passwords_empty'];
	} elseif (!preg_match('/^\\w{3,64}$/', $password1) || !preg_match('/^\\w{3,64}$/', $password2)) {
		$errors[] = $lang['errors_passwords_incorrect'];
	} elseif ($password1 != $password2) {
		$errors[] = $lang['errors_passwords_mismatch'];
	}
	
	if (!preg_match('/^-?\\d+(\\.\\d+)?$/', $deposit)) {
		$errors[] = $lang['errors_deposit_incorrect'];
	}

	if (!preg_match('/^-?\\d+(\\.\\d+)?$/', $max_credit)) {
		$errors[] = $lang['errors_credit_incorrect'];
	}
	
	if (!$name) {
		$errors[] = $lang['errors_name_empty'];
	}

        if (!$lastname) {
                $errors[] = $lang['errors_lastname_empty'];
        }

        if (!$surname) {
                $errors[] = $lang['errors_surname_empty'];
        }
	
	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}

		$tpl->assign('id_account',$id_account);
		$tpl->assign('id_group',$id_group);
		$tpl->assign('password1',$password1);
		$tpl->assign('password2',$password2);
		$tpl->assign('deposit',$deposit);
		$tpl->assign('max_credit',$max_credit);
		$tpl->assign('name',$name);
                $tpl->assign('lastname',$lastname);
                $tpl->assign('surname',$surname);
		$tpl->assign('address',$address);
                $tpl->assign('phone',$phone);
                $tpl->assign('passport',$passport);
		$tpl->assign('groups',$groups);
		$tpl->display('accounts_modify.tpl');
		exit;
		
	} elseif($_POST['confirm']) {
		if ($id_account) {
		$db->sql_query("update users_accounts set password='$password1', id_group='$id_group', deposit='$deposit', max_credit='$max_credit', name='$name', lastname='$lastname', surname='$surname', address='$address', phone='$phone', passport='$passport' where id='$id_account'"); 
		} else {
			$db->sql_query("insert into users_accounts (id_group, password, lastname, name, surname, address, phone, passport, deposit, max_credit, registered) values('$id_group', '$password1', '$lastname', '$name', '$surname', '$address', '$phone', '$passport', '$deposit', '$max_credit', '". time() ."')");
		}
		header("location: accounts.php?id_group=$id_group");
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
			$users = $db->sql_fetchrow($db->sql_query("select id from users where id_account='$value'"));
			if ($users) {
				foreach ($users as $val) {
					list($iface) = $db->sql_fetchrow($db->sql_query("select iface from sessions where id_user='$val'"));
					if ($iface) {
						system("/usr/bin/sudo /bin/kill `cat /var/run/$iface.pid`");
					}
					$db->sql_query("delete from data where id_user='$val'");
					$db->sql_query("delete from payments where id_user='$val'");
					$db->sql_query("delete from history where id_user='$val'");
					$db->sql_query("delete from users where id='$val'");
					$db->sql_query("delete from traff where uid='$val'");
				}
			}
			$db->sql_query("delete from users_accounts where id='$value'");
		}
		header("location: accounts.php?id_group=$id_group");
		exit;
	}
}

$id_group = isset($_POST['id_group']) ? intval($_POST['id_group']) : intval($_GET['id_group']);

$groups['ids'][] = 0;
$groups['names'][] = $lang['all'];

$tpl->assign('groups',$groups);
$tpl->assign('id_group',$id_group);
if ($search_text) {
	$sql_where = "and ((users_accounts.id like '%$search_text%') or (users_accounts.name like '%$search_text%') or (users_accounts.lastname like '%$search_text%'))";
} else {
	$sql_where = $id_group ? "and id_group='$id_group'" : '';
}
$query_res = $db->sql_query("select users_accounts.id as \"id_account\", users_accounts.id_group, users_accounts.lastname, users_accounts.name, users_accounts.surname, users_accounts.deposit, users_accounts.address, users_accounts.phone, users_accounts.passport, users_groups.group_name from users_accounts, users_groups where (users_accounts.id_group=users_groups.id $sql_where) order by users_accounts.id_group, users_accounts.id");
$users = array();
while ($users[] = $db->sql_fetchrow());
unset($users[count($users)-1]);

$tpl->assign('users',$users);
$tpl->display('accounts.tpl');	
?>
