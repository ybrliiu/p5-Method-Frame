package Method::Frame::Domain::ApplyRole::ComparisonFrame;

use Method::Frame::Base;

use parent 'Method::Frame::Domain::ComparisonFrame';

sub id { shift->{name} }

1;
