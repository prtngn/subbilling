{include file='header.tpl'}
<form action="admins_groups.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id_group" value="{$id_group}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="130">{$lang.admins_groups_name}</td>
	<td><input type="text" name="group_name" value="{$group_name}" size="25"></td>
</tr>
<tr align="left">
	<td width="130">{$lang.admins_groups_description}</td>
	<td><input type="text" name="description" value="{$description}" size="25"></td>
</tr>
<tr align="left">
	<td width="130">{$lang.admins_groups_defpage}</td>
	<td><select name='def_page'>
	{foreach key=page_name item=page from=$menu}
		<option value='{$page_name}' {if $def_page==$page_name}selected{/if}>{$lang.$page_name}</option>
	{/foreach}
	</select></td>
</tr>
</table>
<br><h2>{$lang.permissions}</h2>
<table border="0" width="700"  cellspacing="4" cellpadding="0">

{foreach key=perm_name item=perm_value from=$perm}
<tr align="left">
	{assign var=lang_perm_name value=perm_$perm_name}
	<td width="150">{$lang.$lang_perm_name}</td>
	<td><select name='{$lang_perm_name}'>
	{foreach key=id_perm item=value_perm from=$lang.perms}
		<option value='{$id_perm}' {if $perm_value eq $id_perm}selected{/if}>{$value_perm}</option>
	{/foreach}
	</select></td>
</tr>
{/foreach}

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