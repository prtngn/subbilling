{include file='header.tpl'}
<form name="def" action="configs_ppp.php" method="post">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	<td class="head">{$lang.conf_name}</td>
	<td class="head">{$lang.conf_nat}</td>
	<td class="head">{$lang.conf_mppe}</td>
	<td class="head">{$lang.conf_dns_one}</td>
	<td class="head">{$lang.conf_dns_two}</td>
	<td class="head">{$lang.conf_radius}</td>
	<td class="head">{$lang.conf_detailed}</td>
	<td class="head">{$lang.conf_used}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="head" colspan="2" width="40">&mdash;</td>
	{/if}
</tr>
{section name=parm loop=$conf}
	{if $smarty.section.group.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">
	<td class="{$classname}">{$conf[parm].name}</td>
	<td class="{$classname}">{$conf[parm].nat}</td>
	{if $conf[parm].mppe eq 0}
		<td class="{$classname}">{$lang.no}</td>
	{elseif $conf[parm].mppe eq 1}
		<td class="{$classname}">{$lang.yes}</td>
	{/if}
	<td class="{$classname}">{$conf[parm].dns_one}</td>
	<td class="{$classname}">{$conf[parm].dns_two}</td>
	{if $conf[parm].radius eq 0}
		<td class="{$classname}">{$lang.no}</td>
	{elseif $conf[parm].radius eq 1}
		<td class="{$classname}">{$lang.yes}</td>
	{/if}
	{if $conf[parm].detailed eq 0}
		<td class="{$classname}">{$lang.no}</td>
	{elseif $conf[parm].detailed eq 1}
		<td class="{$classname}">{$lang.yes}</td>
	{/if}
	{if $conf[parm].used eq 0}
		<td class="{$classname}">{$lang.no}</td>
	{elseif $conf[parm].used eq 1}
		<td class="{$classname}">{$lang.yes}</td>
	{/if}
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}" width="20"><a href="configs_ppp.php?id={$conf[parm].id}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}" width="20"><a href="configs_ppp.php?id={$conf[parm].id}&amp;delselected=1" onclick="return confirmation('{$lang.route_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
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
{if $error eq 1}
<table border="0" cellspacing="5" cellpadding="0"><tr>
<td><img src="templates/img/warn.png"></td>
<td><b>{$lang.attention_conf}</b></td>
</tr>
</table>
{/if}
{include file='footer.tpl'}