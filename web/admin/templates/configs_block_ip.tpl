{include file='header.tpl'}
<form name="def" action="configs_block_ip.php" method="post">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	<td class="head">{$lang.conf_blocked_ip_zone}</td>
	<td class="head">{$lang.conf_blocked_ip_uid}</td>
	<td class="head">{$lang.conf_blocked_ip_gid}</td>
        <td class="head">{$lang.conf_blocked_ip_port}</td>
        <td class="head">{$lang.conf_blocked_ip_proto}</td>
        <td class="head">{$lang.conf_blocked_ip_action}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="head" colspan="2" width="40">&mdash;</td>
	{/if}
</tr>
{section name=conf loop=$blocked_ip}
	{if $smarty.section.group.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">
	<td class="{$classname}">{if $blocked_ip[conf].net == 0}{if $blocked_ip[conf].ip == 0}{if $blocked_ip[conf].ip_first eq 0}{$lang.conf_blocked_ip_all}{else}{$blocked_ip[conf].ip_first}-{$blocked_ip[conf].ip_last}{/if}{else}{$blocked_ip[conf].ip}{/if}{else}{$blocked_ip[conf].net}/{$blocked_ip[conf].mask}{/if}</td>
	<td class="{$classname}">{if $blocked_ip[conf].uid == 0}{$lang.conf_blocked_ip_all_uid}{else}{$blocked_ip[conf].uid}{/if}</td>
        <td class="{$classname}">{if $blocked_ip[conf].gid == 0}{$lang.conf_blocked_ip_all_gid}{else}{$blocked_ip[conf].gid}{/if}</td>
        <td class="{$classname}">{if $blocked_ip[conf].port == 0}{$lang.conf_blocked_ip_all_port}{else}{$blocked_ip[conf].port}{/if}</td>
        <td class="{$classname}">{if $blocked_ip[conf].proto == all}{$lang.conf_blocked_ip_all_proto}{else}{$blocked_ip[conf].proto}{/if}</td>
        <td class="{$classname}">{$blocked_ip[conf].action}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}" width="20"><a href="configs_block_ip.php?id={$blocked_ip[conf].id}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}" width="20"><a href="configs_block_ip.php?id={$blocked_ip[conf].id}&amp;delselected=1" onclick="return confirmation('{$lang.route_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
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
