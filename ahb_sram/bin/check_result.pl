#!/usr/bin/perl -w

$VECTOR = $ARGV[0];
$OPT    = $ARGV[1];
$STARTTIME = `date`;
$MODE   = "ONLY ONE";
chomp($STARTTIME);

$VECTOR =~ s/\.\.\/pattern\///g;
if( $OPT =~ m/.*\+(LIST.*)/ ){
	$MODE = $1;
}
system("mkdir -p RES") unless( -d "RES" );
open ( RESULT_FILE, ">>RES/result.log") || die "Cannot open RES/result.log: $!";
printf( RESULT_FILE "%-35s", $VECTOR);
print RESULT_FILE "* " . "$MODE" . " * " . "$STARTTIME" . " :";
$lin_time = 0;
$lin_sva1 = 0;
$lin_sva2 = 0;
$lin_sva  = 0;
$lin_err  = 0;
$lin_ERR  = 0;
$lin_fatal  = 0;
$lin_ng   = 0;
$lin_war  = 0;
if( $MODE ne "ONLY ONE" ){
	system("rm -rf RES/$VECTOR-$MODE/*") unless( !-d "RES/$VECTOR-$MODE" );
	system("mkdir -p RES/$VECTOR-$MODE") unless( -d "RES/$VECTOR-$MODE" );
}
else {
	system("rm -rf RES/$VECTOR/*") unless( !-d "RES/$VECTOR" );
	system("mkdir -p RES/$VECTOR") unless( -d "RES/$VECTOR" );
}
if( !-e "vcs.log" ){
 	print RESULT_FILE " NG: VCS_SIM is not implicated!!!";
}
else {
	$lin_compare = `grep compare vcs.log | wc -l`;#FHM
	$lin_time = `grep TIMEOUT vcs.log | wc -l`;
	$lin_sva1 = `grep Offending vcs.log | wc -l`;
	$lin_sva2 = `grep SVA_CHECKER_ERROR vcs.log | wc -l`;
	$lin_sva  = $lin_sva1 + $lin_sva2;
	$lin_ng   = `grep " NG" vcs.log | wc -l`;
	$lin_err  = `grep "Error" vcs.log | wc -l`;
	$lin_ERR  = `grep "UVM_ERROR" vcs.log | grep -v "UVM_ERROR :" | wc -l`;
	$lin_fatal  = `grep "UVM_FATAL" vcs.log | grep -v "UVM_FATAL :" | wc -l`;
	#$lin_war  = `grep "WARNING.*FAILURE" vcs.log | wc -l`;
 
	#if( ($lin_time + $lin_err + $lin_ng + $lin_ERR + $lin_sva + $lin_war + $lin_fatal) == 0 ) {
	if( (($lin_compare==0) + $lin_time + $lin_err + $lin_ng + $lin_ERR + $lin_sva + $lin_fatal) == 0 ) {#FHM 
 		print RESULT_FILE " OK";
		system( "cp vcs.log RES/$VECTOR/vcs.log" );
	}
	else {
		if( ($lin_compare) == 0 ){#FHM 
 			print RESULT_FILE " no compare";
		}
		if( ($lin_err) != 0 ){
 			print RESULT_FILE " NG:Syntax error";
		}
		if( ($lin_fatal) != 0 ){
 			print RESULT_FILE " FATAL:Fatal error";
		}
		if( $lin_time != 0 ){
 			print RESULT_FILE " NG:TIMEOUT";
		}
		if( ($lin_ng) != 0 ){
 			print RESULT_FILE " NG:Data checker error";
		}
		if( ($lin_ERR) != 0 ){
 			print RESULT_FILE " NG:UVM check error";
		}
		if( $lin_sva != 0 ){
 			print RESULT_FILE " NG:sva checker error";
		}
		#if( $lin_war != 0 && $lin_sva == 0 && $lin_err == 0  && $lin_time == 0 ){
 		#	print RESULT_FILE " OK:WARNING Detected";
		#}
		#system( "cp vcs.log RES/$VECTOR-$MODE/vcs.log" );
		#system( "cp vcdplus.vpd RES/$VECTOR-$MODE/vcdplus.vpd" ) if( -e "vcdplus.vpd" );
		system( "cp vcs.log RES/$VECTOR/vcs.log" );
		system( "cp comp.log RES/$VECTOR/comp.log" );
		system( "cp vcdplus.vpd RES/$VECTOR/vcdplus.vpd" ) if( -e "vcdplus.vpd" );
	}
}
print RESULT_FILE "\n";
close(RESULT_FILE);

##############################
#Save VCM DataBase
##############################
if( -e "simv.vdb" ){
	system( "mkdir VCSCODE" ) unless( -e "VCSCODE" );
	system( "touch VCSCODE/merge.list" ) unless( -f "VCSCODE/merge.list" );
	open ( VCSCODE_FILE, ">> VCSCODE/merge.list") || die "Cannot open merge.list: $!";
	if( $MODE ne "ONLY ONE" ){
		system( "rm -rf VCSCODE/$VECTOR-$MODE" ) if( -e "VCSCODE/$VECTOR-$MODE" );
       		system( "mkdir -p VCSCODE/$VECTOR-$MODE; mv simv.vdb/* VCSCODE/$VECTOR-$MODE/" ); 
		print VCSCODE_FILE "VCSCODE/$VECTOR-$MODE \\\n";
	}
	else {
		system( "rm -rf VCSCODE/$VECTOR" ) if( -e "VCSCODE/$VECTOR" );
       		system( "mkdir -p VCSCODE/$VECTOR; mv simv.vdb/* VCSCODE/$VECTOR/" );
		print VCSCODE_FILE "VCSCODE/$VECTOR \\\n";
	}
}

