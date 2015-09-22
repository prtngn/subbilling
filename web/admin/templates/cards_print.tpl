<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>{$lang.cards}</title>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
</head>
<body>
<table border="1" cellspacing="0" cellpadding="10">
{section name=card loop=$cards}
{if ($smarty.post.price and $smarty.post.price eq $cards[card].price) or (!$smarty.post.price)}
<tr>
	<td>
	<b>{$lang.cards_price}:</b> {$cards[card].price} {$lang.currency}<br><br>
	<b>{$lang.cards_pin}:</b> {$cards[card].pin}<br>
	<b>{$lang.cards_secret}:</b> {$cards[card].secret}
	</td>
</tr>
{/if}
{/section}
</table>
</body>
</html>