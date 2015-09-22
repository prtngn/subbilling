{include file='header.tpl'}
{if $id_ticket}
	{include file="tickets_view.tpl" tickets="`$tickets`"}
{else}
	{if $tickets|count}
	<h2>{$lang.tickets_tickets}:</h2>
	{include file="tickets_tree.tpl" tickets="`$tickets`"}
	<h2>{$lang.tickets_legend}:</h2>
	<table border="0" cellspacing="3" cellpadding="0">
	<tr align="left"><td width="16"><img src="templates/img/told.png"></td><td>&mdash; {$lang.tickets_legend_told}</td></tr>
	<tr align="left"><td width="16"><img src="templates/img/noreply.png"></td><td>&mdash; {$lang.tickets_legend_noreply}</td></tr>
	</table>
	{else}
	{$lang.tickets_empty}
	{/if}
{/if}
{include file='footer.tpl'}