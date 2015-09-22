<?php
define('SQL_INC',1);
define('CURR_MENU','tickets');

require 'inc/common.inc.php';

$id_ticket = intval($_POST['id_ticket']) ? intval($_POST['id_ticket']) : intval($_GET['id_ticket']);

$groups = get_admins_groups();
$tpl->assign('groups', $groups);
$tpl->assign('id_ticket', $id_ticket);

if ($_POST['reply'] || $_GET['reply']) {
	if (!$_POST['confirm'] && $id_ticket) {
		$db->sql_query("select id_group, topic from tickets where id='$id_ticket' and id_user='$id_user'");
		$result = $db->sql_fetchrow();
	}
	
	$id_group = $_POST['confirm'] ? intval($_POST['id_group']) : $result['id_group'];
	$topic = $_POST['confirm'] ? addslashes(htmlspecialchars($_POST['topic'])) : ($id_ticket ? 'Re: '.$result['topic'] : '');
	$message = $_POST['confirm'] ? addslashes(htmlspecialchars($_POST['message'])) : '';
	
	$errors = array();
	if (!$topic) {
		$errors[] = $lang['errors_topic_empty'];
	}
	
	if (!$message) {
		$errors[] = $lang['errors_message_empty'];
	}
	
	if (!$id_group) {
		$errors[] = $lang['errors_to_empty'];
	} elseif ($id_ticket && !$db->sql_numrows($db->sql_query("select * from tickets where id='$id_ticket' and id_group='$id_group'"))) {
		$errors[] = $lang['errors_to_incorrect'];
	}	
	
	if ($id_ticket && !$db->sql_numrows($db->sql_query("select * from tickets where id='$id_ticket' and id_user='$id_user'"))) {
		$errors[] = $lang['errors_parent_incorrect'];
	}
	
	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		
		$tpl->assign('topic', $topic);
		$tpl->assign('message', $message);
		$tpl->assign('id_group', $id_group);
		$tpl->display('tickets_reply.tpl');
		exit;
	} elseif($_POST['confirm']) {
		$db->sql_query("insert into tickets (id_parent, id_user, id_group, topic, message, created) values('$id_ticket', '$id_user', '$id_group', '$topic', '$message', '". time() ."')"); 
		header('location: tickets.php');
		exit;
	}

} 

//get_root_id($id_ticket);
$tickets = get_tickets($id_ticket, 0);
$tpl->assign('tickets', $tickets);

$tpl->display('tickets.tpl');

?>