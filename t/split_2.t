#!perl -T
use Test2::V0;

use Jo::Util qw(splitdata);

splitdata -create;

is eof(EXT), F(), 'handle created';

is <EXT>, "ext 1\n", 'got ext data';

done_testing;

__DATA__
data 1
data 2
__EXT__
ext 1
ext 2
