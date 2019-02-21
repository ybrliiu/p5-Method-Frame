package Method::Frame::Base;
use 5.014000;
use strict;
use warnings;
use utf8;

use parent 'Import::Base';

our @IMPORT_MODULES = (
    'strict',
    'warnings',
    'utf8',
    'feature' => [qw( :5.14 )],
);

our %IMPORT_BUNDLES = (
    test => [qw( Test2::V0 )],
);

1;
