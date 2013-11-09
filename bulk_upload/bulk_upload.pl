#!/usr/bin/perl -w
	use strict;

        my ($sessionid, $serverurl, $jobid,$batchid);
        my ($xml);
	 
	system('> loginresponse.xml');
	system('curl --insecure --silent https://login.salesforce.com/services/Soap/u/27.0 -H "Content-Type: text/xml; charset=UTF-8" -H "SOAPAction: login" -d \@login.xml > loginresponse.xml');
	open (FILE, 'loginresponse.xml') or die ('cannot read loginresponse.xml');
	$xml=''; while(<FILE>) { $xml.=$_; } close FILE;
	if ($xml=~m|<sessionId>([0-9a-z!_\.-]+)</sessionId>|i) {
	    $sessionid=$1;
            print "session id : $sessionid\n";
	}
        if ($xml=~m|<serverURL>(.*)</serverUrl>|i) {
            $serverurl=$1;
            print "server url : $serverurl\n";
        }


        system("curl --insecure --silent https://eu2-api.salesforce.com/services/async/27.0/job -H \"X-SFDC-Session: $sessionid\" -H \"Content-Type: application/xml; charset=UTF-8\" -d \@create-job.xml > create-jobresponse.xml");

        open (FILE, 'create-jobresponse.xml') or die ('cannot read create-jobresponse.xml');
        $xml=''; while(<FILE>) { $xml.=$_; } close FILE;
        print "\n$xml\n";
         if ($xml=~m|.*<id>(.*)</id>.*|mi) {
            $jobid=$1;
            print "job id : $jobid\n";
        }


        my $cmd="curl --insecure --silent -H \"X-SFDC-Session: $sessionid\" -H \"Content-Type: text/csv; charset=UTF-8\" --data-binary \@data.csv https://eu2-api.salesforce.com/services/async/27.0/job/$jobid/batch > data-response.xml";
        print "$cmd\n";
        system($cmd);

        open (FILE, 'data-response.xml') or die ('cannot read data-response.xml');
        $xml=''; while(<FILE>) { $xml.=$_; } close FILE;
        print "\n$xml\n";
          if ($xml=~m|.*<id>(.*)</id>.*|mi) {
            $batchid=$1;
            print "batch id : $batchid\n";
        }


       sleep(10);

          $cmd="curl --insecure --silent -H \"X-SFDC-Session: $sessionid\" https://eu2-api.salesforce.com/services/async/27.0/job/$jobid/batch/$batchid > batch-response.xml";
        print "$cmd\n";
        system($cmd);

        open (FILE, 'batch-response.xml') or die ('cannot read batch-response.xml');
        $xml=''; while(<FILE>) { $xml.=$_; } close FILE;
:q
        print "\n$xml\n";



        $cmd="curl --insecure --silent -H \"X-SFDC-Session: $sessionid\" https://eu2-api.salesforce.com/services/async/27.0/job/$jobid/batch/$batchid/result > batch-result.xml";
        print "$cmd\n";
        system($cmd);
        open (FILE, 'batch-result.xml') or die ('cannot read batch-result.xml');
        $xml=''; while(<FILE>) { $xml.=$_; } close FILE;
        print "\n$xml\n";



