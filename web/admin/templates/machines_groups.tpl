{include file='header.tpl'}
<form name="def" action="machines_groups.php" method="post">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if $perms[$curr_submenu] eq 2}
	<td class="head" width="20"><input type="checkbox" onClick="checkAll(this.checked);"></td>
	{/if}
	<td class="head">{$lang.machines_groups_name}</td>
	<td class="head">{$lang.machines_groups_description}</td>
	<td class="head" width="22">&mdash;</td>
	{if $perms[$curr_submenu] eq 2}
	<td class="head" colspan="2" width="45">&mdash;</td>
	{/if}
</tr>
{section name=group loop=$groups}
	{if $smarty.section.group.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">	
	{if $perms[$curr_submenu] eq 2}
	<td class="{$classname}" width="20"><input type="checkbox" name="id[]" value={$groups[group].id_group}></td>
	{/if}
	<td class="{$classname}">{$groups[group].group_name|@stripslashes}</td>
	<td class="{$classname}">{$groups[group].description}</td>
	<td class="{$classname}"><a href="machines.php?id_group={$groups[group].id_group}"><img src="templates/img/users.png" alt="{$lang.machines_groups_users}" title="{$lang.machines_groups_users}"></a></td>
	{if $perms[$curr_submenu] eq 2}
	<td class="{$classname}"><a href="machines_groups.php?id_group={$groups[group].id_group}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}"><a href="machines_groups.php?id[]={$groups[group].id_group}&amp;delselected=1" onclick="return confirmation('{$lang.machines_groups_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
	{/if}
</tr>
{/section}
</table>
{if $perms[$curr_submenu] eq 2}
<table border="0" width="700"  cellspacing="0" cellpadding="0">
<tr>
	<td align="left"><input type="submit" name="modify" value="{$lang.add}"></td>
	<td align="right"><input type="submit" name="delselected" value="{$lang.del}" onclick="return confirmation('{$lang.machines_groups_delconfirm}');"></td>
</tr>
</table>
{/if}
</form>
{include file='footer.tpl'}
