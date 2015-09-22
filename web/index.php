<?php
define('SQL_INC',1);
define('CURR_MENU','index');

require 'inc/common.inc.php';

$db->sql_query("select users.id, users.login, users.id_account, users.id_tariff, inet_ntoa(users.addr) as \"addr\", users_accounts.deposit, 
					   users_accounts.max_credit, users.p_in, users.p_out, users.registered, users.last_login, users.last_connect, users.last_period, 
					   users.security, users_groups.group_name, users_groups.discount, users_groups.blocked, users_groups.change_tariff,
					   users_accounts.name, users_accounts.lastname, users_accounts.surname, users_accounts.address, users_accounts.phone, tariffs.tariff_name
				from users, users_groups, users_accounts, tariffs
				where users.id_account=users_accounts.id and users.id_tariff=tariffs.id and users_accounts.id_group=users_groups.id and users.id='$id_user'");
$user = $db->sql_fetchrow();

$query_res = $db->sql_query("select * from news ORDER BY time DESC LIMIT 5");
$news = array();
while ($news[] = $db->sql_fetchrow());
unset($news[count($news)-1]);
$tpl->assign('news',$news);
$tpl->assign('user', $user);
$tpl->assign('news_page','1');
$tpl->display('index.tpl');
?>