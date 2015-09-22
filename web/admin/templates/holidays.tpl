{include file='header.tpl'}
<form name="def" action="holidays.php" method="post">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if $perms[$curr_submenu] eq 2}
	<td class="head" rowspan="2" width="20"><input type="checkbox" onClick="checkAll(this.checked);"></td>
	{/if}
	<td class="head" rowspan="2">{$lang.holidays_day}</td>
{if !$id_tariff}
	<td class="head" rowspan="2">{$lang.holidays_tariff}</td>
{/if}
	<td class="head" colspan="2">{$lang.holidays_discount}</td>
	<td class="head" rowspan="2">{$lang.holidays_description}</td>
	{if $perms[$curr_submenu] eq 2}
	<td class="head" colspan="2" rowspan="2" width="45">&mdash;</td>
	{/if}
</tr>
<tr align="center">
	<td class="head">{$lang.incoming}</td>
	<td class="head">{$lang.outgoing}</td>
</tr>
{section name=holiday loop=$holidays}
	{if $smarty.section.holiday.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">	
	{if $perms[$curr_submenu] eq 2}
	<td class="{$classname}" width="20"><input type="checkbox" name="id[]" value={$holidays[holiday].id_holiday}></td>
	{/if}
	<td class="{$classname}">{$holidays[holiday].day}</td>
{if !$id_tariff}
	<td class="{$classname}"><a href="tariffs.php?id_tariff={$holidays[holiday].id_tariff}">{$holidays[holiday].tariff_name|@stripslashes}</a></td>
{/if}
	<td class="{$classname}">{$holidays[holiday].discount_in}</td>
	<td class="{$classname}">{$holidays[holiday].discount_out}</td>
	<td class="{$classname}">{$holidays[holiday].description}</td>
	{if $perms[$curr_submenu] eq 2}
	<td class="{$classname}"><a href="holidays.php?id_holiday={$holidays[holiday].id_holiday}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}"><a href="holidays.php?id[]={$holidays[holiday].id_holiday}&amp;delselected=1&amp;id_tariff={$id_tariff}" onclick="return confirmation('{$lang.holidays_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
	{/if}

</tr>
{/section}
</table>
<table border="0" width="700"  cellspacing="0" cellpadding="0">
<tr>
	<td align="left">
	{$lang.tariff_label}: <select name="id_tariff" onChange="javascript:submit()"> 
	{html_options values=$tariffs.ids selected=$id_tariff output=$tariffs.names}
	</select><noscript> <input type="submit" name="show" value="{$lang.show}"></noscript></td>
	{if $perms[$curr_menu] eq 2}
	<td align="right">
	<input type="submit" name="modify" value="{$lang.add}">
	<input type="submit" name="delselected" value="{$lang.del}" onclick="return confirmation('{$lang.holidays_delconfirm}');">
	</td>
	{/if}
</tr>
</table>
</form>
{include file='footer.tpl'}
