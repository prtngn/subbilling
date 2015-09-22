{include file='header.tpl'}
<form action="routes.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id_route" value="{$id_route}">
<input type="hidden" name="id_tariff" value="{$id_tariff}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="100">{$lang.routes_route}</td>
	<td><input type="text" name="route" value="{$route}" size="35"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.routes_group}</td>
	<td>
	<select name="id_group">
	{html_options values=$groups.ids selected=$id_group output=$groups.names}
	</select>
	</td>
</tr>
<tr align="left">
	<td colspan="2">
	{if $id_route}
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