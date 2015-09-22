{include file='header.tpl'}
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if !$id_user}
	<td class="head" width="25%">{$lang.payments_user}</td>
	{/if}
	<td class="head" width="25%">{$lang.payments_date}</td>
	<td class="head" width="25%">{$lang.payments_value} ({$lang.currency})</td>
	<td class="head" width="50%">{$lang.payments_action}</td>
</tr>
{foreach item=pay from=$payments}
	{if $smarty.foreach.pay.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">
	{if !$id_user}
	<td class="{$classname}"><a href="users.php?id_user={$payments[pay].id_user}">{$pay.name} {$pay.lastname}</a></td>
	{/if}
	<td class="{$classname}">{$pay.pay_time|date_format:"%e %b %y, %H:%M:%S"}</td>
	<td class="{$classname}">{$pay.pay_value}</td>
	<td class="{$classname}">{$lang.payments_actions[$pay.action]}{if $pay.who} - "{$pay.who}"{/if}</td>
</tr>
{/foreach}
</table>
<form name="def" action="payments.php" method="post">
<table border="0" width="700" cellspacing="3" cellpadding="0">
<tr><td>
<select name="day1"> 
{php}
	global $date1, $date2, $lang;
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
</select> &mdash; <select name="day2"> 
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
{$lang.account_label} <select name="id_user" onChange="javascript:submit()">
	{html_options values=$users.ids selected=$id_user output=$users.names}
</select>&nbsp;&nbsp;
</td></tr></table>
</form>
{include file='footer.tpl'}
