use strict;
use warnings;

package Test::Classifier::SimpleTest;
use base 'Classifier';

sub default_tags { qw(test simpletest) }
sub default_type { 'simpletest' }

sub __allowed_args { qw(test) }

sub consider {
  my ($self, $text) = @_;

  my $result = $self->{test}->($text);

  return $self->pass unless defined $result;
  return $self->match({ exact_result => $result }) if $result;
  return $self->reject({ exact_result => $result });
}

1;
