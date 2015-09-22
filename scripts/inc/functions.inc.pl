#!/usr/bin/perl

sub inet_aton {
	my @addr = split(/\./,$_[0]);
	my $dec = 0;
	for($n = 3; $n >= 0; $n--) {
		$dec += ($addr[-$n-1] << 8 * $n);
	}
	return $dec;
}

sub inet_ntoa {
	my $dec = $_[0];
	my $addr;
	for($n = 3; $n >= 0; $n--) {
		$addr .= '.'.(($dec >> 8 * $n) & 255);
	}
	$addr =~ s/\.//;
	return $addr;
}

sub in_net($$$) {
	my ($ip,$net,$mask) = @_;
	$mask = 0xFFFFFFFF - (2**(32 - $mask) - 1);
	return (($ip & $mask) == $net);
}

sub in_range($$$) {
	my ($ip,$ip1,$ip2) = @_;
	if (($ip>=$ip1) && ($ip<=$ip2)) {
		return 1
	} else {
		return 0;
	}
}

sub str_replace(\@\@$) {
	my ($search,$replace,$source) = @_;
	for (my $i=0; $i < @$search; $i++) {
		$source =~s/@$search[$i]/@$replace[$i]/gi;
	}
	return $source;
}

sub read_config {
	my %config = ();

	open CONF, "< subbilling.conf";
	while (<CONF>) {
		if (m/^([^#].*?)\s+(.*?)$/) {
			$config{$1} = $2;
		}
	}
	close CONF;
	return %config;
}

sub get_id_group {
	my ($routes, $ip, $tariff) = @_;
	my %routes = %$routes;
	my $prio = 0;
	my $group = 0;
	my $route = 0;

	for $prio (sort keys %{$routes{$tariff}}) {
		for $group (keys %{$routes{$tariff}{$prio}}) {
			for $route (keys %{$routes{$tariff}{$prio}{$group}}) {
				if ($routes{$tariff}{$prio}{$group}{$route}{'dest_type'}) {
					if (in_range($ip,$routes{$tariff}{$prio}{$group}{$route}{'ip_first'},$routes{$tariff}{$prio}{$group}{$route}{'ip_last'})) {
						return $group;
					}
				} else {
					if (in_net($ip,$routes{$tariff}{$prio}{$group}{$route}{'net'},$routes{$tariff}{$prio}{$group}{$route}{'mask'})) {
						return $group;
					}
				}
			}
		}
	}
	return 0;
}

sub get_price {
	my ($prices, $holidays, $tm, $group, $tariff) = @_;
	%prices = %$prices;
	%holidays = %$holidays;

	my $dayofmonth = strftime("%d.%m", localtime($tm));
	my $dayofweek = strftime "%w", localtime($tm);

	my $price = 0;
	my $hour = (localtime($tm))[2];

	for $price (keys %{$prices{$group}}) {
		if (($hour >= $prices{$group}{$price}{'time_from'}) && ($hour <= $prices{$group}{$price}{'time_to'})) {
			if ($holidays{$tariff}{$dayofmonth}{'discount_in'} || $holidays{$tariff}{$dayofmonth}{'discount_out'}) {
				$cost_in = $prices{$group}{$price}{'cost_in'} - ($prices{$group}{$price}{'cost_in'} / 100 * $holidays{$tariff}{$dayofmonth}{'discount_in'});
				$cost_out = $prices{$group}{$price}{'cost_out'} - ($prices{$group}{$price}{'cost_out'} / 100 * $holidays{$tariff}{$dayofmonth}{'discount_out'});
			} else {
				if ($holidays{$tariff}{$dayofweek}{'discount_in'} || $holidays{$tariff}{$dayofweek}{'discount_out'}) {
					$cost_in = $prices{$group}{$price}{'cost_in'} - ($prices{$group}{$price}{'cost_in'} / 100 * $holidays{$tariff}{$dayofweek}{'discount_in'});
					$cost_out = $prices{$group}{$price}{'cost_out'} - ($prices{$group}{$price}{'cost_out'} / 100 * $holidays{$tariff}{$dayofweek}{'discount_out'});
				} else {
					$cost_in = $prices{$group}{$price}{'cost_in'};
					$cost_out = $prices{$group}{$price}{'cost_out'};
				}
			}
			return ('in' => $cost_in, 'out' => $cost_out, 'prepaid' => $prices{$group}{$price}{'prepaid'});
		}
	}
	return 0;
}

sub get_routes {
	our $DBH;
	my %routes;
	my $STH = $DBH->prepare("select routes_groups.id_tariff, routes_groups.prio, routes_groups.id, routes.id, routes.net, routes.mask, routes.ip_first, routes.ip_last, routes.dest_type from routes inner join routes_groups on routes.id_group=routes_groups.id order by routes_groups.prio");
	$STH->execute;
	while (@tmp = $STH->fetchrow_array()) {
		%{$routes{$tmp[0]}{$tmp[1]}{$tmp[2]}{$tmp[3]}} = (
			'net'		=> $tmp[4],
			'mask'		=> $tmp[5],
			'ip_first'	=> $tmp[6],
			'ip_last'	=> $tmp[7],
			'dest_type'	=> $tmp[8]
		);
	}
	$STH->finish;
	return %routes;
}

sub get_holidays {
	our $DBH;
	my %holidays = ();
	my $STH = $DBH->prepare("select id_tariff, day, discount_in, discount_out from holidays order by id_tariff");
	$STH->execute;
	while (@tmp = $STH->fetchrow_array()) {
		%{$holidays{$tmp[0]}{$tmp[1]}} = (
			'discount_in'	=> $tmp[2],
			'discount_out'	=> $tmp[3]
		);
	}
	$STH->finish;
	return %holidays;
}

sub get_prices {
	our $DBH;
	my %prices = ();
	my $STH = $DBH->prepare("select id_group, id, time_from, time_to, cost_in, cost_out, prepaid from timers order by id_group, time_from");
	$STH->execute;
	while (@tmp = $STH->fetchrow_array()) {
		%{$prices{$tmp[0]}{$tmp[1]}} = (
			'time_from'	=> $tmp[2],
			'time_to'	=> $tmp[3],
			'cost_in'	=> $tmp[4],
			'cost_out'	=> $tmp[5],
			'prepaid'	=> $tmp[6]
		);
	}
	$STH->finish;
	return %prices;
}

sub kill_session {
	our $DBH, $config;

	my $kill = $config{'kill'};

	if ($_[0] =~ m/^\d+$/) {
		my $STH = $DBH->prepare("select iface from sessions where id_user='$_[0]'");
		$STH->execute;
		($iface) = $STH->fetchrow_array();
		$STH->finish;
		undef($STH);
	} else {
		if ($_[0] =~ m/^ppp\d{1,3}$/) {
			$iface = $_[0];
		}
	}

	if ($iface) {
		system("$kill `/bin/cat /var/run/$iface.pid`");
	}
}

sub kill_all_sessions {
	our $DBH, $config;

	my $kill = $config{'kill'};

	my $STH = $DBH->prepare("select iface from sessions");
        $STH->execute;
        while (($iface) = $STH->fetchrow_array()) {
		system("$kill `/bin/cat /var/run/$iface.pid`");
        }
        $STH->finish;
}

sub clear_all_sessions {
	our $DBH, $config;

	my $STH = $DBH->prepare("select id_user from sessions");
	$STH->execute;
	while (($id_user) = $STH->fetchrow_array()) {
		my $STHH = $DBH->prepare("select addr from users where id='$id_user'");
		$STHH->execute;
		while (($addr) = $STHH->fetchrow_array()) {
			$addr = inet_ntoa($addr);
			disable_nat($addr);
		}
		$STHH->finish;
	}
	$STH->finish;

	my $STH = $DBH->prepare("select id_user from sessions_nat");
	$STH->execute;
	while (($id_user) = $STH->fetchrow_array()) {
		my $STHH = $DBH->prepare("select eth_ip from users where id='$id_user'");
		$STHH->execute;
		while (($addr) = $STHH->fetchrow_array()) {
			$addr = inet_ntoa($addr);
			disable_nat($addr);
		}
		$STHH->finish;
	}
	$STH->finish;

}

sub unclear_all_sessions {
        our $DBH, $config;
        my $STH = $DBH->prepare("select id_user from sessions");
        $STH->execute;
        while (($id_user) = $STH->fetchrow_array()) {
                my $STHH = $DBH->prepare("select addr from users where id='$id_user'");
                $STHH->execute;
                while (($addr) = $STHH->fetchrow_array()) {
			$addr = inet_ntoa($addr);
                        enable_nat($addr);
                }
                $STHH->finish;
        }
        $STH->finish;

        my $STH = $DBH->prepare("select id_user from sessions_nat");
        $STH->execute;
        while (($id_user) = $STH->fetchrow_array()) {
                my $STHH = $DBH->prepare("select eth_ip from users where id='$id_user'");
                $STHH->execute;
                while (($addr) = $STHH->fetchrow_array()) {
			$addr = inet_ntoa($addr);
                        enable_nat($addr);
                }
                $STHH->finish;
        }
        $STH->finish;
}

sub enable_nat {
	our $DBH, $config;

	my $ipt = $config{'iptables'};
	my $ip = $config{'ip'};
	my $addr = $_[0]; $addr =~ s/\./\\\./g;
	my $addr_aton = inet_aton($addr);

	my $STH = $DBH->prepare("select nat from configs_ppp where used='1'");
	$STH->execute;
	($nat_type) = $STH->fetchrow_array();
	$STH->finish;
	undef($STH);

	my $STH = $DBH->prepare("select id_tariff from users where addr='$addr_aton' or eth_ip='$addr_aton'");
	$STH->execute;
	($id_tariff) = $STH->fetchrow_array();
	$STH->finish;
	undef($STH);

        my $STH = $DBH->prepare("select id from users where addr='$addr_aton' or eth_ip='$addr_aton'");
        $STH->execute;
        ($id_user) = $STH->fetchrow_array();
        $STH->finish;
        undef($STH);

	my $STH = $DBH->prepare("select route from tariffs where id='$id_tariff'");
	$STH->execute;
	($route) = $STH->fetchrow_array();
	$STH->finish;
	undef($STH);

	my $STH = $DBH->prepare("select name from configs_route where id='$route'");
	$STH->execute;
	($name_route) = $STH->fetchrow_array();
	$STH->finish;
	undef($STH);

	my @traff_arr=`$ipt -t nat -n -L POSTROUTING`;

	shift @traff_arr;
	shift @traff_arr;

	$tmp = 0;
	foreach my $traff (@traff_arr) {
		@clr_arr = &split_words($traff);
		if ($clr_arr[3] eq "$_[0]") {
			$tmp++;
		}
	}

	if (!$tmp) {
		if ($nat_type eq "MASQUERADE") {
			system("$ipt -t nat -D POSTROUTING -s $_[0] -j MASQUERADE");
			system("$ipt -t nat -A POSTROUTING -s $_[0] -j MASQUERADE");
		}
		if ($nat_type eq "IPROUTE") {
			system("$ipt -t nat -D POSTROUTING -s $_[0] -j MASQUERADE");
			system("$ip rule del from $_[0]");
			system("$ipt -t nat -A POSTROUTING -s $_[0] -j MASQUERADE");
			system("$ip rule add from $_[0] pref 1 table $name_route");
		}
	} else {
		if ($nat_type eq "MASQUERADE") {
			system("$ipt -t nat -D POSTROUTING -s $_[0] -j MASQUERADE");
			system("$ipt -t nat -A POSTROUTING -s $_[0] -j MASQUERADE");
		}
		if ($nat_type eq "IPROUTE") {
			system("$ipt -t nat -D POSTROUTING -s $_[0] -j MASQUERADE");
			system("$ip rule del from $_[0]");
			system("$ipt -t nat -A POSTROUTING -s $_[0] -j MASQUERADE");
			system("$ip rule add from $_[0] pref 1 table $name_route");
		}
	}

        my $STH = $DBH->prepare("select id from sessions_nat where addr='$addr_aton'");
        $STH->execute;
        ($test) = $STH->fetchrow_array();
        $STH->finish;
        undef($STH);

	if (!$test) {
		$DBH->do("insert into sessions_nat (id_user, addr, connected) values('$id_user', '$addr_aton', '". time() ."')");
	}

}

sub disable_nat {
	our $DBH, $config;

	my $ipt = $config{'iptables'};
	my $ip = $config{'ip'};
	my $addr = $_[0]; $addr =~ s/\./\\\./g;

	system("$ipt -t nat -D POSTROUTING -s $_[0] -j MASQUERADE");
	system("$ip rule del from $_[0]");
}

sub build_all_shapers {
	our $DBH, $config;

	my $tc = $config{'tc'};
	my %zones = ();
	my $hour = (localtime)[2];

	my $STH = $DBH->prepare("select tariffs.id, routes_groups.id from routes_groups, tariffs where routes_groups.id_tariff=tariffs.id");
	$STH->execute;
	while (($id_tariff, $id_group) = $STH->fetchrow_array()) {
		my $ST = $DBH->prepare("select speed from timers where id_group='$id_group' and time_from<='$hour' and time_to>='$hour'");
		$ST->execute;
		while (($speed) = $ST->fetchrow_array()) {
                        $zones{$id_tariff}{$id_group} = $speed;
		}
		$ST->finish;
	}
	$STH->finish;

	$STH = $DBH->prepare("select sessions.id_user, sessions.iface, users.id_tariff from sessions, users where id_user=users.id");
	$STH->execute;
	while (($id_user, $iface, $id_tariff) = $STH->fetchrow_array()) {
		system("$tc qdisc del dev $iface root");
		system("$tc qdisc add dev $iface root handle 1: htb");
		for $id_group (keys %{$zones{$id_tariff}}) {
			$speed = $zones{$id_tariff}{$id_group};

			if ($speed =~ m/^\d{1,9}-\d{1,9}$/) {
				$STH_ = $DBH->prepare("select count(*) from sessions, users where sessions.id_user=users.id and users.id_tariff='$id_tariff'");
				$STH_->execute;
				($count) = $STH_->fetchrow_array();
				$STH_->finish;
				($speed_min, $speed_max) = split('-', $speed);
				if (floor($speed_max / $count) >= $speed_min) {
					$speed = floor($speed_max / $count);
				} else {
					$speed = $speed_min;
				}
			}
			system("$tc class add dev $iface classid 1:$id_group htb rate ${speed}kbit ceil ${speed}kbit");
			system("$tc filter add dev $iface protocol ip handle $id_group fw classid 1:$id_group");
		}
	}
	$STH->finish;
}

sub build_user_shapers {
	our $DBH, $config;

	my $tc = $config{'tc'};
	my %zones = ();
	my $id_user = $_[0];
	my $hour = (localtime)[2];

	my $STH = $DBH->prepare("select routes_groups.id from routes_groups, tariffs inner join users on tariffs.id=users.id_tariff where routes_groups.id_tariff=tariffs.id and users.id='$id_user'");
	$STH->execute;
	while (($id_group) = $STH->fetchrow_array()) {
                my $ST = $DBH->prepare("select speed from timers where id_group='$id_group' and time_from<='$hour' and time_to>='$hour'");
                $ST->execute;
                while (($speed) = $ST->fetchrow_array()) {
			if ($speed =~ m/^\d{1,9}-\d{1,9}$/) {
				build_all_shapers();
				$STH->finish;
				return 0;
			}
			$zones{$id_group} = $speed;
		}
		$ST->finish;
	}
	$STH->finish;

	$STH = $DBH->prepare("select sessions.iface from sessions where id_user='$id_user'");
	$STH->execute;
	($iface) = $STH->fetchrow_array();
	if ($iface) {
		system("$tc qdisc del dev $iface root");
		system("$tc qdisc add dev $iface root handle 1: htb");
		for $id_group (keys %zones) {
			$speed = $zones{$id_group};
			system("$tc class add dev $iface classid 1:$id_group htb rate ${speed}kbit ceil ${speed}kbit");
			system("$tc filter add dev $iface protocol ip handle $id_group fw classid 1:$id_group");
		}
	}
	$STH->finish;
}

sub argton {
	my $arg = shift;
	my $netmask_flag = shift;

	my $i = 24;
	my $n = 0;

	if ($arg =~ /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/) {
		my @decimals = ($1,$2,$3,$4);
		foreach (@decimals) {
			if ($_ > 255 || $_ < 0) {
				return -1;
			}
			$n += $_ << $i;
			$i -= 8;
		}
		if ($netmask_flag) {
			return validate_netmask($n);
		}
		return $n;
	}

	if ($arg =~ /^\d{1,2}$/) {
		if ($arg < 1 || $arg > 32) {
			return -1;
		}
		for ($i=0;$i<$arg;$i++) {
			$n |= 1 << (31-$i);
		}
		return $n;
	}

	return -1;
}

sub check_debtors {
	our $DBH;
	my $STH = $DBH->prepare("select users.id, users.blocked, users.login, users.pass, inet_ntoa(users.addr), inet_ntoa(users.eth_ip), users.id_tariff, users_accounts.deposit, users_accounts.max_credit, users_groups.blocked, users.nat from users, users_accounts, users_groups where users.id_account = users_accounts.id and users_accounts.id_group = users_groups.id");
	$STH->execute;
	while (($id_user, $user_blocked, $login, $pass, $addr, $eth_ip, $id_tariff, $deposit, $max_credit, $blocked, $nat) = $STH->fetchrow_array()) {
		if ($blocked || ($max_credit+$deposit)<=0 || $user_blocked) {
			if (!$nat) {
				kill_session($id_user);
			} else {
				disable_nat($eth_ip);
			}
		} else {
			if ($nat) {
				my $STHM = $DBH->prepare("select id from sessions_nat where id_used='$id_user'");
				$STHM->execute;
				($id) = $STHM->fetchrow_array();
				$STHM->finish;
				undef($STHM);
				if (!$id) {
					enable_nat($eth_ip);
				}
			}
		}
	}
	$STH->finish;
}

sub check_nat {
	our $DBH;
        my $STH = $DBH->prepare("select id_user from sessions_nat");
        $STH->execute;
        while (($id_user) = $STH->fetchrow_array()) {
		my $STHM = $DBH->prepare("select nat, inet_ntoa(eth_ip) from users where id='$id_user'");
	        $STHM->execute;
	        while (($nat, $eth_ip) = $STHM->fetchrow_array()) {
			if (!$nat) {
                                disable_nat($eth_ip);
			}
		}
		$STHM->finish;
	}
        $STH->finish;
}

sub build_all_routes {
	our $DBH, $config;
	my $ip = $config{'ip'};

	my $STH = $DBH->prepare("select name, ip, dev from configs_route");
	$STH->execute;
	while (($name, $ip_route, $dev) = $STH->fetchrow_array()) {
		$ip_route = inet_ntoa($ip_route);
		system("$ip route del default table $name");
		system("$ip route add default via $ip_route dev $dev table $name");
	}
	$STH->finish;
}

sub build_configs_iproute {
	our $DBH, $config;
	my $route_conf = $config{'route_conf'};

	open(route,"> $route_conf");
	flock(route,2);

	print(route "255	local\n");
	print(route "254	main\n");
	print(route "253	default\n");

	$STH_GLOBAL = $DBH->prepare("select id, name from configs_route");
	$STH_GLOBAL->execute;
	while (($id, $name) = $STH_GLOBAL->fetchrow_array()) {
		print(route "$id	$name\n");
	}
	$STH_GLOBAL->finish;
	print(route "0	unspec\n");

	close(route);

#	build_all_routes();
}

sub build_configs_ipsent {
	our $DBH, $config;

	system("$config{'ip-sentinel_stop'}");

	$STH_ETH = $DBH->prepare("select id, interface from configs_dhcpd");
        $STH_ETH->execute;
	while (($id_subnet, $interface) = $STH_ETH->fetchrow_array()) {
		my $path = "$config{'ip-sentinel_conf'}.$interface.conf";
		open(ipsent,"> $path");
	        flock(ipsent,2);
		print(ipsent "0.0.0.0/0              #  Блокируем всех нам не известных\n");

		$STH_BLOCKED = $DBH->prepare("select id, mac from blocked_mac");
	        $STH_BLOCKED->execute;
	        while (($id, $mac) = $STH_BLOCKED->fetchrow_array()) {
			$mac = uc $mac;
        	        print(ipsent "*\@$mac              #  Запретить $id из базы\n");
		}
	        $STH_BLOCKED->finish;

		$STH_BLOCK = $DBH->prepare("select login, eth_mac from users where blocked=1 and subnet_id='$id_subnet'");
	        $STH_BLOCK->execute;
		while (($login, $mac) = $STH_BLOCK->fetchrow_array()) {
			$mac = uc $mac;
			print(ipsent "*\@$mac              #  Запретить $login, блокирован счет\n");
		}
		$STH_BLOCK->finish;

	        $STH_USERS = $DBH->prepare("select login, eth_ip, eth_mac from users where blocked=0 and subnet_id='$id_subnet'");
        	$STH_USERS->execute;
	        while (($login, $ip, $mac) = $STH_USERS->fetchrow_array()) {
        	        $ip = inet_ntoa($ip);
                	$mac = uc $mac;
	                print(ipsent "$ip\@!$mac              #  Разрешить $login\n");
        	}
	        $STH_USERS->finish;

		close(ipsent);
		system("$config{'ip-sentinel'} --ipfile /etc/ip-sentinel.$interface.conf --user $config{'ip-sentinel_user'} --group $config{'ip-sentinel_group'} -r / $interface");

	}
	$STH_ETH->finish;
}

sub build_configs_dhcpd {
	our $DBH, $config;
	my $path = $config{'dhcpd_conf'};

	open(dhcpd,"> $path");
	flock(dhcpd,2);

	print(dhcpd "# Global Options\n\n");

	$STH_GLOBAL = $DBH->prepare("select options from configs_dhcpd_global");
	$STH_GLOBAL->execute;
	while (($options) = $STH_GLOBAL->fetchrow_array()) {
		print(dhcpd "$options;\n");
	}
	$STH_GLOBAL->finish;
	print(dhcpd "\n");

	$STH_SUBNETS = $DBH->prepare("select * from configs_dhcpd order by id asc");
	$STH_SUBNETS->execute;
	while (($id, $name, $interface, $network, $gateway, $dns1, $dns2, $nbios1, $nbios2, $time, $ntp, $domain) = $STH_SUBNETS->fetchrow_array()) {
		my $STH = $DBH->prepare("select net, mask from configs_ip where id='$network'");
		$STH->execute;
		($net, $mask) = $STH->fetchrow_array();
		$STH->finish;
		undef($STH);
		$net = inet_ntoa($net);
		my $thirtytwobits = 4294967295;
		my $mask = argton($mask);
		my $address = argton($net);
		my $network = $address & $mask;
		my $broadcast = $network | ((~$mask) & $thirtytwobits);
		$mask = inet_ntoa($mask);
		$hmax = $broadcast - 1;
		$broadcast = inet_ntoa($broadcast);
		my $hmin  = $network + 1;
		print(dhcpd "# $interface - $net\n");
		print(dhcpd "subnet $net netmask $mask {\n");
		print(dhcpd "       option subnet-mask $mask;\n");
		print(dhcpd "       option broadcast-address $broadcast;\n");
		print(dhcpd "       option routers $gateway;\n");
		if ((!$dns1) && (!$dns2)) {
			print(dhcpd "\n");
		}
		if (($dns1) && (!$dns2)) {
			print(dhcpd "       option domain-name-servers $dns1;\n");
		}
		if (($dns1) && ($dns2)) {
			print(dhcpd "       option domain-name-servers $dns1, $dns2;\n");
		}
		if ((!$nbios1) && (!$nbios2)) {
			print(dhcpd "\n");
		}
		if (($nbios1) && (!$nbios2)) {
			print(dhcpd "       option netbios-node-type 8;\n");
			print(dhcpd "       option netbios-name-servers $nbios1;\n");
		}
		if (($nbios1) && ($nbios2)) {
			print(dhcpd "       option netbios-node-type 8;\n");
			print(dhcpd "       option netbios-name-servers $nbios1, $nbios2;\n");
		}
		if ($time) {
			print(dhcpd "       option time-servers $time;\n");
		}
		if ($ntp) {
			print(dhcpd "       option ntp-servers $ntp;\n\n");
		}
		$STH_USERS = $DBH->prepare("select login, inet_ntoa(eth_ip) as \"ip\", eth_mac from users where eth_ip>'$hmin' and eth_ip<'$hmax' order by id asc");
		$STH_USERS->execute;
		while (($login, $ip, $mac) = $STH_USERS->fetchrow_array()) {
			$mac = uc $mac;
			print(dhcpd "       host $login.$domain {\n");
			print(dhcpd "              hardware ethernet $mac;\n");
			print(dhcpd "              fixed-address $ip;\n");
			print(dhcpd "       }\n\n");
		}
		$STH_USERS->finish;
		print(dhcpd "}\n\n");
	}
	$STH_SUBNETS->finish;

	close(dhcpd);
#	system("$config{'dhcpd_restart'}");
}

sub build_configs_ppp {
	our $DBH, $config;
	my $ppp_conf = $config{'ppp_conf'};

	open(ppp,"> $ppp_conf");
	flock(ppp,2);

	$STH_GLOBAL = $DBH->prepare("select mppe, dns_one, dns_two, radius from configs_ppp where used=1");
	$STH_GLOBAL->execute;
	while (($mppe, $dns_one, $dns_two, $radius) = $STH_GLOBAL->fetchrow_array()) {
		$dns_one = inet_ntoa($dns_one);
		$dns_two = inet_ntoa($dns_two);
		print(ppp "name pptpd\n");
		print(ppp "lock\n");
		print(ppp "refuse-pap\n");
		print(ppp "refuse-chap\n");
		print(ppp "refuse-mschap\n");
		print(ppp "require-mschap-v2\n");
		if ($mppe == 1) {
			print(ppp "mppe required\n");
		}
		if ($mppe == 0) {
			print(ppp "nomppe\n");
		}
		if ($dns_one) {
			print(ppp "ms-dns $dns_one\n");
		}
		if ($dns_two and $dns_two != $dns_one and $dns_two != "0.0.0.0") {
			print(ppp "ms-dns $dns_two\n");
		}
		if ($radius == 1) {
			print(ppp "plugin radius.so\n");
		}
	}
	$STH_GLOBAL->finish;

	close(ppp);
	system("$config{'pptpd_restart'}");
}

sub build_configs_pptpd {
	our $DBH, $config;
	my $i = 1;
	my $pptpd_conf = $config{'pptpd_conf'};
	my $ppp_conf = $config{'ppp_conf'};
	my $connections = 0;

	open(pptp,"> $pptpd_conf");
	flock(pptp,2);

	$STH_ = $DBH->prepare("select count(*) from configs_ip where nat=0");
	$STH_->execute;
	($count) = $STH_->fetchrow_array();
	$STH_->finish;

	print(pptp "option $ppp_conf\n");
	print(pptp "remoteip ");

	$STH_GLOBAL = $DBH->prepare("select net, mask from configs_ip where nat=0 order by mask desc");
	$STH_GLOBAL->execute;

	while (($net, $mask) = $STH_GLOBAL->fetchrow_array()) {

		$net = inet_ntoa($net);
		my $thirtytwobits = 4294967295;
		my $mask = argton($mask);
		my $address = argton($net);
		my $network = $address & $mask;
		my $broadcast = $network | ((~$mask) & $thirtytwobits);
		my $hmin  = $network + 1;
		my $hmax  = $broadcast - 1;
		$connections = $connections + ($hmax - $hmin);
		$hmin = inet_ntoa($hmin);
		$hmax = inet_ntoa($hmax);
		($a,$b,$c,$d)=split(/\./,$hmin);
		($aa,$bb,$cc,$dd)=split(/\./,$hmax);

		$aaa = $aa - $a;
		$bbb = $bb - $b;
		$ccc = $cc - $c;
		$ddd = $aaa + $bbb + $ccc;
		$eee = 0;
		$connections = $connections - (2 * $ddd);

		for($z = 0; $z <= $aaa; $z++) {
			for($x = 0; $x <= $bbb; $x++) {
				for($v = 0; $v <= $ccc; $v++) {
					$t = $a+$z;
					$tt = $b+$x;
					$ttt = $c+$v;
					if ($ddd == 0) {
						$dddd = $d+1;
						if ($count >= 2) {
							if ($i == 1) {
								print(pptp "$t.$tt.$ttt.$dddd-$dd,");
							}
							if ($i >= 2) {
								if ($i == $count) {
									print(pptp "$t.$tt.$ttt.$dddd-$dd\n");
								} else {
									print(pptp "$t.$tt.$ttt.$dddd-$dd,");
								}
							}
						}
						if ($count == 1) {
							print(pptp "$t.$tt.$ttt.$dddd-$dd\n");
						}
					} else {
						if ($ddd == $eee) {
							print(pptp "$t.$tt.$ttt.$d-$dd\n");
						} else {
							if ($eee == 0) {
								$dddd = $d+1;
								print(pptp "$t.$tt.$ttt.$dddd-$dd,");
							} else {
								print(pptp "$t.$tt.$ttt.$d-$dd,");
							}
						}
					}
					$eee++;
				}
			}
		}
		$i++;
	}
	$STH_GLOBAL->finish;

	$STH_GLOBAL = $DBH->prepare("select net, mask from configs_ip where nat=0");
	$STH_GLOBAL->execute;

	while (($net, $mask) = $STH_GLOBAL->fetchrow_array()) {
		if ($count == 1) {
			$net = inet_ntoa($net);
			my $thirtytwobits = 4294967295;
			my $mask = argton($mask);
			my $address = argton($net);
			my $network = $address & $mask;
			my $broadcast = $network | ((~$mask) & $thirtytwobits);
			my $hmin  = $network + 1;
			my $hmax  = $broadcast - 1;
			$hmin = inet_ntoa($hmin);
			($a,$b,$c,$d)=split(/\./,$hmin);
		}
		if ($count >= 2) {
			$net = inet_ntoa($net);
			my $thirtytwobits = 4294967295;
			my $mask = argton($mask);
			my $address = argton($net);
			my $network = $address & $mask;
			my $broadcast = $network | ((~$mask) & $thirtytwobits);
			my $hmin  = $network + 1;
			my $hmax  = $broadcast - 1;
			$hmin = inet_ntoa($hmin);
			if ($small > $hmin) {
				$small = $hmin;
				($a,$b,$c,$d)=split(/\./,$hmin);
			}
		}
	}
	$STH_GLOBAL->finish;
	print(pptp "localip $a.$b.$c.$d\n");
	print(pptp "connections $connections\n");
	close(pptp);

	system("$config{'pptpd_restart'}");
}

sub build_configs_ipcad {
	our $DBH, $config;
	open(ipcad,"> $config{'ipcad_conf'}");
	flock(ipcad,2);
	my $STH = $DBH->prepare("select detailed from configs_ppp where used='1'");
	$STH->execute;
	($detailed) = $STH->fetchrow_array();
	$STH->finish;
	undef($STH);
	if ($detailed){
		print(ipcad "capture-ports enable;\n");
	} else {
		print(ipcad "capture-ports disable;\n");
	}
	print(ipcad "buffers = 64k;\n");
	print(ipcad "interface ppp*;\n");
	$STH_GLOBAL = $DBH->prepare("select interface from configs_dhcpd");
	$STH_GLOBAL->execute;
	while (($interface) = $STH_GLOBAL->fetchrow_array()) {
		print(ipcad "interface $interface;\n");
	}
	$STH_GLOBAL->finish;

	$STH_GLOBAL = $DBH->prepare("select net, mask from configs_ip");
	$STH_GLOBAL->execute;
	while (($net, $mask) = $STH_GLOBAL->fetchrow_array()) {
		$net = inet_ntoa($net);
		print(ipcad "aggregate $net/$mask strip 32;\n");
	}
	$STH_GLOBAL->finish;
	print(ipcad "netflow export destination 127.0.0.1 9996;\n");
	print(ipcad "netflow export version 5;\n");
	print(ipcad "netflow timeout active 1;\n");
	print(ipcad "netflow timeout inactive 1;\n");
	print(ipcad "netflow engine-type 73;\n");
	print(ipcad "netflow engine-id 1;\n");
	print(ipcad "netflow ifclass ppp mapto 100-199;\n");
	print(ipcad "dumpfile = ipcad.dump;\n");
	print(ipcad "chroot = /var/ipcad;\n");
	print(ipcad "pidfile = /run/ipcad.pid;\n");
	print(ipcad "memory_limit = 10m;\n");

	close(ipcad);

	system("$config{'ipcad_restart'}");
}

sub Reconnect {
	our $DBH, $config;
	my $time = time();
	my $conditional = shift || 0;
	my %dsn_arr = ( mysql => "DBI:mysql:${config{db_name}}:${config{db_host}}", pgsql => "DBI:Pg:dbname=${config{db_name}};host=${config{db_host}}" );
	if ($conditional) {
		return 1 if ($DBH->ping);
	};
	eval {
		$DBH->disconnect() if (defined($DBH));
	};
	$DBH = 0;
	$DBH = DBI->connect($dsn_arr{$config{'db_driver'}}, $config{'db_user'}, $config{'db_pass'});
	unless (defined($DBH) && $DBH) {
		logging("subbilling","Reconnect occured");
		return 0;
	};
	logging("subilling","Connect to DataBase ok!");
	return 1;
};

sub split_words {
	my $entry = shift @_;
	my @res = split(" ", $entry);
	return @res;
}

sub logging {
	 my ($proc_name, $msg) = @_;
	 ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time());
	 $mon++;
	 $year += 1900;
	 $log_time = sprintf ("%.2ld/%.2ld/$year %.2ld:%.2ld:%.2ld",$mday,$mon,$hour,$min,$sec);
	 my $fp = $config{'logs_dir'}."/".$config{'log'};
	 if (open(FILE, ">>$fp")) {
		  print FILE ("$log_time $proc_name: $msg\n");
		  close FILE;
	 }
}

sub usage {
    print "Please usage: start || stop\n";
}

sub periodic {
	our $DBH;
	$now = time();
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);

	$STH_PERIODIC = $DBH->prepare("select id, period, payment, p_in, p_out from tariffs where (payment>0 or p_in>0 or p_out>0) and period>0");
	$STH_PERIODIC->execute;
	while (($id_tariff, $period, $payment, $p_in, $p_out) = $STH_PERIODIC->fetchrow_array()) {
		$STH_USERS = $DBH->prepare("select users.id, users.id_tariff, users.id_next, users_accounts.id_group, users_accounts.deposit, users_accounts.max_credit, users.blocked, users_accounts.id from users, users_accounts where (users.id_tariff='$id_tariff' or users.id_next='$id_tariff') and ('$now'-last_period)>'$period' and users.id_account = users_accounts.id");
		$STH_USERS->execute;
		while (($id_user, $id_current, $id_next, $id_group, $deposit, $max_credit, $blocked, $acc_id) = $STH_USERS->fetchrow_array()) {
			if ($deposit+$max_credit < $payment) {
				if ($blocked == 0) {
					$DBH->do("update users set blocked=1 where id='$id_user'");
					build_configs_ipsent();
				}
			} else {
				if ($blocked == 1) {
					if ($id_current != $id_next) {
						$sql_set = ", id_tariff=id_next";
					}
					$DBH->do("update users_accounts set deposit=deposit-$payment where id='$acc_id'");
					$DBH->do("update users set p_in=p_in+'$p_in', p_out=p_out+'$p_out', last_period='$now', blocked='0' $sql_set where id='$id_user'");
					if ($payment) {
						$DBH->do("insert into payments (id_user, pay_value, pay_time, action) values('$id_user', '$payment', '$now', '2')");
					}
					build_configs_ipsent();
				}
				if ($blocked == 0) {
					if ($id_current != $id_next) {
						$sql_set = ", id_tariff=id_next";
					}
					$DBH->do("update users_accounts set deposit=deposit-$payment where id='$acc_id'");
					$DBH->do("update users set p_in=p_in+'$p_in', p_out=p_out+'$p_out', last_period='$now' $sql_set where id='$id_user'");
					if ($payment) {
						$DBH->do("insert into payments (id_user, pay_value, pay_time, action) values('$id_user', '$payment', '$now', '2')");
					}
				}
			}
		}
		$STH_USERS->finish;
	}
	$STH_PERIODIC->finish;

	$STH_ONDATE = $DBH->prepare("select id, payment, p_in, p_out from tariffs where (payment>0 or p_in>0 or p_out>0) and period=0");
	$STH_ONDATE->execute;
	while (($id_tariff, $payment, $p_in, $p_out) = $STH_ONDATE->fetchrow_array()) {
		$STH_USERS = $DBH->prepare("select users.id, users.id_tariff, users.id_next, users_accounts.id_group, users_accounts.deposit, users_accounts.max_credit, users.last_period, users.blocked, users_accounts.id from users, users_accounts where (id_tariff='$id_tariff' or id_next='$id_tariff') and users.id_account = users_accounts.id");
		$STH_USERS->execute;
		while (($id_user, $id_current, $id_next, $id_group, $deposit, $max_credit, $last_period, $blocked, $acc_id) = $STH_USERS->fetchrow_array()) {
			if ($last_period != $mon) {
				if ($deposit+$max_credit < $payment) {
					if ($blocked == 0) {
						$DBH->do("update users set blocked=1 where id='$id_user'");
						build_configs_ipsent();
					}
				} else {
					if ($blocked == 1) {
						if ($id_current != $id_next) {
							$sql_set = ", id_tariff=id_next";
						}
						$DBH->do("update users_accounts set deposit=deposit-$payment where id='$acc_id'");
						$DBH->do("update users set p_in=p_in+'$p_in', p_out=p_out+'$p_out', last_period='$mon', blocked='0' $sql_set where id='$id_user'");
						if ($payment) {
							$DBH->do("insert into payments (id_user, pay_value, pay_time, action) values('$id_user', '$payment', '$now', '2')");
						}
						build_configs_ipsent();
					}
					if ($blocked == 0) {
						if ($id_current != $id_next) {
							$sql_set = ", id_tariff=id_next";
						}
						$DBH->do("update users_accounts set deposit=deposit-$payment where id='$acc_id'");
						$DBH->do("update users set p_in=p_in+'$p_in', p_out=p_out+'$p_out', last_period='$mon' $sql_set where id='$id_user'");
						if ($payment) {
							$DBH->do("insert into payments (id_user, pay_value, pay_time, action) values('$id_user', '$payment', '$now', '2')");
						}
					}
				}
			}
		}
		$STH_USERS->finish;
	}
	$STH_ONDATE->finish;
}

sub test_configs {
	our $DBH, $config;

	my $STH = $DBH->prepare("select changed from configs_dhcpd where changed='1'");
	$STH->execute;
	($changed) = $STH->fetchrow_array();
	$STH->finish;
	undef($STH);

	if ($changed) {
#		clear_all_sessions();
#		system("$config{'pptpd_stop'}");
#		system("$config{'ip-sentinel_stop'}");
#		build_configs_dhcpd();
#		build_configs_ipcad();
#		build_configs_ipsent();
#		system("$config{'pptpd_start'}");
		$query = "update configs_dhcpd set changed='0'";
		$DBH->do(qq($query));
#		unclear_all_sessions();
	}

	my $STH = $DBH->prepare("select changed from configs_ip where changed='1'");
	$STH->execute;
	($changed) = $STH->fetchrow_array();
	$STH->finish;
	undef($STH);

	if ($changed) {
#		kill_all_sessions();
#		build_configs_pptpd();
#		build_configs_ipsent();
#		build_configs_dhcpd();
#		build_configs_ipcad();
		$query = "update configs_ip set changed='0'";
		$DBH->do(qq($query));
	}

	my $STH = $DBH->prepare("select changed from configs_ppp where changed='1'");
	$STH->execute;
	($changed) = $STH->fetchrow_array();
	$STH->finish;
	undef($STH);

	if ($changed) {
		kill_all_sessions();
		build_configs_ppp();
		$query = "update configs_ppp set changed='0'";
		$DBH->do(qq($query));
	}

	my $STH = $DBH->prepare("select changed from configs_route where changed='1'");
	$STH->execute;
	($changed) = $STH->fetchrow_array();
	$STH->finish;
	undef($STH);

	if ($changed) {
		clear_all_sessions();
		build_configs_iproute();
		build_all_routes();
		$query = "update configs_route set changed='0'";
		$DBH->do(qq($query));
		unclear_all_sessions();
	}
}

sub optimize_detailed {
	our $DBH, $config;
	my $STH = $DBH->prepare("select src, dst, uid, id_route, cost, port, byte_in, byte_out, proto from test");
	$STH->execute;
	while (@tmp = $STH->fetchrow_array()) {
		%{$sources{$tmp[0]}} = (
			'dst'		=> $tmp[1],
			'uid'		=> $tmp[2],
			'id_route'	=> $tmp[3],
			'cost'		=> $tmp[4],
			'port'		=> $tmp[5],
			'byte_in'	=> $tmp[6],
			'byte_out'	=> $tmp[7],
			'proto'		=> $tmp[8]
		);
	}
	$STH->finish;
	for $src (keys %sources) {
		if ($sources{$src}{'byte_out'} == 0) {
			$dest = 'Входящий';
			$byte = $sources{$src}{'byte_in'};
		} else {
			$dest = 'Исходящий';
			$byte = $sources{$src}{'byte_out'};
		}
		print $dest.": ".$src." ".$sources{$src}{'dst'}." ".$byte."\n";
	}
}

sub clear_detailed {
	our $DBH, $config;
	$del_time = time() - 86400;
	# Сохранение детализированной статистики в файл.
	my $STH = $DBH->prepare("select traff.uid, traff.time, traff.cost, traff.src, traff.dst, traff.port, traff.byte_in, traff.byte_out, traff.proto, users.login from traff, users where time<='$del_time' and traff.uid=users.id");
	$STH->execute;
	while (($uid, $time, $cost, $src, $dst, $port, $byte_in, $byte_out, $proto, $login) = $STH->fetchrow_array()) {
		($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($time);
		$year = 1900 + $year;
		$mon = 1 + $mon;
		if ($mon > 0 and $mon < 10) {
			$mon = "0$mon";
		}
		if ($mday > 0 and $mday < 10) {
			$mday = "0$mday";
		}
		if (!opendir(DIR, "$config{'distr_dir'}/detailed/$login")) {
			system("mkdir $config{'distr_dir'}/detailed/$login");
		}
		if (!opendir(DIR, "$config{'distr_dir'}/detailed/$login/$year")) {
			system("mkdir $config{'distr_dir'}/detailed/$login/$year");
		}
		if (!opendir(DIR, "$config{'distr_dir'}/detailed/$login/$year/$mon")) {
			system("mkdir $config{'distr_dir'}/detailed/$login/$year/$mon");
		}
		open(stats,">> $config{'distr_dir'}/detailed/$login/$year/$mon/$mday.cvs");
		flock(stats,2);
		if ($byte_in > 0) {
			print(stats "incoming\t$time\t$uid\t$login\t$dst\t$src\t$port\t$proto\t$cost\n");
		}
		if ($byte_out > 0) {
			print(stats "outgoing\t$time\t$uid\t$login\t$src\t$dst\t$port\t$proto\t$cost\n");
		}
		close(stats);
	}
	$STH->finish;
	# Удаление старой детализированной статистики.
	$query = "delete from traff where time<=$del_time";
	$DBH->do(qq($query));
}

sub clear_data {
	our $DBH, $config;
	($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
#	$days = Date_DaysInMonth($mon-1,$year+1900) + Date_DaysInMonth($mon-2,$year+1900) + $mday;
	$days = $mday;
	$del_time = time() - $days * 24 * 60 * 60;
	$del_time = $del_time + $hour * 60 * 60;

        # Сохранение статистики в другую таблицу.
	$query = "insert into data_old select * from data where log_time<='$del_time'";
	$DBH->do(qq($query));

        # Удаление старой статистики.
        $query = "delete from data where log_time<=$del_time";
        $DBH->do(qq($query));
}

sub firewall {
	our $DBH, $config;
	my $ipt = $config{'iptables'};

	#system("$ipt -F FORWARD");
	#system("$ipt -A FORWARD -s 10.0.1.0/24 -d 192.168.0.0/24 -j DROP");
	system("$ipt -t mangle -D FORWARD -j USERS");
	system("$ipt -t mangle -F USERS");
	system("$ipt -t mangle -X USERS");
	system("$ipt -t mangle -N USERS");
	system("$ipt -t mangle -A FORWARD -j USERS");

	$STH = $DBH->prepare("select id from tariffs");
	$STH->execute;
	while (($id_tariff) = $STH->fetchrow_array()) {
		system("$ipt -t mangle -F INC_TARIFF_$id_tariff");
		system("$ipt -t mangle -X INC_TARIFF_$id_tariff");
		system("$ipt -t mangle -N INC_TARIFF_$id_tariff");
		system("$ipt -t mangle -F OUT_TARIFF_$id_tariff");
		system("$ipt -t mangle -X OUT_TARIFF_$id_tariff");
		system("$ipt -t mangle -N OUT_TARIFF_$id_tariff");
	}
	$STH->finish;

	$STH = $DBH->prepare("select inet_ntoa(addr), inet_ntoa(eth_ip), id_tariff, nat from users");
	$STH->execute;
	while (($addr, $eth_ip, $id_tariff, $nat) = $STH->fetchrow_array()) {
		if ($nat) {
			system("$ipt -t mangle -A USERS -d $eth_ip -j INC_TARIFF_$id_tariff");
			system("$ipt -t mangle -A USERS -s $eth_ip -j OUT_TARIFF_$id_tariff");
		} else {
			system("$ipt -t mangle -A USERS -d $addr -j INC_TARIFF_$id_tariff");
			system("$ipt -t mangle -A USERS -s $addr -j OUT_TARIFF_$id_tariff");
		}
	}
	$STH->finish;

	$STH = $DBH->prepare("select routes.dest_type, inet_ntoa(routes.net), routes.mask, inet_ntoa(routes.ip_first), inet_ntoa(routes.ip_last), routes_groups.id, tariffs.id from routes, routes_groups, tariffs where (routes.id_group=routes_groups.id and routes_groups.id_tariff=tariffs.id) order by tariffs.id, routes_groups.prio desc");
	$STH->execute;
	while (($dest_type, $net, $mask, $ip_first, $ip_last, $id_group, $id_tariff) = $STH->fetchrow_array()) {
		if ($dest_type) {
			system("$ipt -t mangle -A INC_TARIFF_$id_tariff -m iprange --src-range $ip_first-$ip_last -j MARK --set-mark $id_group");
			system("$ipt -t mangle -A OUT_TARIFF_$id_tariff -m iprange --dst-range $ip_first-$ip_last -j MARK --set-mark $id_group");
		} else {
			system("$ipt -t mangle -A INC_TARIFF_$id_tariff -s $net/$mask -j MARK --set-mark $id_group");
			system("$ipt -t mangle -A OUT_TARIFF_$id_tariff -d $net/$mask -j MARK --set-mark $id_group");
		}
	}
	$STH->finish;

	$STH = $DBH->prepare("select inet_ntoa(blocked_ip.net), blocked_ip.mask, inet_ntoa(blocked_ip.ip), inet_ntoa(blocked_ip.ip_first), inet_ntoa(blocked_ip.ip_last), blocked_ip.port, blocked_ip.proto, blocked_ip.action, inet_ntoa(users.addr), inet_ntoa(users.eth_ip), users.nat from blocked_ip, users, users_groups, users_accounts where blocked_ip.uid = users.id or (blocked_ip.gid = users_groups.id and users_groups.id = users_accounts.id_group and users.id_account = users_accounts.id)");
	$STH->execute;
	while (($net, $mask, $ip, $ip_first, $ip_last, $port, $proto, $action, $addr, $eth_ip, $nat) = $STH->fetchrow_array()) {
		if ($net and $mask) {
			if ($nat) {
				if ($port and $proto) {
					if ($port=~m/\d+,\d+/) {
						system("$ipt -A FORWARD -s $eth_ip -d $net/$mask -p $proto -m multiport --destination-port $port -j $action");
					} else {
						system("$ipt -A FORWARD -s $eth_ip -d $net/$mask -p $proto --destination-port $port -j $action");
					}
				} else {
					system("$ipt -A FORWARD -s $eth_ip -d $net/$mask -j $action");
					system("$ipt -A FORWARD -s $net/$mask -d $eth_ip -j $action");
				}
			} else {
				if ($port and $proto) {
					if ($port=~m/\d+,\d+/) {
						system("$ipt -A FORWARD -s $addr -d $net/$mask -p $proto -m multiport --destination-port $port -j $action");
					} else {
						system("$ipt -A FORWARD -s $addr -d $net/$mask -p $proto --destination-port $port -j $action");
					}
				} else {
					system("$ipt -A FORWARD -s $addr -d $net/$mask -j $action");
					system("$ipt -A FORWARD -s $net/$mask -d $addr -j $action");
				}
			}
		}

		if ($ip) {
			if ($nat) {
				if ($port and $proto) {
					if ($port=~m/\d+,\d+/) {
						system("$ipt -A FORWARD -s $eth_ip -d $ip -p $proto -m multiport --destination-port $port -j $action");
					} else {
						system("$ipt -A FORWARD -s $eth_ip -d $ip -p $proto --destination-port $port -j $action");
					}
				} else {
					system("$ipt -A FORWARD -s $eth_ip -d $ip -j $action");
					system("$ipt -A FORWARD -s $ip -d $eth_ip -j $action");
				}
			} else {
				if ($port and $proto) {
					if ($port=~m/\d+,\d+/) {
						system("$ipt -A FORWARD -s $addr -d $ip -p $proto -m multiport --destination-port $port -j $action");
					} else {
						system("$ipt -A FORWARD -s $addr -d $ip -p $proto --destination-port $port -j $action");
					}
				} else {
					system("$ipt -A FORWARD -s $addr -d $ip -j $action");
					system("$ipt -A FORWARD -s $ip -d $addr -j $action");
				}
			}
		}

		if ($ip_first and $ip_last) {
			if ($nat) {
				if ($port and $proto) {
					if ($port=~m/\d+,\d+/) {
						system("$ipt -A FORWARD -s $eth_ip -m iprange --dst-range $ip_first-$ip_last -m multiport -p $proto --destination-port $port -j $action");
					} else {
						system("$ipt -A FORWARD -s $eth_ip -m iprange --dst-range $ip_first-$ip_last -p $proto --destination-port $port -j $action");
					}
				} else {
					system("$ipt -A FORWARD -m iprange --dst-range $ip_first-$ip_last -s $eth_ip -j $action");
					system("$ipt -A FORWARD -m iprange --src-range $ip_first-$ip_last -d $eth_ip -j $action");
				}
			} else {
				if ($port and $proto) {
					if ($port=~m/\d+,\d+/) {
						system("$ipt -A FORWARD -s $addr -m iprange --dst-range $ip_first-$ip_last -m multiport -p $proto --destination-port $port -j $action");
					} else {
						system("$ipt -A FORWARD -s $addr -m iprange --dst-range $ip_first-$ip_last -p $proto --destination-port $port -j $action");
					}
				} else {
					system("$ipt -A FORWARD -m iprange --dst-range $ip_first-$ip_last -s $addr -j $action");
					system("$ipt -A FORWARD -m iprange --src-range $ip_first-$ip_last -d $addr -j $action");
				}
			}
		}
	}
	$STH->finish;
}

sub clear_dead_sessions {
	our $DBH, $config;
	$dir = $config{'pids_dir'};
#	$debug = $config{'debug_log'};

	$STH = $DBH->prepare("SELECT * FROM sessions");
	$STH->execute;
	while(my $sess = $STH->fetchrow_hashref()){
		my $isfile = "$dir/$sess->{'iface'}.pid";
		if(!-e "$isfile") {
#			if ($debug){
				 logging("subilling", "Сессия $sess->{'iface'} не работает. Убиваем...");
#			}
			$DBH->do("delete from sessions where iface='$sess->{'iface'}'");
			$DBH->do("update history set time_end='". time() ."' where (id_user='$sess->{'id_user'}' and time_end=0)");
			$DBH->do("update users set on_line='0' where id_user='$sess->{'id_user'}'");
		}
	}

        $STH = $DBH->prepare("SELECT id FROM users WHERE on_line='1'");
        $STH->execute;
        while(my $id = $STH->fetchrow_array()){
		print "ID: $id\n";
		$temp_var = 0;
		$STHH = $DBH->prepare("SELECT id_user FROM sessions");
		$STHH->execute;
		while(my $id_user = $STHH->fetchrow_array()){
			print "ID_USER: $id_user\n";
			if ($id == $id_user) {
				$temp_var = 1;
				print "temp $temp_var\n";
			}
		}
		if ($temp_var == 0) {
			$DBH->do("update users set on_line='0' where id='$id'");
		}
        }

}

sub decode {
	my $hex = $_[0];
	my $a = hex(substr($hex, 0, 2));
	my $b = hex(substr($hex, 2, 2));
	my $c = hex(substr($hex, 4, 2));
	my $d = hex(substr($hex, 6, 2));
	return $a.".".$b.".".$c.".".$d;
}

1;
