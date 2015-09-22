<?php
define('SQL_INC',1);
define('CURR_MENU','reports');
define('CURR_SUBMENU','stats');
require 'inc/common.inc.php';

$id_group = isset($_POST['id_group']) ? intval($_POST['id_group']) : intval($_GET['id_group']);
$type = isset($_POST['type']) ? intval($_POST['type']) : (isset($_GET['type']) ? intval($_GET['type']) : 1); 
$level = isset($_POST['level']) ? intval($_POST['level']) : (isset($_GET['level']) ? intval($_GET['level']) : 0); 

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

$types = array(0,1,2,3);
switch ($type) {
	case 0:
		$sql_cols = "minute(from_unixtime(data.log_time)) as \"i\", hour(from_unixtime(data.log_time)) as \"G\", day(from_unixtime(data.log_time)) as \"j\", month(from_unixtime(data.log_time)) as \"n\", year(from_unixtime(data.log_time)) as \"Y\"";
		$sql_cols2 = "minute(from_unixtime(data_old.log_time)) as \"i\", hour(from_unixtime(data_old.log_time)) as \"G\", day(from_unixtime(data_old.log_time)) as \"j\", month(from_unixtime(data_old.log_time)) as \"n\", year(from_unixtime(data_old.log_time)) as \"Y\"";
		$sql_group_by = 'group by "i", "G", "j", "n", "Y"';
		break;
	case 1:
		$sql_cols = "'0' as \"i\", hour(from_unixtime(data.log_time)) as \"G\", day(from_unixtime(data.log_time)) as \"j\", month(from_unixtime(data.log_time)) as \"n\", year(from_unixtime(data.log_time)) as \"Y\"";
		$sql_cols2 = "'0' as \"i\", hour(from_unixtime(data_old.log_time)) as \"G\", day(from_unixtime(data_old.log_time)) as \"j\", month(from_unixtime(data_old.log_time)) as \"n\", year(from_unixtime(data_old.log_time)) as \"Y\"";
		$sql_group_by = 'group by "G", "j", "n", "Y"';
		break;
	case 2:
		$sql_cols = "'0' as \"i\", '0' as \"G\", day(from_unixtime(data.log_time)) as \"j\", month(from_unixtime(data.log_time)) as \"n\", year(from_unixtime(data.log_time)) as \"Y\"";
		$sql_cols2 = "'0' as \"i\", '0' as \"G\", day(from_unixtime(data_old.log_time)) as \"j\", month(from_unixtime(data_old.log_time)) as \"n\", year(from_unixtime(data_old.log_time)) as \"Y\"";
		$sql_group_by = 'group by "j", "n", "Y"';
		break;
	case 3:
		$sql_cols = "'0' as \"i\", '0' as \"G\", '0' as \"j\", month(from_unixtime(data.log_time)) as \"n\", year(from_unixtime(data.log_time)) as \"Y\"";
		$sql_cols2 = "'0' as \"i\", '0' as \"G\", '0' as \"j\", month(from_unixtime(data_old.log_time)) as \"n\", year(from_unixtime(data_old.log_time)) as \"Y\"";
		$sql_group_by = 'group by "n", "Y"';
		break;
	default:
		$sql_cols = "'0' as \"i\", '0' as \"G\", '0' as \"j\", '0' as \"n\", year(from_unixtime(data.log_time)) as \"Y\"";
		$sql_cols2 = "'0' as \"i\", '0' as \"G\", '0' as \"j\", '0' as \"n\", year(from_unixtime(data_old.log_time)) as \"Y\"";
		$sql_group_by = 'group by "Y"';
		$type = 2;
}

$sql_where =  $id_group ? "and data.id_group='$id_group' " : '';
$sql_where2 =  $id_group ? "and data_old.id_group='$id_group' " : '';

if ($level) {
	$db->sql_query("select sum(data_old.incoming) as \"incoming\", sum(data_old.outgoing) as \"outgoing\", data_old.id_group, routes_groups.group_name, sum(data_old.cost) as \"cost\" from data_old inner join routes_groups on data_old.id_group=routes_groups.id where (data_old.log_time between '$time_from' and '$time_to') and data_old.id_user='$id_user' group by data_old.id_group, routes_groups.group_name order by data_old.id_group");
	while ($stats2[] = $db->sql_fetchrow());
	$db->sql_query("select sum(data.incoming) as \"incoming\", sum(data.outgoing) as \"outgoing\", data.id_group, routes_groups.group_name, sum(data.cost) as \"cost\" from data inner join routes_groups on data.id_group=routes_groups.id where (data.log_time between '$time_from' and '$time_to') and data.id_user='$id_user' group by data.id_group, routes_groups.group_name order by data.id_group");
} else {
	$db->sql_query("select $sql_cols2, sum(data_old.incoming) as \"incoming\", sum(data_old.outgoing) as \"outgoing\", min(data_old.log_time) as \"log_time\", sum(data_old.cost) as \"cost\" from data_old where (data_old.log_time between '$time_from' and '$time_to') and data_old.id_user='$id_user' $sql_where2 $sql_group_by order by \"Y\", \"n\", \"j\", \"G\", \"i\"");
	while ($stats2[] = $db->sql_fetchrow());
	$db->sql_query("select $sql_cols, sum(data.incoming) as \"incoming\", sum(data.outgoing) as \"outgoing\", min(data.log_time) as \"log_time\", sum(data.cost) as \"cost\" from data where (data.log_time between '$time_from' and '$time_to') and data.id_user='$id_user' $sql_where $sql_group_by order by \"Y\", \"n\", \"j\", \"G\", \"i\"");
	
}
unset($stats2[count($stats2)-1]);
$stats = $stats2;
while ($stats[] = $db->sql_fetchrow());
unset($stats[count($stats)-1]); 

$groups = get_routes_groups(true);

$tpl->assign('date1',$date1);
$tpl->assign('date2',$date2);
$tpl->assign('type',$type);
$tpl->assign('types',$types);
$tpl->assign('level',$level);
$tpl->assign('groups',$groups);
$tpl->assign('id_group',$id_group);
$tpl->assign('stats',$stats);
$tpl->display('stats.tpl');
?>
