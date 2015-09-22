{include file='header.tpl'}
<form name="security" action="addresses.php" method="post">
<input type="hidden" name="set_security" value="1">
<input type="checkbox" name="enabled" {if $enabled}checked{/if} onClick="document.security.submit()"> <span style="cursor:hand; cursor:pointer" onClick="javascript:document.security.enabled.checked = !document.security.enabled.checked; document.security.submit()">{$lang.addresses_enable}</span>
</form><br>
<form name="def" action="addresses.php" method="post">
<table class="data" width="500" cellspacing="1" cellpadding="3">
<tr align="center">
	<td class="head" width="20"><input type="checkbox" onClick="checkAll(this.checked);"></td>
	<td class="head">{$lang.addresses_addr}</td>
	<td class="head" colspan="2" width="50">&mdash;</td>
</tr>
{section name=addr loop=$addresses}
	{if $smarty.section.addr.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">	
	<td class="{$classname}" width="20"><input type="checkbox" name="id[]" value={$addresses[addr].id}></td>
	<td class="{$classname}">{$addresses[addr].addr}</td>
	<td class="{$classname}"><a href="addresses.php?id_addr={$addresses[addr].id}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}"><a href="addresses.php?id[]={$addresses[addr].id}&amp;delselected=1" onclick="return confirmation('{$lang.addresses_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
</tr>
{/section}
</table>
<table border="0" width="500"  cellspacing="0" cellpadding="0">
<tr>
	<td align="left"><input type="submit" name="modify" value="{$lang.add}"></td>
	<td align="right"><input type="submit" name="delselected" value="{$lang.del}" onclick="return confirmation('{$lang.addresses_delconfirm}');"></td>
</tr>
</table>
</form>
{include file='footer.tpl'}