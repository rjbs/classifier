package Classifier;
use Moose;

our $VERSION = '0.001';

use Carp ();
use Classifier::Report;
use Classifier::ReportSet;
use Scalar::Util ();

sub classifier_base_namespace { 'Classifier' }

override BUILDARGS => sub {
  my ($self, @args) = @_;
  my $args = super;

  if (my $c = $args->{classifiers}) {
    $args->{classifiers} = [ map { $self->_classifier_from_spec($_) } @$c ];
  }

  return $args;
};

has classifiers => (
  is  => 'ro',
  isa => 'ArrayRef[Classifier]',
  auto_deref => 1,
  default    => sub { [] },
);

sub consider {
  return $_[0]->pass;
}

sub _expand_class {
  my ($self, $class) = @_;

  if (substr($class, 0, 1) eq '-') {
    my $prefix = $self->classifier_base_namespace;
    substr($class, 0, 1, "$prefix\::")
  }

  return $class;
}

sub _classifier_from_spec {
  my ($self, $c_spec) = @_;

  my @args;

  if (defined (my $reftype = Scalar::Util::reftype $c_spec)) {
    if (!Scalar::Util::blessed $c_spec and $reftype eq 'ARRAY') {
      # XXX: This will be richer in the future. -- rjbs, 2008-02-22
      Carp::confess("invalid classifier specification: [ @$c_spec ]")
        unless @$c_spec == 2;

      ($c_spec, @args) = @$c_spec;
    } else {
      Carp::confess("invalid classifier specification: $c_spec");
    }
  }

  my $c_class = $self->_expand_class($c_spec);
  return $c_class->new(@args);
}

sub classify {
  my ($self, $email) = @_;

  for my $classifier ($self, $self->classifiers) {
    my $result = $classifier->consider($email);
    return $result if $result and $result->is_match;
  }

  return;
}

sub analyze {
  my ($self, $email) = @_;

  my @reports;
  push @reports, $self->consider($email);

  for my $classifier ($self->classifiers) {
    push @reports, $classifier->analyze($email)->reports;
  }

  return Classifier::ReportSet->new(\@reports);
}

sub match {
  my ($self, $details) = @_;

  return Classifier::Report->new_match({
    tags    => [ $self->default_tags ],
    type    => $self->default_type,
    details => $details,
  });
}

sub pass {
  return;
}

sub reject {
  my ($self, $details) = @_;

  return Classifier::Report->new_reject({
    tags    => [ $self->default_tags ],
    type    => $self->default_type,
    details => $details,
  });
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
