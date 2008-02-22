use strict;
use warnings;

package Test::Email::Classifier::SimpleTest;
use base 'Email::Classifier';

sub default_tags { qw(test simpletest) }
sub default_type { 'simpletest' }

sub __allowed_args { qw(test) }

sub consider {
  my ($self, $email) = @_;

  my $result = $self->{test}->($email);

  return $self->pass unless defined $result;
  return $self->match({ exact_result => $result }) if $result;
  return $self->match({ exact_result => $result });
}

1;
