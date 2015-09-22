<?php
define('SQL_INC',1);
define('CURR_MENU','payments');
require 'inc/common.inc.php';
check_permissions(CURR_MENU,1);

$id_user = isset($_POST['id_user']) ? intval($_POST['id_user']) : intval($_GET['id_user']);

$date1['year'] = ($_POST['year1']>=2006 && $_POST['year1']<=2037) ? $_POST['year1'] : (($_GET['year1']>=2006 && $_GET['year1']<=2037) ? $_GET['year1'] : date('Y'));
$date1['month'] = ($_POST['month1']>=1 && $_POST['month1']<=12) ? $_POST['month1'] : (($_GET['month1']>=1 && $_GET['month1']<=12) ? $_GET['month1'] : date('n'));
$date1['day'] = ($_POST['day1']>=1 && $_POST['day1']<=31) ? $_POST['day1'] : (($_GET['day1']>=1 && $_GET['day1']<=31) ? $_GET['day1'] : 1);

$date2['year'] = ($_POST['year2']>=2006 && $_POST['year2']<=2037) ? $_POST['year2'] : (($_GET['year2']>=2006 && $_GET['year2']<=2037) ? $_GET['year2'] : date('Y'));
$date2['month'] = ($_POST['month2']>=1 && $_POST['month2']<=12) ? $_POST['month2'] : (($_GET['month2']>=1 && $_GET['month2']<=12) ? $_GET['month2'] : date('n'));
$date2['day'] = ($_POST['day2']>=1 && $_POST['day2']<=31) ? $_POST['day2'] : (($_GET['day2']>=1 && $_GET['day2']<=31) ? $_GET['day2'] : 31);

$date1['day'] = cal_days_in_month(CAL_GREGORIAN, $date1['month'], $date1['year'])<$date1['day'] ? cal_days_in_month(CAL_GREGORIAN, $date1['month'], $date1['year']) : $date1['day'];
$date2['day'] = cal_days_in_month(CAL_GREGORIAN, $date2['month'], $date2['year'])<$date2['day'] ? cal_days_in_month(CAL_GREGORIAN, $date2['month'], $date2['year']) : $date2['day'];

$time_from = mktime(0, 0, 1, $date1['month'], $date1['day'], $date1['year']);
$time_to = mktime(23, 59, 59, $date2['month'], $date2['day'], $date2['year']);

$sql_where = $id_user ? "and payments.id_user='$id_user'" : '';
$db->sql_query("select payments.id_user, payments.pay_value, payments.pay_time, payments.action, payments.who, users_accounts.name, users_accounts.lastname from payments, users_accounts where payments.id_user=users_accounts.id $sql_where and (pay_time between '$time_from' and '$time_to') order by pay_time");
while ($payments[] = $db->sql_fetchrow());
unset($payments[count($payments)-1]); 

#$users = get_users(true);
$users = get_users_accounts();

$tpl->assign('users',$users);
$tpl->assign('id_user',$id_user);
$tpl->assign('date11',$date1);
$tpl->assign('date2',$date2);
$tpl->assign('payments',$payments);
$tpl->display('payments.tpl');
?>
