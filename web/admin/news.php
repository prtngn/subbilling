<?php
define('SQL_INC',1);
define('CURR_MENU','news');
require 'inc/common.inc.php';
check_permissions(CURR_MENU,1);

$id_news = intval($_POST['id_news']) ? intval($_POST['id_news']) : intval($_GET['id_news']);

$tpl->assign('id_news', $id_news);

if ($id_news) {
	$query_res = $db->sql_query("select * from news where id='$id_news'");
	$news = array();
	while ($news[] = $db->sql_fetchrow());
	unset($news[count($news)-1]);
} else {
	$query_res = $db->sql_query("select * from news ORDER BY time DESC");
	$news = array();
	while ($news[] = $db->sql_fetchrow());
	unset($news[count($news)-1]);
}

if (($_POST['edit'] || $_GET['edit']) && $id_news) {
	if ($_POST['delselected'] == 1 || $_GET['delselected'] == 1) {
		$db->sql_query("delete from news where id='$id_news'");
		header("location: news.php");
		exit;
	}
	$reply_text = $_POST['confirm'] ? addslashes(htmlspecialchars($_POST['text'])) : '';

	$errors = array();
	if (!$reply_text) {
		$errors[] = $lang['errors_news_empty'];
	}

	if (!$db->sql_numrows($db->sql_query("select * from news where id='$id_news'"))) {
		$errors[] = $lang['errors_ticket_incorrect'];
	}
	
	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		$tpl->assign('news', $news);
		$tpl->display('news_edit.tpl');
		exit;
	} elseif($_POST['confirm']) {
		$reply_text = str_replace("\n", "<br>", $reply_text);
		$db->sql_query("update news set text='$reply_text', time='". time() ."' where id='$id_news'"); 
		header("location: news.php");
		exit;
	}

}

if ($_POST['new'] || $_GET['new']) {

	$news_text = $_POST['confirm'] ? addslashes(htmlspecialchars($_POST['news_text'])) : '';

	$errors = array();
	if (!$news_text) {
		$errors[] = $lang['errors_news_empty'];
	}
	
	if (count($errors) || !$_POST['confirm']) {
		if ($_POST['confirm']) {
			$tpl->assign('errors',$errors);
		}
		$tpl->display('news_add.tpl');
		exit;
	} elseif($_POST['confirm']) {
		$news_text = str_replace("\n", "<br>", $news_text);
		$db->sql_query("insert into news (time, text) values ('". time() ."', '$news_text')"); 
		header("location: news.php");
		exit;
	}

}

if ($_POST['delselected'] || $_GET['delselected']) {
	if (!$db->sql_numrows($db->sql_query("select * from news where id='$id_news'"))) {
		$errors[] = $lang['errors_ticket_incorrect'];
	}

	if (count($errors)) {
		$tpl->assign('errors',$errors);
		$tpl->display('news.tpl');
		exit;
	} else {
		$db->sql_query("delete from news where id='$id_news'");
		header("location: news.php");
		exit;
	}

}

$tpl->assign('news', $news);
$tpl->display('news.tpl');

?>