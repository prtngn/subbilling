{include file='header.tpl'}
<form action="machines_groups.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id_group" value="{$id_group}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="100">{$lang.machines_groups_name}</td>
	<td><input type="text" name="group_name" value="{$group_name}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.machines_groups_description}</td>
	<td><input type="text" name="description" value="{$description}" size="25"></td>
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
