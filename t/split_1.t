#!perl -T
use Test2::V0;
use Jo::Util qw(splitdata);

no warnings 'once';

my %fh = splitdata;

is eof(EXT), T(), 'handle not created';

is eof($fh{EXT}), F(), 'handle ready';

is readline($fh{EXT}), "ext 1\n", 'got ext data';

done_testing;

__DATA__
data 1
data 2
__EXT__
ext 1
ext 2
