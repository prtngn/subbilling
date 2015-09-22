<?php
define('SQL_INC',1);
define('CURR_MENU','reports');
define('CURR_SUBMENU','payments');
require 'inc/common.inc.php';

$year1 = ($_POST['year1']>=2006 && $_POST['year1']<=2037) ? $_POST['year1'] : (($_GET['year1']>=2006 && $_GET['year1']<=2037) ? $_GET['year1'] : date('Y'));
$month1 = ($_POST['month1']>=1 && $_POST['month1']<=12) ? $_POST['month1'] : (($_GET['month1']>=1 && $_GET['month1']<=12) ? $_GET['month1'] : date('n'));
$day1 = ($_POST['day1']>=1 && $_POST['day1']<=31) ? $_POST['day1'] : (($_GET['day1']>=1 && $_GET['day1']<=31) ? $_GET['day1'] : 1);

$year2 = ($_POST['year2']>=2006 && $_POST['year2']<=2037) ? $_POST['year2'] : (($_GET['year2']>=2006 && $_GET['year2']<=2037) ? $_GET['year2'] : date('Y'));
$month2 = ($_POST['month2']>=1 && $_POST['month2']<=12) ? $_POST['month2'] : (($_GET['month2']>=1 && $_GET['month2']<=12) ? $_GET['month2'] : date('n'));
$day2 = ($_POST['day2']>=1 && $_POST['day2']<=31) ? $_POST['day2'] : (($_GET['day2']>=1 && $_GET['day2']<=31) ? $_GET['day2'] : 31);

$day1 = cal_days_in_month(CAL_GREGORIAN, $month1, $year1)<$day1 ? cal_days_in_month(CAL_GREGORIAN, $month1, $year1) : $day1;
$day2 = cal_days_in_month(CAL_GREGORIAN, $month2, $year2)<$day2 ? cal_days_in_month(CAL_GREGORIAN, $month2, $year2) : $day2;

$tpl->assign('year1',$year1);
$tpl->assign('year2',$year2);
$tpl->assign('month1',$month1);
$tpl->assign('month2',$month2);
$tpl->assign('day1',$day1);
$tpl->assign('day2',$day2);

$time_from = mktime(0, 0, 1, $month1, $day1, $year1);
$time_to = mktime(23, 59, 59, $month2, $day2, $year2);

$db->sql_query("select payments.pay_value, payments.pay_time, payments.action from payments, users_accounts, users where payments.id_user=users_accounts.id and users.id_account=users_accounts.id and users.id='$id_user' and (pay_time between '$time_from' and '$time_to') order by pay_time");
while ($payments[] = $db->sql_fetchrow());
unset($payments[count($payments)-1]); 
$tpl->assign('payments',$payments);

$tpl->display('payments.tpl');

?>
