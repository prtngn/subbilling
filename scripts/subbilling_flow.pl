#!/usr/bin/perl

use FindBin;
use lib $FindBin::Bin;
use Net::Flow qw(decode);
use IO::Socket::INET;
use Time::Local;

require '/usr/local/subbilling/inc/common.inc.pl';

my $packet = undef ;
my $TemplateArrayRef = undef ;
my $sock = IO::Socket::INET->new( LocalPort =>$config{'receive_port'}, Proto =>$config{'receive_proto'}) ;
my $pid_file = $config{'pids_dir'}."/".$config{'pid'};
my $log = $config{'logs_dir'}."/".$config{'log'};
my $dieFlag = 1;
my $reconnectFlag = 1;

$start_args = $ARGV[0];

if ($start_args ne "start" and $start_args ne "stop") {
	usage();
	exit;
}

if($start_args eq "stop") {
	if(-e $pid_file) {
		open (FP, $pid_file);
		$child_pid=<FP>;
		kill KILL => $child_pid;
		close FP;
		unlink $pid_file;
		die "SUB Billing shutdown!\n";
		logging("subilling", "SUB Billing stopped.");
	} else {
		logging("subilling", "SUB Billing not running!");
		die "SUB Billing not running ...\n";
	};
};

if($start_args eq "start") {
	if(-e $pid_file) {
		open (FP, $pid_file);
		$child_pid=<FP>;
		close FP;
		if($child_pid>0) {
			die "SUB Billing ($child_pid) already running!\n"
		};
	};
};

$SIG{'KILL'} = 'KILLHandler';

&Daemonize;

while($dieFlag) {
	if($reconnectFlag) {
		while (!$temp) {
			$temp = &Reconnect;
		}
		$reconnectFlag=0;
	};

	if (!$DBH->ping) {
		while (!$temp) {
			$temp = &Reconnect;
		}
	};

	while ($sock->recv($packet,1548)) {
		my %tmp_data;
		my %data;
		my %ex_data;
		my %routes;
		my %prices;
		my %holidays;
		my %prepaids;
		my @tmp;
		my ($HeaderHashRef, $TemplateArrayRef, $FlowArrayRef, $ErrorsArrayRef) = Net::Flow::decode( \$packet, $TemplateArrayRef);

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

		my $STH = $DBH->prepare("select id_tariff, day, discount_in, discount_out from holidays order by id_tariff");
		$STH->execute;
		while (@tmp = $STH->fetchrow_array()) {
			%{$holidays{$tmp[0]}{$tmp[1]}} = (
				'discount_in'	=> $tmp[2],
				'discount_out'	=> $tmp[3]
			);
		}
		$STH->finish;

		$STH = $DBH->prepare("select users.addr, users.id, users.id_tariff, users.id_account, users.login, users_accounts.deposit, users_groups.discount, users.p_in, users.p_out, users_groups.blocked, routers.detailed, users.nat, users.eth_ip from users, users_accounts, users_groups, routers where users_accounts.id_group=users_groups.id and users.id_account = users_accounts.id and routers.id = 1");
		$STH->execute;
		while (@tmp = $STH->fetchrow_array()) {
			if ($tmp[11] == 0){
				%{$users{$tmp[0]}} = (
					'id'		=> $tmp[1],
					'id_tariff'	=> $tmp[2],
					'id_account'	=> $tmp[3],
					'login'	=> $tmp[4],
					'deposit'	=> $tmp[5],
					'discount'	=> $tmp[6],
					'p_in'		=> $tmp[7],
					'p_out'	=> $tmp[8],
					'blocked'	=> $tmp[9],
					'detailed'	=> $tmp[10]
				);
			} else {
				%{$users{$tmp[12]}} = (
					'id'		=> $tmp[1],
					'id_tariff'	=> $tmp[2],
					'id_account'	=> $tmp[3],
					'login'	=> $tmp[4],
					'deposit'	=> $tmp[5],
					'discount'	=> $tmp[6],
					'p_in'		=> $tmp[7],
					'p_out'	=> $tmp[8],
					'blocked'	=> $tmp[9],
					'detailed'	=> $tmp[10]
				);
			}
		}
		$STH->finish;

		$STH = $DBH->prepare("select timers.id_group, timers.id, timers.time_from, timers.time_to, timers.cost_in, timers.cost_out, timers.prepaid, timers.cc, routes_groups.id_tariff from timers, routes_groups where routes_groups.id = timers.id_group order by timers.id_group, timers.time_from");
		$STH->execute;
		while (@tmp = $STH->fetchrow_array()) {
			%{$prices{$tmp[0]}{$tmp[1]}} = (
				'time_from'	=> $tmp[2],
				'time_to'	=> $tmp[3],
				'cost_in'	=> $tmp[4],
				'cost_out'	=> $tmp[5],
				'prepaid'	=> $tmp[6],
				'cc'		=> $tmp[7],
				'tariff'	=> $tmp[8]
			);
			if ($tmp[6]) {
				$prepaids{$tmp[7]}{'count'}++;
			}
			if ($prepaids{$tmp[7]}{'max_cost'}{'in'} < $tmp[4]) {
				$prepaids{$tmp[7]}{'max_cost'}{'in'} = $tmp[4];
			}
			if ($prepaids{$tmp[7]}{'max_cost'}{'out'} < $tmp[5]) {
				$prepaids{$tmp[7]}{'max_cost'}{'out'} = $tmp[5];
			}
		}
		$STH->finish;

		foreach my $FlowRef ( @{$FlowArrayRef} ){
			$route = $HeaderHashRef->{'EngineId'};
			$time = $HeaderHashRef->{'UnixSecs'};
			$tm = timelocal(1,(localtime($time))[1,2,3,4,5]);
			$bytes = hex(unpack("H*",$FlowRef->{1}));
			$dport = hex(unpack("H*",$FlowRef->{11}));
			$daddr = decode(unpack("H*",$FlowRef->{12}));
			$proto = hex(unpack("H*",$FlowRef->{4}));
			$sport = hex(unpack("H*",$FlowRef->{7}));
			$saddr = decode(unpack("H*",$FlowRef->{8}));
			$daddr = inet_aton($daddr);
			$saddr = inet_aton($saddr);

			if (exists($users{$daddr})) {
				$tmp_data{$tm}{$daddr}{$saddr}{'in'} += $bytes;
				if ($users{$daddr}{'detailed'}) {
					$id_group = get_id_group(\%routes, $saddr, $users{$daddr}{'id_tariff'});
					%price = get_price(\%prices, \%holidays, $tm, $id_group, $users{$daddr}{'id_tariff'});
					$cost = $price{'in'}/1024/1024*$bytes;
					my $STH = $DBH->prepare("select id from traff where uid='${users{$daddr}{'id'}}' and src='$saddr' and dst='$daddr' and port='$dport' and proto='$proto'");
					$STH->execute;
					while (($id) = $STH->fetchrow_array()) {
						$query = "update traff set cost=cost+'$cost', byte_in=byte_in+$bytes, time=$time where id='$id'";
						$tttt = 1;
					}
					$STH->finish;
					if (!$tttt) {
						$query = "insert into traff (uid, time, cost, src, dst, port, byte_in, proto) values('${users{$daddr}{'id'}}', '$time', '$cost', '$saddr', '$daddr', '$dport', '$bytes', '$proto')";
					}
					$DBH->do(qq($query));
					$tttt = 0;
				}
			}

			if (exists($users{$saddr})) {
				$tmp_data{$tm}{$saddr}{$daddr}{'out'} += $bytes;
				if ($users{$saddr}{'detailed'}) {
					$id_group = get_id_group(\%routes, $daddr, $users{$saddr}{'id_tariff'});
					%price = get_price(\%prices, \%holidays, $tm, $id_group, $users{$saddr}{'id_tariff'});
					$cost = $price{'out'}/1024/1024*$bytes;
					my $STH = $DBH->prepare("select id from traff where uid='${users{$saddr}{'id'}}' and src='$saddr' and dst='$daddr' and port='$dport' and proto='$proto'");
					$STH->execute;
					while (($id) = $STH->fetchrow_array()) {
						$query = "update traff set cost=cost+'$cost', byte_out=byte_out+$bytes, time=$time where id='$id'";
						$tttt = 1;
					}
					$STH->finish;
					if (!$tttt) {
						$query = "insert into traff (uid, time, cost, src, dst, port, byte_out, proto) values('${users{$saddr}{'id'}}', '$time', '0', '$saddr', '$daddr', '$dport', '$bytes', '$proto')";
					}
					$DBH->do(qq($query));
					$tttt = 0;
				}
			}
		}

			for $tm (keys %tmp_data) {
				%ex_data = ();
				$STH = $DBH->prepare("select id_user, id_group, id, log_time from data where log_time='$tm'");
				$STH->execute;
				while (@tmp = $STH->fetchrow_array()) {
					$ex_data{$tmp[0]}{$tmp[1]} = $tmp[2];
				}
				$STH->finish;

				for $uaddr (keys %{$tmp_data{$tm}}) {
					$prepaid_in = 0;
					$prepaid_out = 0;
					$total_price = 0;
					%data = ();

					for $iaddr (keys %{$tmp_data{$tm}{$uaddr}}) {
						if (defined $users{$uaddr}) {
							$id_group = get_id_group(\%routes, $iaddr, $users{$uaddr}{'id_tariff'});
							$data{$id_group}{'in'} += $tmp_data{$tm}{$uaddr}{$iaddr}{'in'};
							$data{$id_group}{'out'}  += $tmp_data{$tm}{$uaddr}{$iaddr}{'out'};
						}
					}

					for $id_group (keys %data) {

						%price = get_price(\%prices, \%holidays, $tm, $id_group, $users{$uaddr}{'id_tariff'});

						if ($ex_data{$users{$uaddr}{'id'}}{$id_group}) {
							$cost = $price{'in'}/1024/1024*$data{$id_group}{'in'} + $price{'out'}/1024/1024*$data{$id_group}{'out'};
							$query = "update data set incoming=incoming+'${data{$id_group}{'in'}}', outgoing=outgoing+'${data{$id_group}{out}}', cost=cost+'$cost' where id='${ex_data{$users{$uaddr}{id}}{$id_group}}'";
						} else {
				 			$cost = $price{'in'}/1024/1024*$data{$id_group}{'in'} + $price{'out'}/1024/1024*$data{$id_group}{'out'};
							$query = "insert into data (id_user, id_group, incoming, outgoing, log_time, cost) values('$users{$uaddr}{'id'}', '$id_group', '${data{$id_group}{in}}', '${data{$id_group}{out}}', '$tm', '$cost')";
						}
						$DBH->do(qq($query));

						if ($price{'prepaid'}) {

							if ($prepaids{$users{$uaddr}{'id_tariff'}}{'count'} > 1) {
								if ($prepaids{$users{$uaddr}{'id_tariff'}}{'max_cost'}{'in'} > 0) {
									if ($price{'in'} > 0 and $price{'in'} < $prepaids{$users{$uaddr}{'id_tariff'}}{'max_cost'}{'in'}) {
										$coof = $prepaids{$users{$uaddr}{'id_tariff'}}{'max_cost'}{'in'} / $price{'in'};
										$data{$id_group}{'in'} = $data{$id_group}{'in'} / $coof;
									} else {
										if ($price{'in'} == 0) {
											$data{$id_group}{'in'} = 0;
										}
									}
								}

								if ($prepaids{$users{$uaddr}{'id_tariff'}}{'max_cost'}{'out'} > 0) {
									if ($price{'out'} > 0 and $price{'out'} < $prepaids{$users{$uaddr}{'id_tariff'}}{'max_cost'}{'out'}) {
										$coof = $prepaids{$users{$uaddr}{'id_tariff'}}{'max_cost'}{'out'} / $price{'out'};
										$data{$id_group}{'out'} = $data{$id_group}{'out'} / $coof;
									} else {
										if ($price{'out'} == 0) {
											$data{$id_group}{'out'} = 0;
										}
									}
								}
							}

							# prepaid incoming
							if ($users{$uaddr}{'p_in'} > $data{$id_group}{'in'}) {
								$users{$uaddr}{'p_in'} -= $data{$id_group}{'in'};
								$prepaid_in += $data{$id_group}{'in'};
								$data{$id_group}{'in'} = 0;
							} else {
								$data{$id_group}{'in'} -= $users{$uaddr}{'p_in'};
								$prepaid_in += $users{$uaddr}{'p_in'};
								$users{$uaddr}{'p_in'} = 0;
							}

							# prepaid outgoing
							if ($users{$uaddr}{'p_out'} > $data{$id_group}{'out'}) {
								$users{$uaddr}{'p_out'} -= $data{$id_group}{'out'};
								$prepaid_out += $data{$id_group}{'out'};
								$data{$id_group}{'out'} = 0;
							} else {
								$data{$id_group}{'out'} -= $users{$uaddr}{'p_out'};
								$prepaid_out += $users{$uaddr}{'p_out'};
								$users{$uaddr}{'p_out'} = 0;
							}

						}

						$total_price += $price{'in'}/1024/1024*$data{$id_group}{'in'} + $price{'out'}/1024/1024*$data{$id_group}{'out'};
						if ($users{$uaddr}{'discount'}) {
							$total_price -= $total_price / 100 * $users{$uaddr}{'discount'};
						}
						$i++;
					}

					if ($total_price || $prepaid_in || $prepaid_out) {
						$query = "update users_accounts set deposit=deposit-'$total_price' where id='${users{$uaddr}{'id_account'}}'";
						$DBH->do(qq($query));
						$query = "update users set p_in=p_in-'$prepaid_in', p_out=p_out-'$prepaid_out' where id='${users{$uaddr}{'id'}}'";
						$DBH->do(qq($query));
					}
				}
			}

		#}
	}
};

$DBH->disconnect;

exit;

sub Daemonize {
#	Старт разных сервисов!
#	print "Starting all need services ...\n";
#	system("$config{'apache_start'}");
#	system("$config{'radius_start'}");
#	system("$config{'pptpd_start'}");
#	system("$config{'ip-sentinel_start'}");
#	system("$config{'dhcpd_start'}");
#	system("$config{'ipcad_start'}");
	print "SUB Billing is loading...";
	logging("subilling", "SUB Billing is loading...");
	open(STDIN,"</dev/null");

	defined(my $pid = fork) or die " [ Error ]\n Can't fork: $!";
	exit if $pid;
	setsid or die " [ Error ]\n Can't start a new session: $!";
	umask 0;
	open(FP,">$pid_file");
	print FP $$;
	close FP;
	print " [ OK ]\n";
	logging("subilling", "SUB Billing is loaded.");
	open(STDOUT,">/dev/null");
	open(STDERR, '>&STDOUT');
}

sub KILLHandler {
        logging("subilling", "KILL signal handled");
        $dieFlag = 0;
}
