<?php
	$menu = array(
		'index' => array('url' => 'index.php', 'title' => $lang['index']),
		'reports' => array(
				'url' => 'reports.php','title' => $lang['reports'],
				'sub' => array(
							'stats' => array('url' => 'stats.php','title' => $lang['stats']),
							'payments' => array('url' => 'payments.php','title' => $lang['payments']),
							'connections' => array('url' => 'connections.php','title' => $lang['connections']),
						),
				),
		'detailed' => array('url' => 'detailed.php','title' => $lang['detailed']),
		'paycard' => array('url' => 'paycard.php','title' => $lang['paycard']),
//		'wm' => array('url' => 'wm.php','title' => $lang['wm']),
		'settings' => array(
				'url' => 'settings.php','title' => $lang['settings'],
				'sub' => array(
							'addresses' => array('url' => 'addresses.php','title' => $lang['addresses']),
							'tariff' => array('url' => 'tariff.php','title' => $lang['tariff']),
							'password' => array('url' => 'password.php','title' => $lang['password']),
						),
				),
		'tickets' => array('url' => 'tickets.php','title' => $lang['tickets']),
	);

	$tpl->assign('login',$login);
	$tpl->assign('menu',$menu);
	$tpl->assign('curr_menu',CURR_MENU);
	if(defined('CURR_SUBMENU'))$tpl->assign('curr_submenu',CURR_SUBMENU); 
?>
