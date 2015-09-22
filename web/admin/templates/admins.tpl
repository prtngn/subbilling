{include file='header.tpl'}
<form name="def" action="admins.php" method="post">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if $perms[$curr_menu] eq 2}
	<td class="head" width="20"><input type="checkbox" onClick="checkAll(this.checked);"></td>
	{/if}
	<td class="head">{$lang.admins_login}</td>
	{if !$id_group}
	<td class="head">{$lang.admins_group}</td>
	{/if}
	<td class="head">{$lang.admins_lastlogin}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="head" colspan="2" width="45">&mdash;</td>
	{/if}
</tr>
{section name=admin loop=$admins}
	{if $smarty.section.admin.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">	
	<td class="{$classname}" width="20"><input type="checkbox" name="id[]" value={$admins[admin].id_admin}></td>
	<td class="{$classname}">{$admins[admin].login}</td>
	{if !$id_group}
	<td class="{$classname}"><a href="admins_groups.php?id_group={$admins[admin].id_group}">{$admins[admin].group_name|@stripslashes}</a></td>
	{/if}
	<td class="{$classname}">{if $admins[admin].last_login}{$admins[admin].last_login|date_format:"%e %b %y, %H:%M"}{else}{$lang.no}{/if}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}"><a href="admins.php?id_admin={$admins[admin].id_admin}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}"><a href="admins.php?id[]={$admins[admin].id_admin}&amp;delselected=1" onclick="return confirmation('{$lang.admins_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
	{/if}
</tr>
{/section}
</table>
<table border="0" width="700"  cellspacing="0" cellpadding="0">
<tr>
	<td align="left">{$lang.group_label}: <select name="id_group" onChange="javascript:submit()"> 
	{html_options values=$groups.ids selected=$id_group output=$groups.names}
	</select><noscript> <input type="submit" name="show" value="{$lang.show}"></noscript></td>
	{if $perms[$curr_menu] eq 2}
	<td align="right">
	<input type="submit" name="modify" value="{$lang.add}">
	<input type="submit" name="delselected" value="{$lang.del}" onclick="return confirmation('{$lang.admins_delconfirm}');">
	{/if}
	</td>
</tr>
</table>
</form>
{include file='footer.tpl'}
