<?php
define('SQL_INC',1);
define('CURR_MENU','payments');

require 'inc/common.inc.php';

$year1 = preg_match('/^(20[0-9][0-9])$/',$_POST['year1']) ? $_POST['year1'] : (preg_match('/^(20[0-9][0-9])$/',$_GET['year1']) ? $_GET['year1'] : date('Y'));
$month1 = preg_match('/^([1-9]|1[12])$/',$_POST['month1']) ? $_POST['month1'] : (preg_match('/^([1-9]|1[12])$/',$_GET['month1']) ? $_GET['month1'] : date('n'));
$day1 = preg_match('/^([1-9]|[1-2][0-9]|3[0-1])$/',$_POST['day1']) ? $_POST['day1'] : (preg_match('/^([1-9]|[1-2][0-9]|3[0-1])$/',$_GET['day1']) ? $_GET['day1'] : date('j'));
$hour1 = preg_match('/^([0-9]|1[0-9]|2[0-3])$/',$_POST['hour1']) ? $_POST['hour1'] : (preg_match('/^([0-9]|1[0-9]|2[0-3])$/',$_GET['hour1']) ? $_GET['hour1'] : 0);

$year2 = preg_match('/^(20[0-9][0-9])$/',$_POST['year2']) ? $_POST['year2'] : (preg_match('/^(20[0-9][0-9])$/',$_GET['year2']) ? $_GET['year2'] : date('Y'));
$month2 = preg_match('/^([1-9]|1[0-2])$/',$_POST['month2']) ? $_POST['month2'] : (preg_match('/^([1-9]|1[0-2])$/',$_GET['month2']) ? $_GET['month2'] : date('n'));
$day2 = preg_match('/^([1-9]|[1-2][0-9]|3[0-1])$/',$_POST['day2']) ? $_POST['day2'] : (preg_match('/^([1-9]|[1-2][0-9]|3[0-1])$/',$_GET['day2']) ? $_GET['day2'] : date('j'));
$hour2 = preg_match('/^([0-9]|1[0-9]|2[0-3])$/',$_POST['hour2']) ? $_POST['hour2'] : (preg_match('/^([0-9]|1[0-9]|2[0-3])$/',$_GET['hour2']) ? $_GET['hour2'] : 23);

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

$time_from = mktime($hour1, 0, 1, $month1, $day1, $year1);
$time_to = mktime($hour2, 59, 59, $month2, $day2, $year2);


$db->sql_query("select inet_ntoa(addr) as 'addr', time_start, time_end from history where id_user='$id_user' order by time_start");

while ($history[] = $db->sql_fetchrow());
unset($connections[count($connections)-1]); 
$tpl->assign('history',$connections);

$tpl->display('connections.tpl');

?>