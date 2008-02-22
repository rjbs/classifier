use strict;
use warnings;

package Test::Email::Classifier::AlwaysMatch;
use base 'Email::Classifier';

sub default_tags { qw(test alwaysmatch) }
sub default_type { 'alwaysmatched' }

my $i;
sub consider {
  my ($self, $email) = @_;

  $self->match({
    match_number => ++$i,
  });
}

1;
