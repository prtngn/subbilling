<?php
define('SQL_INC',1);
define('CURR_MENU','tickets');
require 'inc/common.inc.php';
check_permissions(CURR_MENU,1);

$id_ticket = intval($_POST['id_ticket']) ? intval($_POST['id_ticket']) : intval($_GET['id_ticket']);

$tpl->assign('id_ticket', $id_ticket);

if (($_POST['reply'] || $_GET['reply']) && $id_ticket) {
	check_permissions(CURR_MENU,2);
	
	$reply_text = $_POST['confirm'] ? addslashes(htmlspecialchars($_POST['reply_text'])) : '';

	$errors = array();
	if (!$reply_text) {
		$errors[] = $lang['errors_reply_empty'];
	}
	
	if (!$db->sql_numrows($db->sql_query("select * from tickets where id='$id_ticket' and id_group='$my_group'"))) {
		$errors[] = $lang['errors_ticket_incorrect'];
	}
	
	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		
		$tpl->display('tickets_reply.tpl');
		exit;
	} elseif($_POST['confirm']) {
		$db->sql_query("update tickets set reply='$reply_text', answered='". time() ."' where id='$id_ticket'"); 
		header("location: tickets.php?id_ticket=$id_ticket");
		exit;
	}

} 

//get_root_id($id_ticket);
$tickets = get_tickets($id_ticket, 0);
$tpl->assign('tickets', $tickets);

$tpl->display('tickets.tpl');

?>