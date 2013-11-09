#!/usr/bin/perl

use WWW::Salesforce;
use Data::Dumper;
use strict;

# ------------------------------------------------------------------------------------
# Security Token:
# -obtained at:
#  http://login.salesforce.com and click Setup | My Personal Information | Reset Security Token.
#
#  The security token will be emailed to whatever email address is associated to the username.
#  When accessing salesforce.com either via a desktop client or the API from outside of your
#  company's trusted networks:
#
#     If your password = "mypassword"
#     And your security token = "XXXXXXXXXX"
#     You must enter "mypasswordXXXXXXXXXX" in place of your password
# ------------------------------------------------------------------------------------

my $username        = 'mail@domain.com';
my $password        = 'XXXXXXXX';
my $security_token  = 'XXXXXXXXXXXXXXXXXXXXXXXXX';
my $pass_token      = "$password$security_token";

# Log into salesforce
my $sforce = eval { WWW::Salesforce->login( username => $username, password => $pass_token ); };
die "Could not login to SFDC: $@" if $@;

# ------------------------------------------------------------------------------------
# Methods
# ------------------------------------------------------------------------------------
# sub new                 # -- deprecated, use login
# sub convertLead         # -- Converts a Lead into an Account, Contact, or (optionally) an Opportunity
# sub create              # -- Adds one or more new individual objects to your organization's data (requires type)
# sub delete              # -- Deletes one or more individual objects from your org's data (200max)
# sub describeGlobal      # -- Retrieves a list of available objects for your organization's data
# sub describeLayout      # -- retrieve information about the layout (presentation of data to users) for a given object type.
# sub describeSObject     # -- Describes metadata (field list and object properties) for the specified object.
# sub describeSObjects    # -- An array-based version of describeSObject;
# sub describeTabs        # -- returns information about the standard apps and custom apps
# sub get_client          # -- get a client
# sub get_session_header  # -- gets the session header
# sub getDeleted          # -- Retrieves the list of individual objects that have been deleted within the given timespan for the specified object.
# sub getServerTimestamp  # -- Retrieves the current system timestamp (GMT) from the Web service.
# sub getUpdated          # -- Retrieves the list of individual objects that have been updated (added or changed) within the given timespan
# sub getUserInfo         # -- Retrieves personal information for the user associated with the current session
# sub login               # -- logs a user into Sforce and returns a WWW::Salesforce object or 0
# sub query               # -- runs a query against salesforce (500 limit default)
# sub queryAll            # -- runs a query against salesforce including archived and deleted objects
# sub queryMore           # -- query from where you last left off
# sub resetPassword       # -- reset your password
# sub retrieve            # -- Retrieves one or more objects based on the specified object IDs.
# sub search              # -- Executes a text search in your organization's data.
# sub setPassword         # -- Sets the specified user's password to the specified value.
# sub update              # -- Updates one or more existing objects in your organization's data. (requires type, id)
# sub upsert              # -- Creates new objects and updates existing objects;
# ------------------------------------------------------------------------------------

# -----------------------------------------
# Show Tables
# -----------------------------------------
my $results = eval { $sforce->describeGlobal(); };
print Dumper($results->result->{'types'});
# -----------------------------------------

# -----------------------------------------
# Select contacts
# -----------------------------------------
my $query = "select FirstName, LastName, Name, Email, HomePhone, Phone from Contact";
my $results   = eval { $sforce->query( query => $query); };
print Dumper($results->result);

foreach my $record (@{$results->result->{'records'}}){
  print Dumper($record);
}
# -----------------------------------------


# -----------------------------------------
# Describe Table
# (if you did the example app, you can see the table structure with this)
# -----------------------------------------
my $results = eval { $sforce->describeSObject( type => 'Contact' ); };
if($@){
    print $@ . "\n";
}

my $fields;

foreach my $hash (@{$results->result->{'fields'}}){
    my $label = $hash->{'label'};
    my $name  = $hash->{'name'};
    $fields->{$label} = $name;
}

print Dumper($fields);

exit;

