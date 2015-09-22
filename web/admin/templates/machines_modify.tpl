{include file='header.tpl'}
<form action="users.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id_user" value="{$id_user}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="130">{$lang.users_login}</td>
	<td><input type="text" name="user_login" value="{$user_login}" size="25"></td>
</tr>
<tr align="left">
	<td width="130">{$lang.users_password}</td>
	<td><input type="password" name="password1" value="{$password1}" size="25"></td>
</tr>
<tr align="left">
	<td width="130">{$lang.users_pass_confirm}</td>
	<td><input type="password" name="password2" value="{$password2}" size="25"></td>
</tr>
<tr align="left">
	<td width="130">{$lang.users_account}</td>
	<td>
	<select name="id_account">
	{html_options values=$accounts.ids selected=$id_account output=$accounts.names}
	</select>
	</td>
</tr>
<tr align="left">
	<td width="130">{$lang.users_tariff}</td>
	<td>
	<select name="id_tariff">
	{html_options values=$tariffs.ids selected=$id_tariff output=$tariffs.names}
	</select>
	</td>
</tr>
<tr align="left">
        <td width="130">{$lang.users_route}</td>
        <td>
        <select name="id_route">
        {html_options values=$route.ids selected=$id_route output=$route.names}
        </select>
        </td>
</tr>
<tr align="left">
	<td width="130">{$lang.users_inet}</td>
	<td><select name="nat"><option value="0" {if !$nat}selected{/if}>{$lang.users_ppp}</option><option value="1" {if $nat}selected{/if}>{$lang.users_nat}</option></select></td>
</tr>
<tr align="left">
	<td width="130">{$lang.users_addr}</td>
	<td>
		<select name="addr">
		{html_options values=$addrs.addr selected=$addr output=$addrs.addr}
		</select>
	</td>
<tr align="left">
	<td width="130">{$lang.users_eth_ip}</td>
        <td>
                <select name="eth_ip">
                {html_options values=$netaddrs.addr selected=$eth_ip output=$netaddrs.addr}
                </select>
        </td>
</tr>
<tr align="left">
	<td width="130">{$lang.users_eth_mac}</td>
	<td><input type="text" name="eth_mac" value="{if $eth_mac}{$eth_mac}{else}00:00:00:00:00:00{/if}" size="25"></td>
</tr>
</tr>
<tr align="left">
	<td width="130">{$lang.users_prepaid_in}</td>
	<td><input type="text" name="p_in" value="{$p_in}" size="25"> Mb</td>
</tr>
<tr align="left">
	<td width="130">{$lang.users_prepaid_out}</td>
	<td><input type="text" name="p_out" value="{$p_out}" size="25"> Mb</td>
</tr>
<tr align="left">
	<td colspan="2">
	{if $id_user}
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
