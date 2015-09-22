{include file='header.tpl'}
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if $type < 2}
	<td class="head">{$lang.stats_time}</td>
	{/if}
	<td class="head">{$lang.stats_date}</td>
	<td class="head">{if $sort_type}<a href=detailed.php?sort=src&sort_type=0>{else}<a href=detailed.php?sort=src&sort_type=1>{/if}{$lang.src}</a></td>
	<td class="head">{if $sort_type}<a href=detailed.php?sort=dst&sort_type=0>{else}<a href=detailed.php?sort=dst&sort_type=1>{/if}{$lang.dst}</td>
	<td class="head">{if $sort_type}<a href=detailed.php?sort=port&sort_type=0>{else}<a href=detailed.php?sort=port&sort_type=1>{/if}{$lang.port}</td>
	<td class="head">{$lang.proto}</td>
	<td class="head">{$lang.incoming}</td>
	<td class="head">{$lang.outgoing}</td>
</tr>
{assign var="total_in" value="0"}
{assign var="total_out" value="0"}

{section name=stat loop=$detailed}
	{if $smarty.section.stat.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">
	{if $type < 2}
	<td class="{$classname}">{$detailed[stat].time|date_format:"%H:%M:%S"}</td>
	{/if}
	<td class="{$classname}">{$detailed[stat].time|date_format:"%e.%m.%y"}</td>
	<td class="{$classname}">{$detailed[stat].src}</td>
	<td class="{$classname}">{$detailed[stat].dst}</td>
	<td class="{$classname}">{$detailed[stat].port}</td>
	<td class="{$classname}">{$detailed[stat].proto}</td>
	<td class="{$classname}">{$detailed[stat].incoming|fbytes}</td>
	<td class="{$classname}">{$detailed[stat].outgoing|fbytes}</td>
</tr>
{assign var="total_in" value="`$total_in+$detailed[stat].incoming`"}
{assign var="total_out" value="`$total_out+$detailed[stat].outgoing`"}
{/section}

<tr align="center">
	{if $type < 2}
		{assign var="colspan" value="2"}
	{else}
		{assign var="colspan" value="1"}
	{/if}
	<td class="head" colspan="{$colspan}">{$lang.stats_atotal}</td>
	<td class="head" colspan="4" width="22">&mdash;</td>
	<td class="head">{$total_in|fbytes}</td>
	<td class="head">{$total_out|fbytes}</td>
</tr>

</table>
<form name="def" action="detailed.php" method="post">
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
</select> <input type="submit" name="show" value="{$lang.show}"><br>
{$lang.user_label} <select name="id_user" onChange="javascript:submit()">
	{html_options values=$users.ids selected=$id_user output=$users.names}
</select>
</td></tr>
</table>
</form>
{include file='footer.tpl'}
