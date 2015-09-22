{include file='header.tpl'}
<form action="tickets.php" method="post">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<input type="hidden" name="confirm" value="1">
{if not $id_ticket}
<tr align="left">
	<td width="30">{$lang.tickets_to}</td>
	<td><select name="id_group">
	{html_options values=$groups.ids selected=$id_group output=$groups.names}
	</select></td>
</tr>
{else}
<input type="hidden" name="id_group" value="{$id_group}">
<input type="hidden" name="id_ticket" value="{$id_ticket}">
{/if}
<tr align="left">
	<td width="30">{$lang.tickets_topic}</td>
	<td><input type="text" name="topic" value="{$topic|@stripslashes}" size="65"></td>
</tr>
<tr align="left">
	<td colspan="2">{$lang.tickets_message}<br>
	<textarea name="message" cols="70" rows="7">{$message|@stripslashes}</textarea></td>
</tr>
<tr align="left">
	<td colspan="2"><input type="submit" name="reply" value="{$lang.tickets_send}"></td>
</tr>
</table>
</form>
{include file='errors.tpl'}
{include file='footer.tpl'}