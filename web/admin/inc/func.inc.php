<?php

function get_users($add_all = false, $id_tariff = NULL, $id_group = NULL) {
	global $lang, $db;
	$users = array();
	if ($add_all) {
		$users['ids'][] = 0;
		$users['names'][] = $lang['all'];
	}
	
	$sql_where = intval($id_tariff) ? "and id_tariff='$id_tariff'" : '';
	$sql_where .= intval($id_group) ? " and id_group='$id_group'" : '';
	$list_res = $db->sql_query("select id, login from users where true $sql_where order by login");
	while (list($id_user, $user_name) = $db->sql_fetchrow($list_res)) {
		$users['ids'][] = $id_user;
		$users['names'][] = $user_name;
	}
	return $users;
}

function get_users_groups($add_all = false, $id_tariff = NULL) {
	global $lang, $db;
	$groups = array();
	if ($add_all) {
		$groups['ids'][] = 0;
		$groups['names'][] = $lang['all'];
	}
	
	$sql_where = intval($id_tariff) ? "where id_tariff='$id_tariff'" : '';
	$list_res = $db->sql_query("select id, group_name from users_groups $sql_where order by id");
	while (list($id_group,$group_name) = $db->sql_fetchrow($list_res)) {
		$groups['ids'][] = $id_group;
		$groups['names'][] = stripslashes($group_name);
	}

	return $groups;
}

function get_machines($add_all = false, $id_user = NULL, $id_group = NULL) {
        global $lang, $db;
        $machines = array();
        if ($add_all) {
                $machines['ids'][] = 0;
                $machines['names'][] = $lang['all'];
        }

	$sql_where = intval($id_user) ? " and id_user='$id_user'" : '';
        $sql_where .= intval($id_group) ? " and id_group='$id_group'" : '';
        $list_res = $db->sql_query("select id, name from machines where true $sql_where order by name");
        while (list($id_machine, $machine_name) = $db->sql_fetchrow($list_res)) {
                $machines['ids'][] = $id_machine;
                $machines['names'][] = $machine_name;
        }
        return $machines;
}

function get_machines_groups($add_all = false) {
        global $lang, $db;
        $groups = array();
        if ($add_all) {
                $groups['ids'][] = 0;
                $groups['names'][] = $lang['all'];
        }

        $list_res = $db->sql_query("select id, group_name from machines_groups order by id");
        while (list($id_group,$group_name) = $db->sql_fetchrow($list_res)) {
                $groups['ids'][] = $id_group;
                $groups['names'][] = stripslashes($group_name);
        }

        return $groups;
}

function get_users_accounts($add_all = false) {
        global $lang, $db;
        $accounts = array();
        if ($add_all) {
                $accounts['ids'][] = 0;
                $accounts['names'][] = $lang['all'];
        }

        $list_res = $db->sql_query("select id, name, lastname from users_accounts order by id");
        while (list($id_account, $name, $lastname) = $db->sql_fetchrow($list_res)) {
                $accounts['ids'][] = $id_account;
                $accounts['names'][] = $lastname." ".$name;
        }

        return $accounts;
}

function get_admins_groups($add_all = false) {
	global $lang, $db;
	$groups = array();
	if ($add_all) {
		$groups['ids'][] = 0;
		$groups['names'][] = $lang['all'];
	}
	
	$list_res = $db->sql_query("select id, group_name from admins_groups order by id");
	while (list($id_group,$group_name) = $db->sql_fetchrow($list_res)) {
		$groups['ids'][] = $id_group;
		$groups['names'][] = stripslashes($group_name);
	}

	return $groups;
}

function get_routes_groups($add_all = false, $id_tariff = NULL) {
	global $lang, $db;
	$groups = array();
	if ($add_all) {
		$groups['ids'][] = 0;
		$groups['names'][] = $lang['all'];
	}
	$sql_where = intval($id_tariff) ? "where id_tariff='$id_tariff'" : '';
	$list_res = $db->sql_query("select id, group_name from routes_groups $sql_where order by id");
	while (list($id_group,$group_name) = $db->sql_fetchrow($list_res)) {
		$groups['ids'][] = $id_group;
		$groups['names'][] = stripslashes($group_name);
	}

	return $groups;
}

function get_tariffs($add_all = false) {
	global $lang, $db;
	$tariffs = array();
	if ($add_all) {
		$tariffs['ids'][] = 0;
		$tariffs['names'][] = $lang['all'];
	}
	
	$list_res = $db->sql_query("select id, tariff_name from tariffs order by id");
	while (list($id_tariff,$tariff_name) = $db->sql_fetchrow($list_res)) {
		$tariffs['ids'][] = $id_tariff;
		$tariffs['names'][] = stripslashes($tariff_name);
	}

	return $tariffs;
}

function get_route($add_all = true) {
        global $lang, $db;
        $route = array();
        if ($add_all) {
                $route['ids'][] = 0;
                $route['names'][] = $lang['all'];
        }

        $list_res = $db->sql_query("select id, name from configs_ppp order by id");
        while (list($id_route,$route_name) = $db->sql_fetchrow($list_res)) {
                $route['ids'][] = $id_route;
                $route['names'][] = stripslashes($route_name);
        }

        return $route;
}


function get_networks() {
	global $lang, $db;
	$networks = array();
	
	$list_res = $db->sql_query("select id, inet_ntoa(net) as \"net\", mask from configs_ip where nat='1' order by id");
	while (list($id_net, $net, $net_mask) = $db->sql_fetchrow($list_res)) {
		$networks['id'][] = $id_net;
		$networks['net'][] = $net;
		$networks['mask'][] = $net_mask;
	}

	return $networks;
}

function get_ips_from_net($id_user) {
	global $lang, $db;
	$addrs = array();

	if ($id_user != "new") {
		$list = $db->sql_query("select addr from users where id!='$id_user'");
		while (list($addr) = $db->sql_fetchrow($list)) {
			$adres[] = long2ip($addr);
		}
	}

	if ($id_user == "new") {
		$list = $db->sql_query("select addr from users");
                while (list($addr) = $db->sql_fetchrow($list)) {
                        $adres[] = long2ip($addr);
			$tttt = "ok";
                }
		if ($tttt != "ok") {
			$adres[0] = 0;
		}
	}

	$list_res = $db->sql_query("select net, mask from configs_ip where nat='0' order by id");
	$t = $db->sql_numrows($list_res);
	if ($t > 0) {
	        while (list($net, $mask) = $db->sql_fetchrow($list_res)) {
			$hosts = ~((1 << (32 - $mask)) - 1);
			$first_ip = $net + 2;
			$last_ip = $net + 1;
			$hosts = $hosts * (-1) - 4;
			for ($i = 0; $i <= $hosts; $i++) {
				$last_ip=$last_ip + 1;
				$temp = long2ip($last_ip);
				$octs = explode('.', $temp);
				if ($octs[3] != 0 and $octs[3] != 255) {
					$addrs['addr'][] = long2ip($last_ip);
				}
			}
		}
		$result['addr'] = array_diff($addrs['addr'], $adres);
		return $result;
	} else {
		return 0;
	}
}

function get_ips2_from_net($id_user) {
        global $lang, $db;
        $addrs = array();

        if ($id_user != "new") {
                $list = $db->sql_query("select eth_ip from users where id!='$id_user'");
                while (list($addr) = $db->sql_fetchrow($list)) {
                        $adres[] = long2ip($addr);
                }
        }

        if ($id_user == "new") {
                $list = $db->sql_query("select eth_ip from users");
                while (list($addr) = $db->sql_fetchrow($list)) {
                        $adres[] = long2ip($addr);
                        $tttt = "ok";
                }
                if ($tttt != "ok") {
                        $adres[0] = 0;
                }
        }

        $list_res = $db->sql_query("select net, mask from configs_ip where nat='1' order by id");
	$t = $db->sql_numrows($list_res);
	if ($t > 0) {
	        while (list($net, $mask) = $db->sql_fetchrow($list_res)) {
                	$hosts = ~((1 << (32 - $mask)) - 1);
        	        $first_ip = $net + 2;
	                $last_ip = $net + 1;
        	        $hosts = $hosts * (-1) - 4;
                	for ($i = 0; $i <= $hosts; $i++) {
                        	$last_ip=$last_ip + 1;
				$temp = long2ip($last_ip);
				$octs = explode('.', $temp);
				if ($octs[3] != 0 and $octs[3] != 255) {
					$addrs['addr'][] = long2ip($last_ip);
				}
        	        }
	        }
		$result['addr'] = array_diff($addrs['addr'], $adres);
		return $result;
	} else {
		return 0;
	}
}

function get_first_and_last_ip ($net, $mask) {
	global $lang, $db;
        $hosts = ~((1 << (32 - $mask)) - 1);
	$ips['first'] = $net + 2;
	$hosts = $hosts * (-1) - 4;
	$ips['last'] = $hosts + $net + 2;
	return $ips;
}

function check_permissions($page, $req_lvl) {
	global $perms, $tpl;
	if ($perms[$page] < $req_lvl) {
		$tpl->display('denied.tpl');
		exit;
	}
}

function get_tickets($id_ticket, $id_parent) {
	global $db, $my_group;
	
	$tickets = array(); $i=0;
	if ($id_ticket) {
		$sql_where = "and tickets.id='$id_ticket'";
	} else {
		$sql_where = "and tickets.id_parent='$id_parent'";
	}
	$list_res = $db->sql_query("select tickets.*, users_accounts.name from tickets, users_accounts, users where tickets.id_user=users.id and users.id_account = users_accounts.id and tickets.id_group='$my_group' $sql_where order by tickets.created, tickets.answered desc");
	while ($tickets[$i] = $db->sql_fetchrow($list_res)) {
		$tickets[$i]['sub'] = get_tickets(0, $tickets[$i]['id']);
		$i++;
	}
	unset($tickets[count($tickets)-1]);
	return $tickets;
}
