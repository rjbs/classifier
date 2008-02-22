use strict;
use warnings;

package Email::Classifier::Report;

sub _new {
  my ($class, $arg) = @_;
  my $guts = {
    type => $arg->{type},
    tags => $arg->{tags},
    details => $arg->{details},
  };

  return bless $guts => $class;
}

sub new_match {
  my ($class, $arg) = @_;
  my $self = $class->_new($arg);

  $self->{is_match} = 1;

  return $self;
}

sub new_reject {
  my ($class, $arg) = @_;
  return $class->_new($arg);
}

sub is_match {
  return ! ! $_[0]->{is_match};
}

sub is_reject {
  return ! $_[0]->{is_match};
}

sub details {
  return $_[0]->{details}
}

sub tags {
  my ($self) = @_;
  return @{ $self->{tags} };
}

sub type {
  my ($self) = @_;
  return $self->{type};
}

1;
