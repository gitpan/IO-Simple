# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl IO-Simple.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';


use Test::More tests => 6;
BEGIN { use_ok('IO::Simple') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

#insure our test file doesn't exist before we start
unlink 't/test.dat';
ok( !-e 't/test.dat'    , 'Test File not here yet.');

#create a simple test.dat file for writing.
my $t = IO::Simple::ios('t/test.dat','w');
isa_ok($t, 'IO::Simple', 'File object created.');
$t->print("TEST");
$t->close;

ok( -e 't/test.dat'    , 'File Created Successfully');

$t = IO::Simple::ios('t/test.dat', 'r');
my $line = $t->slurp();
$t->close();
is($line, 'TEST', 'TEST printed to and slurped from file.');	


unlink 't/test.dat';
ok( !-e 't/test.dat'    , 'Test File removed.');
