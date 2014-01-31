#!/usr/bin/perl

use Getopt::Long;
use vars qw($opt_h $PROGNAME $opt_w $opt_c $opt_t $opt_vi $msg $state);
 use lib "/usr/local/nagios/libexec";
use utils qw(%ERRORS &print_revision &support &usage );

sub print_help ();
sub print_usage ();
sub process_arguments();

Getopt::Long::Configure('bundling');
$status=process_arguments();
if ($status){
        print "ERROR:  Processing Arguments\n";
        exit $ERRORS{'WARNING'};
        }

$SIG{'ALRM'} = sub {
        print ("ERROR: timed out waiting for $PROGNAME \n");
                exit $ERRORS{"WARNING"};
};
alarm($opt_t);



$procfile="/proc/sys/fs/file-nr";

open(FILE, $procfile) or die "$procfile not exits!";
my $line=<FILE>;
close FILE;
my ($nb_openfiles, $nb_freehandlers, $file_max)= split(/\s/, $line);
$nb_openpct=int($nb_openfiles / $file_max * 100);
$warning_threshold=int($file_max * $opt_w /100);
$critical_threshold=int($file_max * $opt_c /100);

if ($nb_openfiles < $warning_threshold ){
        $msg = "OK: $nb_openfiles open files ($nb_openpct% of max $file_max)";
#       $msg = "OK: number of opened files ($nb_openfiles) is below threshold ($warning_threshold/$critical_threshold)";
        $state=$ERRORS{'OK'};
        }
if ($nb_openfiles >= $warning_threshold && $nb_openfiles< $critical_threshold){
        $msg = "WARNING: $nb_openfiles open files ($nb_openpct% of max $file_max)";
        $state=$ERRORS{'WARNING'};
        }
if ($nb_openfiles >= $critical_threshold ){
        $msg = "CRITICAL: $nb_openfiles open files ($nb_openpct% of max $file_max)";
        $state=$ERRORS{'CRITICAL'};
        }


