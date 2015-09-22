{include file='header.tpl'}
<form name="def" action="configs_ip.php" method="post">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	<td class="head">{$lang.ip_name}</td>
	<td class="head">{$lang.ip_type}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="head" colspan="2" width="40">&mdash;</td>
	{/if}
</tr>
{section name=conf loop=$ip}
	{if $smarty.section.group.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">
	<td class="{$classname}">{$ip[conf].net}/{$ip[conf].mask}</td>
	<td class="{$classname}">{if $ip[conf].nat eq 0}{$lang.ip_ppp}{else}{$lang.ip_nat}{/if}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}" width="20"><a href="configs_ip.php?id_route={$ip[conf].id}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}" width="20"><a href="configs_ip.php?id={$ip[conf].id}&amp;delselected=1" onclick="return confirmation('{$lang.route_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
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
