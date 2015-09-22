{include file='header.tpl'}
<form action="configs_ppp.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id" value="{$id}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="100">{$lang.conf_name}</td>
	<td><input type="text" name="name" value="{$name}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.conf_nat}</td>
	<td><select name="nat"><option value="MASQUERADE" {if $nat == 'MASQUERADE'}selected{/if}>{$lang.conf_masquerade}</option><option value="IPROUTE" {if $nat == 'IPROUTE'}selected{/if}>{$lang.conf_iproute}</option></select></td>
</tr>
<tr align="left">
	<td width="100">{$lang.conf_mppe}</td>
	<td><select name="mppe"><option value="0" {if $mppe == '0'}selected{/if}>{$lang.no}</option><option value="1" {if $mppe == '1'}selected{/if}>{$lang.yes}</option></select></td>
</tr>
<tr align="left">
	<td width="100">{$lang.conf_dns_one}</td>
	<td><input type="text" name="dns_one" value="{$dns_one}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.conf_dns_two}</td>
	<td><input type="text" name="dns_two" value="{$dns_two}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.conf_radius}</td>
	<td><select name="radius"><option value="0" {if $radius == '0'}selected{/if}>{$lang.no}</option><option value="1" {if $radius == '1'}selected{/if}>{$lang.yes}</option></select></td>
</tr>
<tr align="left">
	<td width="100">{$lang.conf_detailed}</td>
	<td><select name="detailed"><option value="0" {if $detailed == '0'}selected{/if}>{$lang.no}</option><option value="1" {if $detailed == '1'}selected{/if}>{$lang.yes}</option></select></td>
</tr>
<tr align="left">
	<td width="100">{$lang.conf_used}</td>
	<td><select name="used"><option value="0" {if $used == '0'}selected{/if}>{$lang.no}</option><option value="1" {if $used == '1'}selected{/if}>{$lang.yes}</option></select></td>
</tr>
<tr align="left">
	<td colspan="2">
	{if $id}
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
