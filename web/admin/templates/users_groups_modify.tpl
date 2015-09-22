{include file='header.tpl'}
<form action="users_groups.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id_group" value="{$id_group}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="100">{$lang.users_groups_name}</td>
	<td><input type="text" name="group_name" value="{$group_name}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.users_groups_description}</td>
	<td><input type="text" name="description" value="{$description}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.users_groups_discount}</td>
	<td><input type="text" name="discount" value="{$discount}" size="5"> %</td>
</tr>
<tr align="left">
	<td width="100">{$lang.users_groups_change_tariff}</td>
	<td><select name="change_tariff"><option value="0" {if !$change_tariff}selected{/if}>{$lang.no}</option><option value="1" {if $change_tariff}selected{/if}>{$lang.yes}</option></select></td>
</tr>
<tr align="left">
	<td width="100">{$lang.users_groups_blocked}</td>
	<td><select name="blocked"><option value="0" {if !$blocked}selected{/if}>{$lang.no}</option><option value="1" {if $blocked}selected{/if}>{$lang.yes}</option></select></td>
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