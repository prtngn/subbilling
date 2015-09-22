#!/usr/bin/perl

use FindBin;
use lib $FindBin::Bin;
use IO::Socket::INET;
#use Date::Manip;

require '/usr/local/subbilling/inc/common.inc.pl';

my $pid_file = $config{'pids_dir'}."/".$config{'pid'}.".periodic";
my $log = $config{'log'};
my $dieFlag = 1;
my $reconnectFlag = 1;
my $time = time();

my $last_time_firewall = $time;
my $last_time_routes = $time;
my $last_time_periodic = $time;
my $last_time_shapers = $time;
my $last_time_squid = $time;

my $start_args = $ARGV[0];

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
                logging($log, "$time : SUB Billing stopped.\n");
        } else {
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
	check_debtors();
        check_nat();

        if ($last_time_routes < time()) {
                build_all_routes();
                $last_time_routes = $last_time_routes + $config{'run_time_routes'} + 1;
        }

        if ($last_time_firewall < time()) {
                firewall();
                $last_time_firewall = $last_time_firewall + $config{'run_time_firewall'} + 1;
        }

        if ($last_time_periodic < time()) {
                periodic();
                $last_time_periodic = $last_time_periodic + $config{'run_time_periodic'} + 1;
        }

        if ($last_time_shapers < time()) {
                build_all_shapers();
                $last_time_shapers = $last_time_shapers + $config{'run_time_shapers'} + 1;
        }

#	if ($last_time_squid < time()) {
#		system("rm /var/www/localhost/htdocs/squid/* -R");
#		system("cp /usr/local/var/www/htdocs/free-sa/* /var/www/localhost/htdocs/squid/ -r");
#		system("/usr/local/bin/free-sa -F");
#		system("/usr/local/bin/free-sa -d 21.12.2006-");
#		$last_time_squid = $last_time_squid + 3601;
#	}

#        test_configs();
	clear_data();
        clear_detailed();
	clear_dead_sessions();

        sleep(59);

};

$DBH->disconnect;

exit;

sub Daemonize {
        print "Starting all need services ...\n";
#        system("$config{'apache_start'}");
#        system("$config{'radius_start'}");
#        system("$config{'pptpd_start'}");
#        system("$config{'ip-sentinel_start'}");
#        system("$config{'dhcpd_start'}");
#        system("$config{'ipcad_start'}");
        print "\nDaemonizing SUB Billing ...";
        open(STDIN,"</dev/null");

        defined(my $pid = fork)   or die "Can't fork: $!";
        exit if $pid;
        setsid                    or die "Can't start a new session: $!";
        umask 0;
        open(FP,">$pid_file");
        print FP $$;
        close FP;
        print " [ OK ]\n";
        logging($log, "$time : SUB Billing started.\n");
        open(STDOUT,">/dev/null");
        open(STDERR, '>&STDOUT');
}

sub KILLHandler {
        logging($log, "$time : KILL signal handled\n");
        $dieFlag = 0;
}

