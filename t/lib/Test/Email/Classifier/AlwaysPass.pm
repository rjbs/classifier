use strict;
use warnings;

package Test::Email::Classifier::AlwaysPass;
use base 'Email::Classifier';

sub default_tags { qw(test alwayspass) }
sub default_type { 'alwayspassed' }

sub consider {
  my ($self, $email) = @_;

  $self->pass;
}

1;
