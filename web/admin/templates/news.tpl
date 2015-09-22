{if $id_news}
	{include file="news_edit.tpl" news="`$news`"}
{else}
	{if $news|count}
		{include file="news_tree.tpl" news="`$news`"}
	{else}
		{include file='header.tpl'}
		{$lang.news_empty}
		<form action="news.php" method="post"><input type="submit" name="new" value="{$lang.news_add}"></form>
		{include file='footer.tpl'}
	{/if}
{/if}
