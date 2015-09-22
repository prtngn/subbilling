{include file='header.tpl'}
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if !$id_user}
	<td class="head" width="25%">{$lang.connections_user}</td>
	{/if}
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
	{if !$id_user}
	<td class="{$classname}"><a href="users.php?id_user={$connections[connect].id_user}">{$connections[connect].login}</a></td>
	{/if}
	<td class="{$classname}">{$connections[connect].address}</td>
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
<form name="def" action="connections.php" method="post">
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
{$lang.user_label} <select name="id_user" onChange="javascript:submit()">
	{html_options values=$users.ids selected=$id_user output=$users.names}
</select>
</table>
</form>
{include file='footer.tpl'}
