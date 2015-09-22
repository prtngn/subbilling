<?php
define('SQL_INC',1);
define('CURR_MENU','reports');
define('CURR_SUBMENU','connections');
require 'inc/common.inc.php';

$year1 = ($_POST['year1']>=2006 && $_POST['year1']<=2037) ? $_POST['year1'] : (($_GET['year1']>=2006 && $_GET['year1']<=2037) ? $_GET['year1'] : date('Y'));
$month1 = ($_POST['month1']>=1 && $_POST['month1']<=12) ? $_POST['month1'] : (($_GET['month1']>=1 && $_GET['month1']<=12) ? $_GET['month1'] : date('n'));
$day1 = ($_POST['day1']>=1 && $_POST['day1']<=31) ? $_POST['day1'] : (($_GET['day1']>=1 && $_GET['day1']<=31) ? $_GET['day1'] : date('j'));
$hour1 = ($_POST['hour1']>=0 && $_POST['hour1']<=23) ? $_POST['hour1'] : (($_GET['hour1']>=0 && $_GET['hour1']<=23) ? $_GET['hour1'] : 0);
$min1 = ($_POST['min1']>=0 && $_POST['min1']<=59) ? $_POST['min1'] : (($_GET['min1']>=0 && $_GET['min1']<=59) ? $_GET['min1'] : 0);

$year2 = ($_POST['year2']>=2006 && $_POST['year2']<=2037) ? $_POST['year2'] : (($_GET['year2']>=2006 && $_GET['year2']<=2037) ? $_GET['year2'] : date('Y'));
$month2 = ($_POST['month2']>=1 && $_POST['month2']<=12) ? $_POST['month2'] : (($_GET['month2']>=1 && $_GET['month2']<=12) ? $_GET['month2'] : date('n'));
$day2 = ($_POST['day2']>=1 && $_POST['day2']<=31) ? $_POST['day2'] : (($_GET['day2']>=1 && $_GET['day2']<=31) ? $_GET['day2'] : date('j'));
$hour2 = (isset($_POST['hour2']) && $_POST['hour2']>=0 && $_POST['hour2']<=23) ? $_POST['hour2'] : ((isset($_GET['hour2']) && $_GET['hour2']>=0 && $_GET['hour2']<=23) ? $_GET['hour2'] : 23);
$min2 = (isset($_POST['min2']) && $_POST['min2']>=0 && $_POST['min2']<=59) ? $_POST['min2'] : ((isset($_GET['min2']) && $_GET['min2']>=0 && $_GET['min2']<=59) ? $_GET['min2'] : 59);

$day1 = cal_days_in_month(CAL_GREGORIAN, $month1, $year1)<$day1 ? cal_days_in_month(CAL_GREGORIAN, $month1, $year1) : $day1;
$day2 = cal_days_in_month(CAL_GREGORIAN, $month2, $year2)<$day2 ? cal_days_in_month(CAL_GREGORIAN, $month2, $year2) : $day2;

$tpl->assign('year1',$year1);
$tpl->assign('year2',$year2);
$tpl->assign('month1',$month1);
$tpl->assign('month2',$month2);
$tpl->assign('day1',$day1);
$tpl->assign('day2',$day2);
$tpl->assign('hour1',$hour1);
$tpl->assign('hour2',$hour2);
$tpl->assign('min1',$min1);
$tpl->assign('min2',$min2);

$time_from = mktime($hour1, $min1, 1, $month1, $day1, $year1);
$time_to = mktime($hour2, $min2, 59, $month2, $day2, $year2);

$db->sql_query("select inet_ntoa(addr) as \"addr\", time_start, time_end from history where id_user='$id_user' and (time_start between '$time_from' and '$time_to') order by time_start");
while ($connections[] = $db->sql_fetchrow());
unset($connections[count($connections)-1]); 
$tpl->assign('connections',$connections);

$tpl->display('connections.tpl');

?>