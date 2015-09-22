{include file='header.tpl'}
<form name="def" action="tariffs.php" method="post">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if $perms[$curr_menu] eq 2}
	<td class="head" rowspan="2" width="20"><input type="checkbox" onClick="checkAll(this.checked);"></td>
	{/if}
	<td class="head" rowspan="2">{$lang.tariffs_name}</td>
	<td class="head" rowspan="2">{$lang.tariffs_period}</td>
	<td class="head" rowspan="2">{$lang.tariffs_payment}</td>
	<td class="head" colspan="2">{$lang.tariffs_prepaid}</td>
	<td class="head" rowspan="2">{$lang.tariffs_public}</td>
	<td class="head" rowspan="2">{$lang.tariffs_route}</td>
	<td class="head" colspan="2" rowspan="2" width="45">&mdash;</td>
	{if $perms[$curr_menu] eq 2}
	<td class="head" colspan="2" rowspan="2" width="45">&mdash;</td>
	{/if}
</tr>
<tr align="center">
	<td class="head">{$lang.incoming}</td>
	<td class="head">{$lang.outgoing}</td>
</tr>
{section name=tariff loop=$tariffs}
	{if $smarty.section.tariff.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">	
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}" width="20"><input type="checkbox" name="id[]" value={$tariffs[tariff].id_tariff}></td>
	{/if}
	<td class="{$classname}">{$tariffs[tariff].tariff_name|@stripslashes}</td>
	<td class="{$classname}">{$tariffs[tariff].period|sec2days}</td>
	<td class="{$classname}">{$tariffs[tariff].payment}</td>
	<td class="{$classname}">{$tariffs[tariff].p_in|fbytes}</td>
	<td class="{$classname}">{$tariffs[tariff].p_out|fbytes}</td>
	<td class="{$classname}">
	{if $tariffs[tariff].pub}
		{$lang.yes}
	{else}
		{$lang.no}
	{/if}
	</td>
	<td class="{$classname}">{$tariffs[tariff].route}</td>
	<td class="{$classname}"><a href="routes_groups.php?id_tariff={$tariffs[tariff].id_tariff}"><img src="templates/img/zones.png" alt="{$lang.tariffs_routes}" title="{$lang.tariffs_routes}"></a></td>
	<td class="{$classname}"><a href="holidays.php?id_tariff={$tariffs[tariff].id_tariff}"><img src="templates/img/holidays.png" alt="{$lang.tariffs_holidays}" title="{$lang.tariffs_holidays}"></a></td>
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}"><a href="tariffs.php?id_tariff={$tariffs[tariff].id_tariff}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}"><a href="tariffs.php?id[]={$tariffs[tariff].id_tariff}&amp;delselected=1" onclick="return confirmation('{$lang.tariffs_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
	{/if}
</tr>
{/section}
</table>
{if $perms[$curr_menu] eq 2}
<table border="0" width="700"  cellspacing="0" cellpadding="0">
<tr>
	<td align="left"><input type="submit" name="modify" value="{$lang.add}"></td>
	<td align="right"><input type="submit" name="delselected" value="{$lang.del}" onclick="return confirmation('{$lang.tariffs_delconfirm}');"></td>
</tr>
</table>
{/if}
</form>
{include file='footer.tpl'}