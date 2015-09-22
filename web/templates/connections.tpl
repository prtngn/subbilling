{include file='header.tpl'}
<form name="def" action="connections.php" method="post">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	<td class="head">{$lang.connections_addr}</td>
	<td class="head">{$lang.connections_time_start}</td>
	<td class="head">{$lang.connections_time_end}</td>
</tr>
{section name=connect loop=$connections}
	{if $smarty.section.connect.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">
	<td class="{$classname}">{$connections[connect].addr}</td>
	<td class="{$classname}">{$connections[connect].time_start|date_format:"%e %b %y, %H:%M:%S"}</td>
	<td class="{$classname}">
	{if $connections[connect].time_end}
		{$connections[connect].time_end|date_format:"%e %b %y, %H:%M:%S"}
	{else}
		{$lang.connections_online}
	{/if}
	</td>
</tr>
{/section}
</table>
<select name="hour1">
{php}
	global $min1, $min2, $hour1, $hour2, $day1, $day2, $month1, $month2, $year1, $year2, $lang;
	for($i=0;$i<24;$i++) {
		echo "<option value=$i";
		if ($i == $hour1)echo " selected";
		echo ">$i</option>";
	}
{/php}
</select>:<select name="min1"> 
{php}
	for($i=0;$i<60;$i++) {
		echo "<option value=$i";
		if ($i == $min1)echo " selected";
		echo ">$i</option>";
	}
{/php}
</select>&nbsp;&nbsp;&nbsp;<select name="day1"> 
{php}
	for($i=1;$i<32;$i++) {
		echo "<option value=$i";
		if ($i == $day1)echo " selected";
		echo ">$i</option>";
	}
{/php}
</select> <select name="month1"> 
{php}
	for($i=1;$i<13;$i++) {
		echo "<option value=$i";
		if ($i == $month1)echo " selected";
		echo ">". $lang['months'][$i] ."</option>";
	}
{/php}
</select> <select name="year1"> 
{php}
	for($i=2006;$i<2037;$i++) {
		echo "<option value=$i";
		if ($i == $year1)echo " selected";
		echo ">$i</option>";
	}
{/php}
</select> &mdash; <select name="hour2"> 
{php}
	for($i=0;$i<24;$i++) {
		echo "<option value=$i";
		if ($i == $hour2)echo " selected";
		echo ">$i</option>";
	}
{/php}
</select>:<select name="min2"> 
{php}
	for($i=0;$i<60;$i++) {
		echo "<option value=$i";
		if ($i == $min2)echo " selected";
		echo ">$i</option>";
	}
{/php}
</select>&nbsp;&nbsp;&nbsp;<select name="day2"> 
{php}
	for($i=1;$i<32;$i++) {
		echo "<option value=$i";
		if ($i == $day2)echo " selected";
		echo ">$i</option>";
	}
{/php}
</select> <select name="month2"> 
{php}
	for($i=1;$i<13;$i++) {
		echo "<option value=$i";
		if ($i == $month2)echo " selected";
		echo ">". $lang['months'][$i] ."</option>";
	}
{/php}
</select> <select name="year2"> 
{php}
	for($i=2006;$i<2037;$i++) {
		echo "<option value=$i";
		if ($i == $year2)echo " selected";
		echo ">$i</option>";
	}
{/php}
</select> <input type="submit" name="show" value="{$lang.show}">
</form>
{include file='footer.tpl'}
