<?php
define('SQL_INC',1);
define('CURR_MENU','tariffs');
require 'inc/common.inc.php';
check_permissions(CURR_MENU,1);

$id_tariff = intval($_POST['id_tariff']) ? intval($_POST['id_tariff']) : intval($_GET['id_tariff']);
if ($_POST['modify'] || $id_tariff) {
	check_permissions(CURR_MENU,2);
	
	if (!$_POST['confirm'] && $id_tariff) {
		$db->sql_query("select tariff_name, period, payment, p_in, p_out, on_connect, on_disconnect, pub, route from tariffs where id='$id_tariff'");
		$result = $db->sql_fetchrow();
	}

	$tariff_name = $_POST['confirm'] ? addslashes($_POST['tariff_name']) : $result['tariff_name'];
	$period = $_POST['confirm'] ? intval($_POST['period']*86400) : $result['period'];
	$payment = $_POST['confirm'] ? $_POST['payment'] : $result['payment'];
	$p_in = $_POST['confirm'] ? intval($_POST['p_in'])*1024*1024 : $result['p_in'];
	$p_out = $_POST['confirm'] ? intval($_POST['p_out'])*1024*1024 : $result['p_out'];
	$on_connect = $_POST['confirm'] ? addslashes($_POST['on_connect']) : $result['on_connect'];
	$on_disconnect = $_POST['confirm'] ? addslashes($_POST['on_disconnect']) : $result['on_disconnect'];
	$pub = $_POST['confirm'] ? intval($_POST['pub']) : $result['pub'];
	$route = $_POST['confirm'] ? intval($_POST['route']) : $result['route'];
	
	
	if (!$tariff_name) {
		$errors[] = $lang['errors_tariff_name_empty'];
	} elseif($db->sql_numrows($db->sql_query("select * from tariffs where tariff_name='$tariff_name' and not(id='$id_tariff')"))) {
		$errors[] = $lang['errors_tariff_name_exists'];
	}
	if (!$route) {
                $errors[] = $lang['errors_route_empty'];
        }
	if (!preg_match('/^\\d+(\\.\\d+)?$/', $payment)) {
		$errors[] = $lang['errors_payment_incorrect'];
	}
	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		$db->sql_query('select id, name from configs_route');
		while (list($id_user, $user_login) = $db->sql_fetchrow()) {
			$routes['ids'][] = $id_user;
			$routes['names'][] = $user_login;
		}
		$tpl->assign('id_tariff',$id_tariff);
		$tpl->assign('tariff_name',stripslashes($tariff_name));
		$tpl->assign('period',$period/86400);
		$tpl->assign('payment',$payment);
		$tpl->assign('p_in',$p_in/1024/1024);
		$tpl->assign('p_out',$p_out/1024/1024);
		$tpl->assign('on_connect',stripslashes($on_connect));
		$tpl->assign('on_disconnect',stripslashes($on_disconnect));
		$tpl->assign('pub',$pub);
		$tpl->assign('routes',$routes);
		$tpl->display('tariffs_modify.tpl');
		exit;
	} elseif($_POST['confirm']) {
		if ($id_tariff) {
			$db->sql_query("update tariffs set tariff_name='$tariff_name', period='$period', payment='$payment', p_in='$p_in', p_out='$p_out', pub='$pub', route='$route' where id='$id_tariff'"); 
		} else {
			$db->sql_query("insert into tariffs (tariff_name, period, payment, p_in, p_out, pub, route) values('$tariff_name', '$period', '$payment', '$p_in', '$p_out', '$pub', '$route')"); 	
		}
		header('location: tariffs.php');
		exit;
	}
}
if ($_POST['delselected'] || $_GET['delselected']) {
	check_permissions(CURR_MENU,2);
	
	$id=isset($_POST['id']) ? $_POST['id'] : $_GET['id'];
	if (count($id)) {
		foreach ($id as $value) {
			$value=intval($value);
			$users_res = $db->sql_query("select id from users where id_tariff='$value'");
			while (list($id_user)=$db->sql_fetchrow($users_res)) {
				$db->sql_query("delete from data where id_user='$id_user'");
                                $db->sql_query("delete from traff where uid='$id_user'");
			}
			$db->sql_query("delete from users where id_tariff='$value'");
			$db->sql_query("delete from tariffs where id='$value'");
		}
		header('location: tariffs.php');
		exit;
	}
}
$tariffs = array();
$query_res = $db->sql_query("select tariffs.id as \"id_tariff\", tariffs.tariff_name, tariffs.period, tariffs.payment, tariffs.p_in, tariffs.p_out, tariffs.on_connect, tariffs.on_disconnect, tariffs.pub, configs_route.name as \"route\" from tariffs, configs_route where configs_route.id=tariffs.route");
while ($tariffs[] = $db->sql_fetchrow());
unset($tariffs[count($tariffs)-1]);

$tpl->assign('tariffs',$tariffs);
$tpl->display('tariffs.tpl');
?>
