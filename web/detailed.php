<?php
define('SQL_INC',1);
define('CURR_MENU','detailed');
require 'inc/common.inc.php';

$date1['year'] = ($_POST['year1']>=2006 && $_POST['year1']<=2037) ? $_POST['year1'] : (($_GET['year1']>=2006 && $_GET['year1']<=2037) ? $_GET['year1'] : date('Y'));
$date1['month'] = ($_POST['month1']>=1 && $_POST['month1']<=12) ? $_POST['month1'] : (($_GET['month1']>=1 && $_GET['month1']<=12) ? $_GET['month1'] : date('n'));
$date1['day'] = $type>2 ? 1 : (($_POST['day1']>=1 && $_POST['day1']<=31) ? $_POST['day1'] : (($_GET['day1']>=1 && $_GET['day1']<=31) ? $_GET['day1'] : date('j')));
$date1['hour'] = $type>1 ? 0 : ((isset($_POST['hour1']) && $_POST['hour1']>=0 && $_POST['hour1']<=23) ? $_POST['hour1'] : ((isset($_GET['hour1']) && $_GET['hour1']>=0 && $_GET['hour1']<=23) ? $_GET['hour1'] : 0));
$date1['min'] = $type ? 0 : ((isset($_POST['min1']) && $_POST['min1']>=0 && $_POST['min1']<=59) ? $_POST['min1'] : ((isset($_GET['min1']) && $_GET['min1']>=0 && $_GET['min1']<=59) ? $_GET['min1'] : 0));

$date2['year'] = ($_POST['year2']>=2006 && $_POST['year2']<=2037) ? $_POST['year2'] : (($_GET['year2']>=2006 && $_GET['year2']<=2037) ? $_GET['year2'] : date('Y'));
$date2['month'] = ($_POST['month2']>=1 && $_POST['month2']<=12) ? $_POST['month2'] : (($_GET['month2']>=1 && $_GET['month2']<=12) ? $_GET['month2'] : date('n'));
$date2['day'] = $type>2 ? cal_days_in_month(CAL_GREGORIAN, $date2['month'], $date2['year']) : (($_POST['day2']>=1 && $_POST['day2']<=31) ? $_POST['day2'] : (($_GET['day2']>=1 && $_GET['day2']<=31) ? $_GET['day2'] : date('j')));
$date2['hour'] = $type>1 ? 23 : ((isset($_POST['hour2']) && $_POST['hour2']>=0 && $_POST['hour2']<=23) ? $_POST['hour2'] : ((isset($_GET['hour2']) && $_GET['hour2']>=0 && $_GET['hour2']<=23) ? $_GET['hour2'] : 23));
$date2['min'] = $type ? 59 : ((isset($_POST['min2']) && $_POST['min2']>=0 && $_POST['min2']<=59) ? $_POST['min2'] : ((isset($_GET['min2']) && $_GET['min2']>=0 && $_GET['min2']<=59) ? $_GET['min2'] : 59));

$date1['day'] = cal_days_in_month(CAL_GREGORIAN, $date1['month'], $date1['year'])<$date1['day'] ? cal_days_in_month(CAL_GREGORIAN, $date1['month'], $date1['year']) : $date1['day'];
$date2['day'] = cal_days_in_month(CAL_GREGORIAN, $date2['month'], $date2['year'])<$date2['day'] ? cal_days_in_month(CAL_GREGORIAN, $date2['month'], $date2['year']) : $date2['day'];

$time_from = mktime($date1['hour'], $date1['min'], 1, $date1['month'], $date1['day'], $date1['year']);
$time_to = mktime($date2['hour'], $date2['min'], 59, $date2['month'], $date2['day'], $date2['year']);

$db->sql_query("select inet_ntoa(src) as \"src\", inet_ntoa(dst) as \"dst\", port, byte_in as \"incoming\", byte_out as \"outgoing\", time as \"time\" from traff where (time between '$time_from' and '$time_to') and uid='$id_user'");

while ($detailed[] = $db->sql_fetchrow());
unset($detailed[count($detailed)-1]); 

$tpl->assign('date1',$date1);
$tpl->assign('date2',$date2);
$tpl->assign('detailed',$detailed);
$tpl->display('detailed.tpl');
?>
