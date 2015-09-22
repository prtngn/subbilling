{include file='header.tpl'}
<form name="def" action="routes_groups.php" method="post">
<input type="hidden" name="id_tariff" value="{$id_tariff}">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if $perms[$curr_submenu] eq 2}
	<td class="head"><input type="checkbox" onClick="checkAll(this.checked);"></td>
	{/if}
	<td class="head">{$lang.routes_groups_name}</td>
	{if !$id_tariff}
	<td class="head">{$lang.routes_groups_tariff}</td>
	{/if}
	<td class="head">{$lang.routes_groups_prio}</td>
	<td class="head" colspan="2" width="45">&mdash;</td>
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
	{if !$id_tariff}
	<td class="{$classname}"><a href="tariffs.php?id_tariff={$groups[group].id_tariff}">{$groups[group].tariff_name|@stripslashes}</a></td>
	{/if}
	<td class="{$classname}">{$groups[group].prio}</td>
	<td class="{$classname}"><a href="routes.php?id_tariff={$groups[group].id_tariff}&amp;id_group={$groups[group].id_group}"><img src="templates/img/routes.png" alt="{$lang.routes_groups_routes}" title="{$lang.routes_groups_routes}"></a></td>
	<td class="{$classname}"><a href="timezones.php?id_tariff={$groups[group].id_tariff}&amp;id_group={$groups[group].id_group}"><img src="templates/img/timers.png" alt="{$lang.routes_groups_timezones}" title="{$lang.routes_groups_timezones}"></a></td>
	{if $perms[$curr_submenu] eq 2}
	<td class="{$classname}"><a href="routes_groups.php?id_group={$groups[group].id_group}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}"><a href="routes_groups.php?id[]={$groups[group].id_group}&amp;delselected=1&amp;id_tariff={$id_tariff}" onclick="return confirmation('{$lang.routes_groups_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
	{/if}
</tr>
{/section}
</table>
<table border="0" width="700"  cellspacing="0" cellpadding="0">
<tr>
	<td align="left">{$lang.tariff_label}: <select name="id_tariff" onChange="javascript:submit()"> 
	{html_options values=$tariffs.ids selected=$id_tariff output=$tariffs.names}
	</select><noscript> <input type="submit" name="show" value="{$lang.show}"></noscript></td>
	{if $perms[$curr_submenu] eq 2}
	<td align="right">
	<input type="submit" name="modify" value="{$lang.add}">
	<input type="submit" name="delselected" value="{$lang.del}" onclick="return confirmation('{$lang.routes_groups_delconfirm}');">
	</td>
	{/if}
</tr>
</table>
</form>
{include file='footer.tpl'}