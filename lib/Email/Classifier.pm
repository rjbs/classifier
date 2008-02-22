use strict;
use warnings;

package Email::Classifier;
use Email::Classifier::Report;
use Email::Classifier::ReportSet;
use Scalar::Util ();

sub classifier_base_namespace { 'Email::Classifier' }

sub __allowed_args {} # XXX: total hack for now -- rjbs, 2008-02-22

sub new {
  my ($class, $arg) = @_;
  $arg ||= {};

  my $self = bless {} => $class;

  for my $c_spec (@{ $arg->{classifiers} }) {
    $self->add_classifier($c_spec);
  }

  $self->{$_} = $arg->{$_} for $class->__allowed_args;

  return $self;
}

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

sub add_classifier {
  my ($self, $c_spec) = @_;

  my $classifiers = $self->{classifiers} ||= [];
  my @args;

  if (defined (my $reftype = Scalar::Util::reftype $c_spec)) {
    if (!Scalar::Util::blessed $c_spec and $reftype eq 'ARRAY') {
      # XXX: This will be richer in the future. -- rjbs, 2008-02-22
      Carp::confess "invalid classifier specification: [ @$c_spec ]"
        unless @$c_spec == 2;

      ($c_spec, @args) = @$c_spec;
    } else {
      Carp::confess "invalid classifier specification: $c_spec";
    }
  }

  my $c_class = $self->_expand_class($c_spec);
  push @$classifiers, $c_class->new(@args);
}

sub classify {
  my ($self, $email) = @_;

  for my $classifier ($self, @{ $self->{classifiers} }) {
    my $result = $classifier->consider($email);
    return $result if $result and $result->is_match;
  }

  return;
}

sub analyze {
  my ($self, $email) = @_;

  my @reports;
  push @reports, $self->consider($email);

  for my $classifier (@{ $self->{classifiers} }) {
    push @reports, $classifier->analyze($email)->reports;
  }

  return Email::Classifier::ReportSet->new(\@reports);
}

sub match {
  my ($self, $details) = @_;

  return Email::Classifier::Report->new_match({
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

  return Email::Classifier::Report->new_reject({
    tags    => [ $self->default_tags ],
    type    => $self->default_type,
    details => $details,
  });
}

1;
