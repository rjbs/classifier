package Classifier::ReportSet;
use Moose;
# ABSTRACT: a set of Classifier::Reports, of course

use List::MoreUtils ();

override BUILDARGS => sub {
  my ($self, @args) = @_;

  return $self->SUPER::BUILDARGS({ reports => $args[0] })
    if @args == 1 and ref $args[0] eq 'ARRAY';

  return super;
};

=attr reports

  my @reports = $set->reports;

The reports attribute contains all the set's Classifier::Report objects.

=cut

has reports => (
  is   => 'ro',
  isa  => 'ArrayRef[Classifier::Report]',
  auto_deref => 1,
  required   => 1,
);

=method matches

This method returns all reports that are matches.

=cut

sub matches {
  my ($self) = @_;
  return grep { $_->is_match } $self->reports;
}

=method rejects

This method returns all reports that are rejects.

=cut

sub rejects {
  my ($self) = @_;
  return grep { $_->is_reject } $self->reports;
}

=method match_tags

This method returns a list of all the tags found on all the set's matching
reports.

=cut

sub match_tags {
  my ($self) = @_;

  return List::MoreUtils::uniq map { $_->tags } $self->matches;
}

=method reject_tags

This method returns a list of all the tags found on all the set's rejecting
reports.

=cut

sub reject_tags {
  my ($self) = @_;

  return List::MoreUtils::uniq map { $_->tags } $self->rejects;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
