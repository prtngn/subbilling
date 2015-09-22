{include file='header.tpl'}
<form name="def" action="payments.php" method="post">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
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
	<td class="{$classname}">{$pay.pay_time|date_format:"%e %b %y, %H:%M:%S"}</td>
	<td class="{$classname}">{$pay.pay_value}</td>
	<td class="{$classname}">{$lang.payments_actions[$pay.action]}</td>
</tr>
{/foreach}
</table>
<select name="day1"> 
{php}
	global $day1, $day2, $month1, $month2, $year1, $year2, $lang;
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
</select> &mdash; <select name="day2"> 
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
