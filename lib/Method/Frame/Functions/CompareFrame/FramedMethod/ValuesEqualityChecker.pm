package Method::Frame::Functions::CompareFrame::FramedMethod::ValuesEqualityChecker;

use Method::Frame::Base;

use List::Util qw( all );
use Scalar::Util qw( blessed looks_like_number );

use Exporter qw( import );

our @EXPORT_OK = qw( value_equals scalar_equals deep_equals array_equals hash_equals );
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

sub value_equals {
    my ($val1, $val2) = @_;
    
    if ( blessed $val1 && blessed $val2 ) {
        $val1->equals($val2);
    }
    elsif ( !blessed $val1 xor !blessed $val2 ) {
        !!0;
    }
    elsif ( !ref $val1 && !ref $val2 ) {
        scalar_equals(@_);
    }
    elsif ( !ref $val1 xor !ref $val2 ) {
        !!0;
    }
    else {
        deep_equals(@_);
    }
}

sub scalar_equals {
    my ($val1, $val2) = @_;

    return !!1 if !defined $val1 && !defined $val2;
    return !!0 if !defined $val1 xor !defined $val2;

    if ( looks_like_number($val1) && looks_like_number($val2) ) {
        $val1 == $val2;
    }
    else {
        $val1 eq $val2;
    }
}

sub deep_equals {
    my ($val1, $val2) = @_;

    return !!0 if ref $val1 ne ref $val2;

    if ( ref $val1 eq 'ARRAY' ) {
        array_equals(@_);
    }
    elsif ( ref $val1 eq 'HASH' ) {
        hash_equals(@_);
    }
    elsif ( ref $val1 eq 'SCALAR' ) {
        value_equals($$val1, $$val2);
    }
    elsif ( ref $val1 eq 'REF' ) {
        value_equals($$val1, $$val2);
    }
    else {
        # How about Regexp, VSTRING, CODE, GLOB ?
        die qq{Can not compare $val1 and $val2.};
    }
}

sub array_equals {
    my ($ary1, $ary2) = @_;

    return !!0 if $#$ary1 != $#$ary2;

    all { value_equals(@$_) } map { [ $ary1->[$_], $ary2->[$_] ] } 0 .. $#$ary1;
}

sub hash_equals {
    my ($hash1, $hash2) = @_;

    return !!0 unless array_equals([ sort keys %$hash1 ], [ sort keys %$hash2 ]);

    all { value_equals( $hash1->{$_}, $hash2->{$_} ) } keys %$hash1;
}

1;
