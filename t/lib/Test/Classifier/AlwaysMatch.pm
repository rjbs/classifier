package Test::Classifier::AlwaysMatch;
use Moose;
extends 'Classifier';

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
