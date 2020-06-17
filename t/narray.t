#!perl -T
use Test2::V0;

use Jo::Util qw(narray);

is narray(sub {$_[0]}, 3), [qw(0 1 2)], '1-d array';

is narray(sub {$_[0] == $_[1] || 0}, 3, 3),
	[[1, 0, 0], [0, 1, 0], [0, 0, 1]], '3x3 identity';

is narray(sub {1}, 3, 3, 3),
	[[[1, 1, 1], [1, 1, 1], [1, 1, 1]],
	[[1, 1, 1], [1, 1, 1], [1, 1, 1]],
	[[1, 1, 1], [1, 1, 1], [1, 1, 1]]], '3-d array';

my $ar = narray {1} 3;
is $ar, [1, 1, 1], 'call builtin style';

done_testing;
