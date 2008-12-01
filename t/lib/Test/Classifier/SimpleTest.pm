package Test::Classifier::SimpleTest;
use Moose;
extends 'Classifier';

sub default_tags { qw(test simpletest) }
sub default_type { 'simpletest' }

has test => (
  is   => 'ro',
  isa  => 'CodeRef',
  required => 1,
);

sub consider {
  my ($self, $text) = @_;

  my $result = $self->{test}->($text);

  return $self->pass unless defined $result;
  return $self->match({ exact_result => $result }) if $result;
  return $self->reject({ exact_result => $result });
}

1;
