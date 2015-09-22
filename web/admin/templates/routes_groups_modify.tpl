{include file='header.tpl'}
<form action="routes_groups.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id_group" value="{$id_group}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="100">{$lang.routes_groups_name}</td>
	<td><input type="text" name="group_name" value="{$group_name}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.routes_groups_tariff}</td>
	<td>
	<select name="id_tariff">
	{html_options values=$tariffs.ids selected=$id_tariff output=$tariffs.names}
	</select>
	</td>
</tr>
<tr align="left">
	<td width="100">{$lang.routes_groups_prio}</td>
	<td valign="center"><input type="text" name="prio" value="{$prio}" size="5">
	{if !$id_group} <input type="checkbox" name="autoprio" checked> {$lang.routes_groups_autoprio}{/if}
	</td>
</tr>
<tr align="left">
	<td colspan="2">
	{if $id_group}
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