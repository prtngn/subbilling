{include file='header.tpl' meta='<meta http-equiv="refresh" content="60">'}
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if $level==1}
	<td class="head">{$lang.stats_user}</td>
	{/if}
	{if $level==2}
	<td class="head">{$lang.stats_zone}</td>
	{/if}
	{if not $level}
	{if $type < 2}
	<td class="head">{$lang.stats_time}</td>
	{/if}
	<td class="head">{$lang.stats_date}</td>
	{/if}
	<td class="head">{$lang.incoming}</td>
	<td class="head">{$lang.outgoing}</td>
	<td class="head">{$lang.timezones_cost}</td>
	{if not $level}
	<td class="head" colspan="2" width="45">&mdash;</td>
	{/if}
</tr>
{assign var="total_in" value="0"}
{assign var="total_out" value="0"}
{assign var="total_cost" value="0"}

{section name=stat loop=$stats}
	{if $smarty.section.stat.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">
	{if $level==1}
	<td class="{$classname}"><a href="users.php?id_user={$stats[stat].id_user}">{$stats[stat].login}</a></td>
	{/if}
	{if $level==2}
	<td class="{$classname}"><a href="routes_groups.php?id_group={$stats[stat].id_group}">{$stats[stat].group_name|@stripslashes}</a></td>
	{/if}
	{if not $level}
	{if $type < 2}
	<!--<td class="{$classname}">{$stats[stat].log_time|date_format:"%H:%M"}</td>-->
	<td class="{$classname}">{$stats[stat].log_time|date_format:"%H:%M"}</td>
	{/if}
	<td class="{$classname}">{if $type < 3}{$stats[stat].log_time|date_format:"%e.%m.%y"}{else}{$stats[stat].log_time|date_format:"%B %y"}{/if}</td>
	{/if}
	<td class="{$classname}">{$stats[stat].incoming|fbytes}</td>
	<td class="{$classname}">{$stats[stat].outgoing|fbytes}</td>
	<td class="{$classname}">{$stats[stat].cost|@round:"2"} {$lang.currency}</td>
	{if not $level}
	<td class="{$classname}"><a href="stats.php?min1={$stats[stat].i}&amp;hour1={$stats[stat].G}&amp;day1={$stats[stat].j}&amp;month1={$stats[stat].n}&amp;year1={$stats[stat].Y}&amp;min2={$stats[stat].i}&amp;hour2={$stats[stat].G}&amp;day2={$stats[stat].j}&amp;month2={$stats[stat].n}&amp;year2={$stats[stat].Y}&amp;type={$type}&amp;level=2&amp;id_user={$id_user}"><img src="templates/img/zones.png" alt="{$lang.stats_zonelevel}" title="{$lang.stats_zonelevel}"></a></td>
	<td class="{$classname}"><a href="stats.php?min1={$stats[stat].i}&amp;hour1={$stats[stat].G}&amp;day1={$stats[stat].j}&amp;month1={$stats[stat].n}&amp;year1={$stats[stat].Y}&amp;min2={$stats[stat].i}&amp;hour2={$stats[stat].G}&amp;day2={$stats[stat].j}&amp;month2={$stats[stat].n}&amp;year2={$stats[stat].Y}&amp;type={$type}&amp;level=1&amp;id_group={$id_group}"><img src="templates/img/users.png" alt="{$lang.stats_userlevel}" title="{$lang.stats_userlevel}"></a></td>
	{/if}
</tr>
{assign var="total_in" value="`$total_in+$stats[stat].incoming`"}
{assign var="total_out" value="`$total_out+$stats[stat].outgoing`"}
{assign var="total_cost" value="`$total_cost+$stats[stat].cost`"}
{/section}

<tr align="center">
	{if not $level and $type < 2}
		{assign var="colspan" value="2"}
	{else}
		{assign var="colspan" value="1"}
	{/if}
	
	<td class="head" colspan="{$colspan}">{$lang.stats_atotal}</td>
	<td class="head">{$total_in|fbytes}</td>
	<td class="head">{$total_out|fbytes}</td>
	<td class="head">{$total_cost|@round:"2"} {$lang.currency}</td>
	{if not $level}
	<td class="head" colspan="2" width="45">&mdash;</td>
	{/if}
</tr>

</table>
<form name="def" action="stats.php" method="post">
<input type="hidden" name="level" value="{$level}">
<table border="0" width="700" cellspacing="3" cellpadding="0">
<tr><td>
<select name="hour1">
{php}
	global $date1, $date2, $lang;
	for($i=0;$i<24;$i++) {
		echo "<option value=$i";
		if ($i == $date1['hour'])echo " selected";
		echo ">$i</option>";
	}
{/php}
</select>:<select name="min1"> 
{php}
	for($i=0;$i<60;$i++) {
		echo "<option value=$i";
		if ($i == $date1['min'])echo " selected";
		echo ">$i</option>";
	}
{/php}
</select>&nbsp;&nbsp;&nbsp;<select name="day1"> 
{php}
	for($i=1;$i<32;$i++) {
		echo "<option value=$i";
		if ($i == $date1['day'])echo " selected";
		echo ">$i</option>";
	}
{/php}
</select> <select name="month1"> 
{php}
	for($i=1;$i<13;$i++) {
		echo "<option value=$i";
		if ($i == $date1['month'])echo " selected";
		echo ">". $lang['months'][$i] ."</option>";
	}
{/php}
</select> <select name="year1"> 
{php}
	for($i=2006;$i<2037;$i++) {
		echo "<option value=$i";
		if ($i == $date1['year'])echo " selected";
		echo ">$i</option>";
	}
{/php}
</select> &mdash; <select name="hour2"> 
{php}
	for($i=0;$i<24;$i++) {
		echo "<option value=$i";
		if ($i == $date2['hour'])echo " selected";
		echo ">$i</option>";
	}
{/php}
</select>:<select name="min2"> 
{php}
	for($i=0;$i<60;$i++) {
		echo "<option value=$i";
		if ($i == $date2['min'])echo " selected";
		echo ">$i</option>";
	}
{/php}
</select>&nbsp;&nbsp;&nbsp;<select name="day2"> 
{php}
	for($i=1;$i<32;$i++) {
		echo "<option value=$i";
		if ($i == $date2['day'])echo " selected";
		echo ">$i</option>";
	}
{/php}
</select> <select name="month2"> 
{php}
	for($i=1;$i<13;$i++) {
		echo "<option value=$i";
		if ($i == $date2['month'])echo " selected";
		echo ">". $lang['months'][$i] ."</option>";
	}
{/php}
</select> <select name="year2"> 
{php}
	for($i=2006;$i<2037;$i++) {
		echo "<option value=$i";
		if ($i == $date2['year'])echo " selected";
		echo ">$i</option>";
	}
{/php}
</select> <input type="submit" name="show" value="{$lang.show}">
</td></tr>
<tr><td>
{if $level!=1}
{$lang.user_label} <select name="id_user" onChange="javascript:submit()">
	{html_options values=$users.ids selected=$id_user output=$users.names}
</select>&nbsp;&nbsp;
{/if}
{if $level!=2}
{$lang.group_label} <select name="id_group" onChange="javascript:submit()">
	{html_options values=$groups.ids selected=$id_group output=$groups.names}
</select>&nbsp;&nbsp;
{/if}
{$lang.stats_type} <select name="type" onChange="javascript:submit()">
	{html_options values=$types selected=$type output=$lang.stats_type_arr}
</select>
</table>
</form>
{include file='footer.tpl'}
