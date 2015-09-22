{include file='header.tpl'}
<form name="def" action="configs_dhcpd.php" method="post">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	<td class="head">{$lang.configs_dhcpd_name}</td>
	<td class="head">{$lang.configs_dhcpd_interface}</td>
	<td class="head">{$lang.configs_dhcpd_network}</td>
	<td class="head">{$lang.configs_dhcpd_gateway}</td>
	<td class="head">{$lang.configs_dhcpd_dns1}</td>
	<td class="head">{$lang.configs_dhcpd_dns2}</td>
	<td class="head">{$lang.configs_dhcpd_nbios1}</td>
	<td class="head">{$lang.configs_dhcpd_nbios2}</td>
	<td class="head">{$lang.configs_dhcpd_time}</td>
	<td class="head">{$lang.configs_dhcpd_ntp}</td>
	<td class="head">{$lang.configs_dhcpd_domain}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="head" colspan="2" width="40">&mdash;</td>
	{/if}
</tr>
{section name=conf loop=$dhcpd}
	{if $smarty.section.group.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">
	<td class="{$classname}">{$dhcpd[conf].name}</td>
	<td class="{$classname}">{$dhcpd[conf].interface}</td>
	<td class="{$classname}">{$dhcpd[conf].net}/{$dhcpd[conf].mask}</td>
	<td class="{$classname}">{$dhcpd[conf].gateway}</td>
	<td class="{$classname}">{$dhcpd[conf].dns1}</td>
	<td class="{$classname}">{$dhcpd[conf].dns2}</td>
	<td class="{$classname}">{$dhcpd[conf].nbios1}</td>
	<td class="{$classname}">{$dhcpd[conf].nbios2}</td>
	<td class="{$classname}">{$dhcpd[conf].time}</td>
	<td class="{$classname}">{$dhcpd[conf].ntp}</td>
	<td class="{$classname}">{$dhcpd[conf].domain}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}" width="20"><a href="configs_dhcpd.php?id={$dhcpd[conf].id}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}" width="20"><a href="configs_dhcpd.php?id={$dhcpd[conf].id}&amp;delselected=1" onclick="return confirmation('{$lang.configs_dhcpd_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
	{/if}
</tr>
{/section}
</table>
{if $perms[$curr_menu] eq 2}
<table border="0" width="700"  cellspacing="0" cellpadding="0">
<tr>
	<td align="left"><input type="submit" name="modify" value="{$lang.add}"></td>
</tr>
</table>
{/if}
</form>
{include file='footer.tpl'}