<?php
/*
function get_users($add_all = false, $id_tariff = NULL, $id_group = NULL) {
	global $lang, $db;
	$users = array();
	if ($add_all) {
		$users['ids'][] = 0;
		$users['names'][] = $lang['all'];
	}
	
	$sql_where = intval($id_tariff) ? "and id_tariff='$id_tariff'" : '';
	$sql_where .= intval($id_group) ? " and id_group='$id_group'" : '';
	$list_res = $db->sql_query("select id, login from users where 1 $sql_where order by login");
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
	$list_res = $db->sql_query("select id, group_name from users_groups $sql_where");
	while (list($id_group,$group_name) = $db->sql_fetchrow($list_res)) {
		$groups['ids'][] = $id_group;
		$groups['names'][] = stripslashes($group_name);
	}

	return $groups;
}
*/
function get_admins_groups($add_all = false) {
	global $lang, $db;
	$groups = array();
	if ($add_all) {
		$groups['ids'][] = 0;
		$groups['names'][] = $lang['all'];
	}
	
	$list_res = $db->sql_query("select id, group_name from admins_groups");
	while (list($id_group,$group_name) = $db->sql_fetchrow($list_res)) {
		$groups['ids'][] = $id_group;
		$groups['names'][] = stripslashes($group_name);
	}

	return $groups;
}

function get_routes_groups($add_all = false) {
	global $id_user, $lang, $db;
	$groups = array();
	if ($add_all) {
		$groups['ids'][] = 0;
		$groups['names'][] = $lang['all'];
	}
	$list_res = $db->sql_query("select distinct(data.id_group), routes_groups.group_name from data inner join routes_groups on data.id_group=routes_groups.id where data.id_user='$id_user' order by data.id_group");
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
	
	$list_res = $db->sql_query("select id, tariff_name from tariffs");
	while (list($id_tariff,$tariff_name) = $db->sql_fetchrow($list_res)) {
		$tariffs['ids'][] = $id_tariff;
		$tariffs['names'][] = stripslashes($tariff_name);
	}

	return $tariffs;
}

function get_tickets($id_ticket, $id_parent) {
	global $db, $id_user;
	
	$tickets = array(); $i=0;
	if ($id_ticket) {
		$sql_where = "and tickets.id='$id_ticket'";
	} else {
		$sql_where = "and tickets.id_parent='$id_parent'";
	}
	$list_res = $db->sql_query("select tickets.*, admins_groups.group_name, users_accounts.name, users_accounts.lastname, users_accounts.surname from tickets, admins_groups, users, users_accounts where tickets.id_group=admins_groups.id and tickets.id_user=users.id and tickets.id_user='$id_user' and users_accounts.id=users.id_account $sql_where order by tickets.created, tickets.answered desc");
	while ($tickets[$i] = $db->sql_fetchrow($list_res)) {
		$tickets[$i]['sub'] = get_tickets(0, $tickets[$i]['id']);
		$i++;
	}
	unset($tickets[count($tickets)-1]);
	return $tickets;
}

/*
function get_parent_id($id_ticket) {
	global $db, $id_user;
	$ticket_res = $db->sql_query("select id_parent from tickets where id_user='$id_user' and id='$id_ticket'");
	list($id_parent) = $db->sql_fetchrow($ticket_res);
	return($id_parent);
}
	
function get_root_id(&$id_ticket) {
	$id_parent = get_parent_id($id_ticket);
	if ($id_parent) {
		$id_ticket = $id_parent;
		get_root_id($id_ticket);
	}
}
*/