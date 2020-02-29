#!perl -T
use Test2::V0;

use Jo::Util qw(aref genlist);

is aref(1, 2), [qw(1 2)], 'not empty';

is aref(), U(), 'empty';

my @feed = (1, 2, undef, 3);
my @res = genlist {shift @feed};
is \@res, [qw(1 2)], 'not empty, undef terminated';

@feed = ([1], [2], [], [3]);
@res = genlist {@{shift @feed}};
is \@res, [qw(1 2)], 'not empty, empty terminated';

@feed = ([1, 2], [3], [], [4, 5]);
@res = genlist {@{shift @feed}};
is \@res, [qw(1 2 3)], 'list return';

@res = genlist {()};
is \@res, [], 'empty';

done_testing;
