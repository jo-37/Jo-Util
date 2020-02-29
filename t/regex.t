#!perl -T
use Test2::V0;

use Jo::Util qw(stopmatch);

my $pre = stopmatch qr{<!>};
is [/($pre)/], ['aaa'], 'not empty' for 'aaa<!>bbb';

is [/($pre)/], ['aaa'], 'not found' for 'aaa';

is [/($pre)/], [''], 'emptry' for '<!>bbb';

done_testing;
