{include file='header.tpl'}
<form name="def" action="timezones.php" method="post">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if $perms[$curr_submenu] eq 2}
	<td class="head" rowspan="2" width="20"><input type="checkbox" onClick="checkAll(this.checked);"></td>
	{/if}
	<td class="head" rowspan="2">{$lang.timezones_range}</td>
	<td class="head" colspan="2" width="200">{$lang.timezones_cost}</td>
	<td class="head" rowspan="2">{$lang.routes_groups_speed}</td>
	<td class="head" rowspan="2" width="120">{$lang.timezones_prepaid}</td>
	{if $perms[$curr_submenu] eq 2}
	<td class="head" colspan="2" rowspan="2">&mdash;</td>
	{/if}
</tr>
<tr align="center">
	<td class="head">{$lang.incoming}</td>
	<td class="head">{$lang.outgoing}</td>
</tr>
{section name=zone loop=$timezones}
	{if $smarty.section.zone.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">
	{if $perms[$curr_submenu] eq 2}
	<td class="{$classname}" width="20"><input type="checkbox" name="id[]" value={$timezones[zone].id_timer}></td>
	{/if}
	<td class="{$classname}">{$timezones[zone].time_from} &ndash; {$timezones[zone].time_to}</td>
	<td class="{$classname}">{$timezones[zone].cost_in}</td>
	<td class="{$classname}">{$timezones[zone].cost_out}</td>
	<td class="{$classname}">{$timezones[zone].speed}</td>
	<td class="{$classname}">
	{if $timezones[zone].prepaid}
		{$lang.yes}
	{else}
		{$lang.no}
	{/if}
	</td>
	{if $perms[$curr_submenu] eq 2}
	<td class="{$classname}" width="24"><a href="timezones.php?id_timer={$timezones[zone].id_timer}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}" width="24"><a href="timezones.php?id[]={$timezones[zone].id_timer}&amp;delselected=1&amp;id_group={$timezones[zone].id_group}" onclick="return confirmation('{$lang.timezones_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
	{/if}

</tr>
{/section}
</table>
<input type="hidden" name="id_tariff" value="{$id_tariff}">
<table border="0" width="700"  cellspacing="0" cellpadding="0">
<tr>
	<td align="left">{$lang.group_label}: <select name="id_group" onChange="javascript:submit()"> 
	{html_options values=$groups.ids selected=$id_group output=$groups.names}
	</select><noscript> <input type="submit" name="show" value="{$lang.show}"></noscript></td>
	{if $perms[$curr_submenu] eq 2}
	<td align="right">
	<input type="submit" name="modify" value="{$lang.add}">
	<input type="submit" name="delselected" value="{$lang.del}" onclick="return confirmation('{$lang.timezones_delconfirm}');">
	</td>
	{/if}
</tr>
</table>
</form>
{include file='footer.tpl'}