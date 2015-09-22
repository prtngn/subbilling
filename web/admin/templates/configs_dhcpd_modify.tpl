{include file='header.tpl'}
<form action="configs_dhcpd.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id" value="{$id}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="100">{$lang.configs_dhcpd_name}</td>
	<td><input type="text" name="name" value="{$name}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.configs_dhcpd_interface}</td>
	<td><input type="text" name="interface" value="{$interface}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.configs_dhcpd_network}</td>
	<td>
		<select name="network">
		{html_options values=$networks.id selected=$network output=$networks.net}
		</select>
	</td>
</tr>
<tr align="left">
	<td width="100">{$lang.configs_dhcpd_gateway}</td>
	<td><input type="text" name="gateway" value="{$gateway}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.configs_dhcpd_dns1}</td>
	<td><input type="text" name="dns1" value="{$dns1}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.configs_dhcpd_dns2}</td>
	<td><input type="text" name="dns2" value="{$dns2}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.configs_dhcpd_nbios1}</td>
	<td><input type="text" name="nbios1" value="{$nbios1}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.configs_dhcpd_nbios2}</td>
	<td><input type="text" name="nbios2" value="{$nbios2}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.configs_dhcpd_time}</td>
	<td><input type="text" name="time" value="{$time}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.configs_dhcpd_ntp}</td>
	<td><input type="text" name="ntp" value="{$ntp}" size="25"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.configs_dhcpd_domain}</td>
	<td><input type="text" name="domain" value="{$domain}" size="25"></td>
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