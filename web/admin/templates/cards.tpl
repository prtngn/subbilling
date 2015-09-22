{include file='header.tpl'}
<form name="def" action="cards.php" method="post">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if $perms[$curr_menu] eq 2}
	<td class="head" width="20"><input type="checkbox" onClick="checkAll(this.checked);"></td>
	{/if}
	<td class="head">{$lang.cards_pin}</td>
	{if $smarty.post.show_secrets}
	<td class="head">{$lang.cards_secret}</td>
	{/if}
	<td class="head">{$lang.cards_price}</td>
	<td class="head">{$lang.cards_generated}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="head" colspan="2" width="45">&mdash;</td>
	{/if}
</tr>
{section name=card loop=$cards}
	{if ($smarty.post.price and $smarty.post.price eq $cards[card].price) or (!$smarty.post.price)}
	{if $smarty.section.card.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">	
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}" width="20"><input type="checkbox" name="id[]" value={$cards[card].id}></td>
	{/if}
	<td class="{$classname}">{$cards[card].pin}</td>
	{if $smarty.post.show_secrets}
	<td class="{$classname}">{$cards[card].secret}</td>
	{/if}
	<td class="{$classname}">{$cards[card].price}</td>
	<td class="{$classname}">{$cards[card].generated|date_format:"%e %b %y, %H:%M"}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}"><a href="cards_act.php?id_card={$cards[card].id}"><img src="templates/img/apply.png" alt="{$lang.cards_activate}" title="{$lang.cards_activate}"></a></td>
	<td class="{$classname}"><a href="cards.php?id[]={$cards[card].id}&amp;delselected=1" onclick="return confirmation('{$lang.cards_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
	{/if}

</tr>
	
	{/if}
{/section}
</table>
<table border="0" width="700" cellspacing="0" cellpadding="0">
<tr>
	<td align="left">{$lang.cards_price}: <select name="price" onChange="javascript:submit()">
	{html_options values=$prices.ids selected=$smarty.post.price output=$prices.names}
	</select> <input type="checkbox" name="show_secrets" onClick="javascript:document.def.submit()" {if $smarty.post.show_secrets}checked{/if}> <span style="cursor:hand; cursor:pointer" onClick="javascript:document.def.show_secrets.checked = !document.def.show_secrets.checked; document.def.submit()">{$lang.cards_show_secrets}</span>
	<noscript> <input type="submit" name="showgroup" value="{$lang.show}"></noscript></td>
	<td align="right">
	<input type="submit" name="print" value="{$lang.print}">
	{if $perms[$curr_menu] eq 2}
	<input type="submit" name="delselected" value="{$lang.del}" onclick="return confirmation('{$lang.cards_delconfirm}');">
	{/if}
	</td>
</tr>
</table>
</form>
{include file='footer.tpl'}
