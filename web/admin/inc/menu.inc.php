<?php
	$menu = array(
		'sessions' => array('url' => 'sessions.php','title' => $lang['sessions']),
		'users_accounts' => array(
				'url' => 'accounts.php','title' => $lang['users_accounts'],
				'sub' => array(
							'users' => array('url' => 'users.php','title' => $lang['users']),
							'users_groups' => array('url' => 'users_groups.php','title' => $lang['users_groups']),
						),
				),
//		'machines' => array(
//                                'url' => 'machines.php','title' => $lang['machines'],
//                                'sub' => array(
//                                                       'machines_groups' => array('url' => 'machines_groups.php','title' => $lang['machines_groups']),
//						),
//				),
		'tariffs' => array(
				'url' => 'tariffs.php','title' => $lang['tariffs'],
				'sub' => array(
							'tariffs_routes' => array('url' => 'routes_groups.php', 'title' => $lang['tariffs_routes']),
							'tariffs_holidays' => array('url' => 'holidays.php', 'title' => $lang['tariffs_holidays']),
						),
				),
		'payments' => array('url' => 'payments.php','title' => $lang['payments']),
		'connections' => array('url' => 'connections.php','title' => $lang['connections']),
		'stats' => array(
				'url' => 'stats.php','title' => $lang['stats'],
				'sub' => array (
							'stats_detailed' => array('url' => 'detailed.php','title' => $lang['stats_detailed']),
						),
				),
		'cards' => array(
				'url' => 'cards.php','title' => $lang['cards'],
				'sub' => array(
							'cards_gen' => array('url' => 'cards_gen.php','title' => $lang['cards_gen']),
							'cards_act' => array('url' => 'cards_act.php','title' => $lang['cards_act']),
						),
				),
		'money' => array('url' => 'money.php','title' => $lang['money']),
		'news' => array('url' => 'news.php','title' => $lang['news']),
		'tickets' => array(
				'url' => 'tickets.php','title' => $lang['tickets'],
				'sub' => array(
							'tickets_cats' => array('url' => 'tickets_cats.php', 'title' => $lang["tickets_cats"]),
						),
				),
		'configs' => array(
				'url' => 'configs.php','title' => $lang['configs'],
				'sub' => array(
							'configs_ppp' => array('url' => 'configs_ppp.php', 'title' => $lang["configs_ppp"]),
							'configs_route' => array('url' => 'configs_route.php', 'title' => $lang["configs_route"]),
							'configs_ip' => array('url' => 'configs_ip.php','title' => $lang['configs_ip']),
							'configs_dhcpd' => array('url' => 'configs_dhcpd.php','title' => $lang['configs_dhcpd']),
//							'configs_block_ip' => array('url' => 'configs_block_ip.php','title' => $lang['configs_block_ip']),
//							'configs_block_mac' => array('url' => 'configs_block_mac.php','title' => $lang['configs_block_mac']),
						),
				),
		'admins' => array(
				'url' => 'admins.php','title' => $lang['admins'],
				'sub' => array(
							'admins_groups' => array('url' => 'admins_groups.php','title' => $lang['admins_groups']),
						),
				),
	);

	$tpl->assign('login',$login);
	$tpl->assign('menu',$menu);
	$tpl->assign('curr_menu',CURR_MENU);
	if(defined('CURR_SUBMENU'))$tpl->assign('curr_submenu',CURR_SUBMENU); 
?>
