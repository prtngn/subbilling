{include file='header.tpl'}
<h2>{$lang.index_account_info}</h2>
{$lang.index_name}: {$user.lastname|@stripslashes} {$user.name|@stripslashes} {$user.surname|@stripslashes}<br><br>
{if $user.address}
	{$lang.index_address}:
	{$user.address|@stripslashes}<br><br>
{/if}
{if $user.phone}
	{$lang.index_phone}:
	{$user.phone|@stripslashes}<br><br>
{/if}
	{$lang.index_login}:
	{$user.login}<br><br>
	{$lang.index_account}:
	{$user.id_account}<br><br>
	{$lang.index_group}:
	{$user.group_name}<br><br>
	{$lang.index_tariff}:
	{$user.tariff_name}<br><br>
	{$lang.index_deposit}:
	{$user.deposit} {$lang.currency}<br><br>
	{$lang.index_discount}:
	{$user.discount}%<br><br>
	{$lang.index_prepaid_in}:
	{$user.p_in|fbytes}<br><br>
	{$lang.index_prepaid_out}:
	{$user.p_out|fbytes}<br><br>
	{$lang.index_registered}:
	{$user.registered|date_format:"%e %b %y, %H:%M:%S"}<br><br>
	{$lang.index_last_login}:
	{$user.last_login|date_format:"%e %b %y, %H:%M:%S"}<br><br>
	{$lang.index_last_connect}:
	{$user.last_connect|date_format:"%e %b %y, %H:%M:%S"}<br><br>
	{$lang.index_state}:
	
	{if $user.blocked or ($user.max_credit+$user.deposit)<0}
		<img src="templates/img/blocked.png"> {$lang.index_blocked}  
	{else}
		<img src="templates/img/ok.png"> {$lang.index_allowed} 
	{/if}
{include file='footer.tpl'}