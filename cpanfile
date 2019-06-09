requires 'perl', '5.014000';
requires 'Class::Accessor::Lite', '0.08';
requires 'Import::Base', '1.004';
requires 'Try::Tiny', '0.30';
requires 'Scalar::Util', '1.50';
requires 'Class::Load', '0.25';
requires 'Role::Tiny', '2.000006';
requires 'Package::Stash', '0.37';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test2::V0';
    requires 'Test::More', '0.98';
    requires 'Test::Perl::Critic', '1.04';
    requires 'Types::Standard';
};

on develop => sub {
    requires 'Data::Validator';
    requires 'Test::Perl::Critic';
    requires 'perl', 'v5.28.0';
};
