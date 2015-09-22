{include file='header.tpl'}
<form action="configs_route.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id" value="{$id}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="100">{$lang.route_name}</td>
	<td><input type="text" name="name" value="{$name}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.route_ip}</td>
	<td><input type="text" name="ip" value="{$ip}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.route_dev}</td>
	<td><input type="text" name="dev" value="{$dev}" size="25"></td>
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
