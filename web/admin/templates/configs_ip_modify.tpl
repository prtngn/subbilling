{include file='header.tpl'}
<form action="configs_ip.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id_route" value="{$id}">
<input type="hidden" name="old_net" value="{$net}/{$mask}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="100">{$lang.ip_name}</td>
	<td><input type="text" name="ip_zone" value="{$net}/{$mask}" size="25"></td>
</tr>
<tr align="left">
	<td>{$lang.ip_type}</td><td><select name="nat"><option value="1" {if $nat == '1'}selected{/if}>{$lang.users_nat}</option><option value="PPP" {if $nat == '0'}selected{/if}>{$lang.users_ppp}</option></select></td>
</tr>
<tr align="left">
	<td colspan="2">
	{if $id}
	<input type="submit" name="modify" value="{$lang.edit}">
	{else}
	<input type="submit" name="modify" value="{$lang.add}">
	{/if}
	</td>
</tr>
</table>
</form>
{include file='errors.tpl'}
{include file='footer.tpl'}
