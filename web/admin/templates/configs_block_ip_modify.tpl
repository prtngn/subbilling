{include file='header.tpl'}
<form action="configs_block_ip.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id" value="{$id}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="100">{$lang.conf_blocked_ip_zone}</td>
	<td><input type="text" name="ip_zone" value="{$net}/{$mask}" size="25"></td>
</tr>
<tr align="left">
        <td width="100">{$lang.conf_blocked_ip_uid}</td>
        <td><input type="text" name="ip_zone" value="" size="25"></td>
</tr>
<tr align="left">
        <td width="100">{$lang.conf_blocked_ip_gid}</td>
        <td><input type="text" name="ip_zone" value="" size="25"></td>
</tr>
<tr align="left">
        <td width="100">{$lang.conf_blocked_ip_port}</td>
        <td><input type="text" name="ip_zone" value="{$port}" size="25"></td>
</tr>
<tr align="left">
        <td width="100">{$lang.conf_blocked_ip_proto}</td>
	<td><select name="proto">
		<option value="tcp" {if $proto == 'tcp'}selected{/if}>{$lang.conf_blocked_ip_tcp}</option>
		<option value="udp" {if $proto == 'udp'}selected{/if}>{$lang.conf_blocked_ip_udp}</option>
		<option value="icmp" {if $proto == 'icmp'}selected{/if}>{$lang.conf_blocked_ip_icmp}</option>
		<option value="tcp,udp" {if $proto == 'tcp,udp'}selected{/if}>{$lang.conf_blocked_ip_tcp},{$lang.conf_blocked_ip_udp}</option>
		<option value="tcp,icmp" {if $proto == 'tcp,icmp'}selected{/if}>{$lang.conf_blocked_ip_tcp},{$lang.conf_blocked_ip_icmp}</option>
		<option value="icmp,udp" {if $proto == 'icmp,udp'}selected{/if}>{$lang.conf_blocked_ip_icmp},{$lang.conf_blocked_ip_udp}</option>
		<option value="all" {if $proto == 'all'}selected{/if}>{$lang.conf_blocked_ip_proto_all}</option>
	</select></td>
</tr>
<tr align="left">
        <td width="100">{$lang.conf_blocked_ip_action}</td>
	<td><select name="action"><option value="DROP" {if $action == 'DROP'}selected{/if}>{$lang.conf_blocked_ip_drop}</option><option value="REJECT" {if $action == 'REJECT'}selected{/if}>{$lang.conf_blocked_ip_reject}</option></select></td>
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
