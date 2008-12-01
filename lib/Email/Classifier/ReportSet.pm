use strict;
use warnings;

package Classifier::ReportSet;

use List::MoreUtils ();

sub new {
  my ($class, $reports) = @_;

  bless $reports => $class;
}

sub reports {
  my ($self) = @_;
  return @$self;
}

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

1;
