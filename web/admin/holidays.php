<?php
define('SQL_INC',1);
define('CURR_MENU','tariffs');
define('CURR_SUBMENU','tariffs_holidays');
require 'inc/common.inc.php';
check_permissions(CURR_SUBMENU,1);

$id_tariff = isset($_POST['id_tariff']) ? intval($_POST['id_tariff']) : intval($_GET['id_tariff']);
	
$tariffs = get_tariffs();

$id_holiday = intval($_POST['id_holiday']) ? intval($_POST['id_holiday']) : intval($_GET['id_holiday']);

if ($_POST['modify'] || $id_holiday) {
	check_permissions(CURR_SUBMENU,2);
	
	if (!$_POST['confirm']) {
		$db->sql_query("select id_tariff, day, discount_in, discount_out, description from holidays where id='$id_holiday'");
		$result = $db->sql_fetchrow();
	}
	
	$day = $_POST['confirm'] ? $_POST['day'] : $result['day'];
	$id_tariff = $_POST['id_tariff'] ? intval($_POST['id_tariff']) : $result['id_tariff'];
	$discount_in = $_POST['confirm'] ? intval($_POST['discount_in']) : $result['discount_in'];
	$discount_out = $_POST['confirm'] ? intval($_POST['discount_out']) : $result['discount_out'];
	$description = $_POST['confirm'] ? addslashes($_POST['description']) : $result['description'];
	
	if (!$day) {
		$errors[] = $lang['errors_holiday_empty'];
	} elseif (!preg_match('/^[1-7]$/',$day) && !preg_match('/^(0[1-9]|[1-2][0-9]|3[0-1])\.(0[1-9]|1[1-2])$/',$day)) {
		$errors[] = $lang['errors_holiday_incorrect'];
	} elseif($db->sql_numrows($db->sql_query("select * from holidays where day='$day' and id_tariff='$id_tariff' and not(id='$id_holiday')"))) {
		$errors[] = $lang['errors_holiday_exists'];
	}
	
	if (!$id_tariff) {
		$errors[] = $lang['errors_tariff_id_empty'];
	} elseif (!$db->sql_numrows($db->sql_query("select * from tariffs where id='$id_tariff'"))) {
		$errors[] = $lang['errors_tariff_id_incorrect'];
	}
	
	if (!preg_match('/^([0-9]?[0-9]|100)$/',$discount_in)) {
		$errors[] = $lang['errors_discount_in_incorrect'];
	}	
	
	if (!preg_match('/^([0-9]?[0-9]|100)$/',$discount_out)) {
		$errors[] = $lang['errors_discount_out_incorrect'];
	}
	
	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		
		$tpl->assign('id_holiday',$id_holiday);
		$tpl->assign('id_tariff',$id_tariff);
		$tpl->assign('tariffs',$tariffs);
		$tpl->assign('day',$day);
		$tpl->assign('discount_in',$discount_in);
		$tpl->assign('discount_out',$discount_out);
		$tpl->assign('description',stripslashes($description));
		$tpl->display('holidays_modify.tpl');
		exit;
		
	} elseif($_POST['confirm']) {
		if ($id_holiday) {
			$db->sql_query("update holidays set day='$day', id_tariff='$id_tariff', discount_in='$discount_in', discount_out='$discount_out', description='$description' where id='$id_holiday'"); 
		} else {
			$db->sql_query("insert into holidays (day, id_tariff, discount_in, discount_out, description) values('$day', '$id_tariff', '$discount_in', '$discount_out','$description')"); 	
		}
		header("location: holidays.php?id_tariff=$id_tariff");
		exit;
	}
}

if ($_POST['delselected'] || $_GET['delselected']) {
	check_permissions(CURR_SUBMENU,2);
	
	$id=isset($_POST['id']) ? $_POST['id'] : $_GET['id'];	
	if (count($id)) {
		foreach ($id as $value) {
			$value=intval($value);
			$db->sql_query("delete from holidays where id='$value'");
		}
		header("location: holidays.php?id_tariff=$id_tariff");
		exit;
	}
}

$tariffs['ids'][] = 0;
$tariffs['names'][] = $lang['all'];

$holidays = array();
$sql_where = $id_tariff ? "and id_tariff='$id_tariff'" : '';
$db->sql_query("select holidays.id as \"id_holiday\", holidays.day, holidays.id_tariff, holidays.discount_in, holidays.discount_out, holidays.description, tariffs.tariff_name
				from holidays, tariffs
				where holidays.id_tariff=tariffs.id $sql_where
				order by holidays.id_tariff, holidays.day");

while ($holidays[] = $db->sql_fetchrow());
unset($holidays[count($holidays)-1]); 

$tpl->assign('id_tariff',$id_tariff);
$tpl->assign('tariffs',$tariffs);
$tpl->assign('holidays',$holidays);
$tpl->display('holidays.tpl');
?>