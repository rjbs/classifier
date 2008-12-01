package Test::Classifier::AlwaysReject;
use Moose;
extends 'Classifier';

sub default_tags { qw(test alwaysreject) }
sub default_type { 'alwaysrejected' }

my $i;
sub consider {
  my ($self, $text) = @_;

  $self->reject({
    reject_number => ++$i,
  });
}

1;
