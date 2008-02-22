use strict;
use warnings;

package Test::Email::Classifier::AlwaysReject;
use base 'Email::Classifier';

sub default_tags { qw(test alwayspass) }
sub default_type { 'alwayspassed' }

my $i;
sub consider {
  my ($self, $email) = @_;

  $self->reject({
    reject_number => ++$i,
  });
}

1;
