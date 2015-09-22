{include file='header.tpl'}
<form action="tariff.php" method="post">
	{$lang.tariff_select}: <select name="id_tariff" onChange="javascript:submit()"> 
	{html_options values=$tariffs.ids selected=$id_tariff output=$tariffs.names}
	</select> <noscript><input type="submit" name="show" value="{$lang.show}"></noscript>	
</form>
<br>{$lang.tariff_next_tariff} <a href="tariff.php?id_tariff={$id_next}">{$next_tariff|@stripslashes}</a><br>
{$lang.tariff_period_remaining} {$next_period|date_format:"%e %b %y, %H:%M:%S"}<br>
<h2>{$lang.tariff_info}</h2>
<table class="data" width="500" cellspacing="1" cellpadding="3">
<tr align="center">
	<td class="head" width="50%">{$lang.param}</td>
	<td class="head" width="50%">{$lang.value}</td>
</tr>

<tr>
	<td class="data1" align="right">{$lang.tariff_name}</td>
	<td class="data1" align="center">{$tariff.tariff_name|@stripslashes}</td>
</tr>
<tr>
	<td class="data2" align="right">{$lang.tariff_period}</td>
	<td class="data2" align="center">{$tariff.period|sec2days}</td>
</tr>
<tr>
	<td class="data1" align="right">{$lang.tariff_payment}</td>
	<td class="data1" align="center">{$tariff.payment} {$lang.currency}</td>
</tr>
<tr>
	<td class="data2" align="right">{$lang.tariff_prepaid_in}</td>
	<td class="data2" align="center">{$tariff.p_in|fbytes}</td>
</tr>
<tr>
	<td class="data1" align="right">{$lang.tariff_prepaid_out}</td>
	<td class="data1" align="center">{$tariff.p_out|fbytes}</td>
</tr>
</table>

<h2>{$lang.tariff_zone_info}</h2>
<table class="data" width="500" cellspacing="1" cellpadding="3">
<tr align="center">
	<td class="head" rowspan="3">{$lang.tariff_zone_name}</td>
	<td class="head" colspan="3">{$lang.tariff_zone_price}</td>
	<td class="head" rowspan="3">{$lang.tariff_zone_speed}</td>
	<td class="head" rowspan="3">{$lang.tariff_time_prepaid}</td>
</tr>
<tr align="center">
	<td class="head" rowspan="2">{$lang.tariff_time}</td>
	<td class="head" colspan="2">{$lang.tariff_time_price}</td>
</tr>
<tr align="center">
	<td class="head">{$lang.incoming}</td>
	<td class="head">{$lang.outgoing}</td>
</tr>
{section name=group loop=$groups}
	{if $smarty.section.group.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">
	<td class="{$classname}" rowspan="{$groups[group].timers|@count}">{$groups[group].group_name|@stripslashes}</td>
	<td class="{$classname}">{$groups[group].timers[0].time_from} - {$groups[group].timers[0].time_to}</td>
	<td class="{$classname}">{$groups[group].timers[0].cost_in}</td>
	<td class="{$classname}">{$groups[group].timers[0].cost_out}</td>
	<td class="{$classname}">{$groups[group].timers[0].speed}</td>
	<td class="{$classname}">{if $groups[group].timers[0].prepaid}{$lang.yes}{else}{$lang.no}{/if}</td>
</tr>
	{section name=timer loop=$groups[group].timers start=1}
	<tr align="center">
	<td class="{$classname}">{$groups[group].timers[timer].time_from} - {$groups[group].timers[timer].time_to}</td>
	<td class="{$classname}">{$groups[group].timers[timer].cost_in}</td>
	<td class="{$classname}">{$groups[group].timers[timer].cost_out}</td>
	<td class="{$classname}">{$groups[group].timers[timer].speed}</td>
	<td class="{$classname}">{if $groups[group].timers[timer].prepaid}{$lang.yes}{else}{$lang.no}{/if}</td>
	</tr>
	{/section}
{/section}
</table>

<h2>{$lang.tariff_holidays_info}</h2>
<table class="data" width="500" cellspacing="1" cellpadding="3">
<tr align="center">
	<td class="head" width="30%">{$lang.tariff_holidays_day}</td>
	<td class="head" width="20%" colspan="2">{$lang.tariff_holidays_discount} %</td>
	<td class="head" width="50%">{$lang.tariff_holidays_description}</td>
</tr>
{section name=holiday loop=$holidays}
	{if $smarty.section.holiday.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">	
	<td class="{$classname}" width="30%">{$holidays[holiday].day}</td>
	<td class="{$classname}" width="10%">{$holidays[holiday].discount_in}</td>
	<td class="{$classname}" width="10%">{$holidays[holiday].discount_out}</td>
	<td class="{$classname}" width="50%">{$holidays[holiday].description}</td>
</tr>
{sectionelse}
<tr align="center">	
	<td class="data1" colspan="4">{$lang.no}</td>
</tr>
{/section}
</table>

<form action="tariff.php" method="post">
<input type="hidden" name="id_tariff" value="{$id_tariff}">
{if $id_next!=$id_tariff and $change_tariff}
<input type="submit" name="set_next" value="{$lang.tariff_set_next}">
<input type="submit" name="set_now" value="{$lang.tariff_set_now}">
{/if}
</form>
{include file='footer.tpl'}