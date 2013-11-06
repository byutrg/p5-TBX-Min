#basic test file

use strict;
use warnings;
use Test::More;
plan tests => 0;
use TBX::Min;
use FindBin qw($Bin);
use Path::Tiny;

my $corpus_dir = path($Bin, 'corpus');
my $min = TBX::Min->new();