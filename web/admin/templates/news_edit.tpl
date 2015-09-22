{include file='header.tpl'}
<form action="news.php" method="post">
<input type="hidden" name="id_news" value="{$id_news}">
<input type="hidden" name="confirm" value="1">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
{foreach item=news from=$news}
<tr align="left">
	<td width="130">{$lang.news_text}</td>
		<td><textarea name="text" cols="50" rows="10">{$news.text}</textarea></td>
</tr>
{/foreach}
</table>
<input type="submit" name="edit" value="{$lang.news_save}"></form>
</form>
{include file='errors.tpl'}
{include file='footer.tpl'}