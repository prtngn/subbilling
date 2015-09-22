{include file='header.tpl'}
<form action="tickets.php" method="post">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id_ticket" value="{$id_ticket}">
<tr align="left">
	<td colspan="2">{$lang.tickets_reply}<br>
	<textarea name="reply_text" cols="70" rows="7"></textarea></td>
</tr>
<tr align="left">
	<td colspan="2"><input type="submit" name="reply" value="{$lang.tickets_send}"></td>
</tr>
</table>
</form>
{include file='errors.tpl'}
{include file='footer.tpl'}