{include file='header.tpl'}
<form action="holidays.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id_holiday" value="{$id_holiday}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="130">{$lang.holidays_day}</td>
	<td><input type="text" name="day" value="{$day}" size="10"></td>
</tr>
<tr align="left">
	<td width="130">{$lang.holidays_description}</td>
	<td><input type="text" name="description" value="{$description}" size="25"></td>
</tr>
<tr align="left">
	<td width="130">{$lang.holidays_tariff}</td>
	<td>
	<select name="id_tariff">
	{html_options values=$tariffs.ids selected=$id_tariff output=$tariffs.names}
	</select>
	</td>
</tr>
<tr align="left">
	<td width="130">{$lang.holidays_discount_in}</td>
	<td><input type="text" name="discount_in" value="{$discount_in}" size="10"> %</td>
</tr>
<tr align="left">
	<td width="130">{$lang.holidays_discount_out}</td>
	<td><input type="text" name="discount_out" value="{$discount_out}" size="10"> %</td>
</tr>
<tr align="left">
	<td colspan="2">
	{if $id_holiday}
	<input type="submit" name="modify" value="{$lang.edit}">
	{else}
	<input type="submit" name="modify" value="{$lang.add}">
	{/if}
	</td>
</tr>
</table>
</form>
{include file='errors.tpl'}
{include file='footer.tpl'}