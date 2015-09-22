{include file='header.tpl'}
<form action="cards_act.php" method="post">
<input type="hidden" name="id_card" value="{$id_card}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="80">{$lang.cards_user}</td>
	<td><select name="id_user">
	{html_options values=$users.ids output=$users.names}
	</select></td>
</tr>
<tr align="left">
	<td colspan="2"><input type="submit" name="activate" value="{$lang.cards_activate}"></td>
</tr>
</table>
</form>
{include file='errors.tpl'}
{include file='footer.tpl'}