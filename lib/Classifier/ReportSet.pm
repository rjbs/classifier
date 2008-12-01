package Classifier::ReportSet;
use Moose;

use List::MoreUtils ();

override BUILDARGS => sub {
  my ($self, @args) = @_;

  return $self->SUPER::BUILDARGS({ reports => $args[0] })
    if @args == 1 and ref $args[0] eq 'ARRAY';

  return super;
};

has reports => (
  is   => 'ro',
  isa  => 'ArrayRef[Classifier::Report]',
  auto_deref => 1,
  required   => 1,
);

sub matches {
  my ($self) = @_;
  return grep { $_->is_match } $self->reports;
}

sub rejects {
  my ($self) = @_;
  return grep { $_->is_reject } $self->reports;
}

sub match_tags {
  my ($self) = @_;

  return List::MoreUtils::uniq map { $_->tags } $self->matches;
}

sub reject_tags {
  my ($self) = @_;

  return List::MoreUtils::uniq map { $_->tags } $self->rejects;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
