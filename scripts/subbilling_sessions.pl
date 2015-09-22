#!/usr/bin/perl
use FindBin;
use lib $FindBin::Bin;

require '/usr/local/subbilling/inc/common.inc.pl';

my $iface = $ARGV[0];
my $lan_ip = inet_aton($ARGV[1]);
my $ppp_ip = inet_aton($ARGV[2]);

if ($ARGV[0] =~ "generate") {
	$STH = $DBH->prepare("select login, pass, inet_ntoa(addr), nat from users order by login");
	$STH->execute;
	while (($login, $pass, $addr,$type) = $STH->fetchrow_array()) {
		if (!$type) {
			print STDOUT "$login\tpptpd\t$pass\t$addr\n";
		}
	}
	$STH->finish;
}

if ($ARGV[3] =~ "reg") {

	my $STH = $DBH->prepare("select * from users where addr='$ppp_ip'");
	$STH->execute;
	exit if (!$STH->rows());
	$STH->finish;

	$STH = $DBH->prepare("select users.id, users.blocked, users.id_tariff, users_accounts.deposit, users_accounts.max_credit, users.security, users_groups.blocked from users, users_groups, users_accounts where users_accounts.id_group=users_groups.id and users.addr='$ppp_ip' and users.id_account = users_accounts.id");
	$STH->execute;
	my ($id_user, $user_blocked, $id_tariff, $deposit, $max_credit, $security, $blocked) = $STH->fetchrow_array();
	$STH->finish;
	if ($security) {
		$STH = $DBH->prepare("select * from users_addr where id_user='$id_user' and addr='$lan_ip'");
		$STH->execute;
		$blocked=1 if (!$STH->rows());
		$STH->finish;
	}

	if ($blocked || !($max_credit+$deposit) || $user_blocked) {
		kill_session($iface);
	} else {
		enable_nat(inet_ntoa($ppp_ip));

		$DBH->do("delete from sessions where iface='$iface'");
		$DBH->do("insert into sessions (id_user, iface, addr, connected) values('$id_user', '$iface', '$lan_ip', '". time() ."')");
		$DBH->do("insert into history (id_user, addr, time_start) values('$id_user','$lan_ip','". time() ."')");
		$DBH->do("update users set last_connect='". time() ."', on_line='1' where id='$id_user'");

		build_user_shapers($id_user);
	}
}

if ($ARGV[2] =~ "reg_pppoe") {

        my $STH = $DBH->prepare("select * from users where addr='$lan_ip'");
        $STH->execute;
        exit if (!$STH->rows());
        $STH->finish;

        $STH = $DBH->prepare("select users.id, users.blocked, users.id_tariff, users_accounts.deposit, users_accounts.max_credit, users.security, users_groups.blocked from users, users_groups, users_accounts where users_accounts.id_group=users_groups.id and users.addr='$lan_ip' and users.id_account = users_accounts.id");
        $STH->execute;
        my ($id_user, $user_blocked, $id_tariff, $deposit, $max_credit, $security, $blocked) = $STH->fetchrow_array();
        $STH->finish;
#        if ($security) {
#                $STH = $DBH->prepare("select * from users_addr where id_user='$id_user' and addr='$ppp_ip'");
#                $STH->execute;
#                $blocked=1 if (!$STH->rows());
#                $STH->finish;
#        }

        if ($blocked || !($max_credit+$deposit) || $user_blocked) {
                kill_session($iface);
        } else {
                enable_nat(inet_ntoa($lan_ip));

                $DBH->do("delete from sessions where iface='$iface'");
                $DBH->do("insert into sessions (id_user, iface, connected) values('$id_user', '$iface', '". time() ."')");
                $DBH->do("insert into history (id_user, time_start) values('$id_user','". time() ."')");
                $DBH->do("update users set last_connect='". time() ."', on_line='1' where id='$id_user'");

                build_user_shapers($id_user);
        }
}

if ($ARGV[3] =~ "unreg") {
	my $STH = $DBH->prepare("select id from users where addr='$ppp_ip'");
	$STH->execute;
	my ($id_user) = $STH->fetchrow_array();
	$STH->finish;

	$DBH->do("delete from sessions where iface='$iface'");
	$DBH->do("update history set time_end='". time() ."' where (id_user='$id_user' and time_end=0)");
	$DBH->do("update users set on_line='0' where id='$id_user'");

	disable_nat(inet_ntoa($ppp_ip));
	build_all_shapers();
}

$DBH->disconnect;
