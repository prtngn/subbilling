{include file='header.tpl'}
<form action="tariffs.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id_tariff" value="{$id_tariff}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="130">{$lang.tariffs_name}</td>
	<td><input type="text" name="tariff_name" value="{$tariff_name}" size="25"></td>
</tr>
<tr align="left">
	<td width="130">{$lang.tariffs_period}</td>
	<td><input type="text" name="period" value="{$period}" size="10"></td>
</tr>
<tr align="left">
	<td width="130">{$lang.tariffs_payment}</td>
	<td><input type="text" name="payment" value="{if $payment}{$payment}{else}0{/if}" size="10"> {$lang.currency}</td>
</tr>
<tr align="left">
	<td width="130">{$lang.tariffs_prepaid_in}</td>
	<td><input type="text" name="p_in" value="{$p_in}" size="10"> Mb</td>
</tr>
<tr align="left">
	<td width="130">{$lang.tariffs_prepaid_out}</td>
	<td><input type="text" name="p_out" value="{$p_out}" size="10"> Mb</td>
</tr>
<tr align="left">
	<td width="130">{$lang.tariffs_public}</td>
	<td><select name="pub"><option value="0" {if !$pub}selected{/if}>{$lang.no}</option><option value="1" {if $pub}selected{/if}>{$lang.yes}</option></select></td>
</tr>
<tr align="left">
	<td width="130">{$lang.tariffs_route}</td>
	<td><select name="route">{html_options values=$routes.ids output=$routes.names}</select></td>
</tr>
<tr align="left">
	<td colspan="2">
	{if $id_tariff}
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