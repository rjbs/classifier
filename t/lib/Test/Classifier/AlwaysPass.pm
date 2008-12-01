package Test::Classifier::AlwaysPass;
use Moose;
extends 'Classifier';

sub default_tags { qw(test alwayspass) }
sub default_type { 'alwayspassed' }

sub consider {
  my ($self, $text) = @_;

  $self->pass;
}

1;
