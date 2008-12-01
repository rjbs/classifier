use strict;
use warnings;

package Test::Classifier::AlwaysMatch;
use base 'Classifier';

sub default_tags { qw(test alwaysmatch) }
sub default_type { 'alwaysmatched' }

my $i;
sub consider {
  my ($self, $text) = @_;

  $self->match({
    match_number => ++$i,
  });
}

1;
