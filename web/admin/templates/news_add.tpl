{include file='header.tpl'}
<form action="news.php" method="post">
<input type="hidden" name="confirm" value="1">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="130">{$lang.news_text}</td>
	<td><textarea name="news_text" cols="50" rows="10"></textarea></td>
</tr>
</table>
<input type="submit" name="new" value="{$lang.news_add}"></form>
</form>
{include file='errors.tpl'}
{include file='footer.tpl'}