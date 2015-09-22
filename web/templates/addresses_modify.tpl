{include file='header.tpl'}
<form action="addresses.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id_addr" value="{$id_addr}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="80">{$lang.addresses_addr}</td>
	<td><input type="text" name="addr" value="{$addr}" size="25"></td>
</tr>
<tr align="left">
	<td colspan="2">
	{if $id_addr}
	<input type="submit" value="{$lang.edit}">
	{else}
	<input type="submit" value="{$lang.add}">
	{/if}
	</td>
</tr>
</table>
</form>
{include file='errors.tpl'}
{include file='footer.tpl'}