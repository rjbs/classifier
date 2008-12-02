package Classifier::Report;
use Moose;
# ABSTRACT: a report from a Classifier

=attr type

A report's type is a simple string that indicates what kind of report it is.
It has no magical meaning.  By default, a string's type is the name of the
class of the generating report, but this is hardly guaranteed.  You should
consult the documentation for the classifier you are using to see what type it
will issue.

=attr tags

A report's tags are strings that further identify a report.

=attr details

The details attribute is where most of the juicy information about a report
will be stored.  It may be any kind of value, and each classifier is free to
choose what kind of data to report in the details.  Consult your classifier's
manual.

=cut

has type     => (is => 'ro', isa => 'Str', required => 1);
has tags     => (is => 'ro', isa => 'ArrayRef[Str]', auto_deref => 1);
has details  => (is => 'ro');

{
  my %hack;
  has _is_match => (
    is  => 'ro',
    isa => 'Bool',
    init_arg => undef,
    required => 1,
    default  => sub {
      defined $hack{is_match}
        ? $hack{is_match}
        : confess("call new_match or new_reject")
    },
  );

=method new_match

This constructor produces a matching report.

=cut

  sub new_match {
    my $class = shift;
    local $hack{is_match} = 1;
    return $class->new(@_);
  }

=method new_reject

This constructor produces a rejecting report.

=cut

  sub new_reject {
    my $class = shift;
    local $hack{is_match} = 0;
    return $class->new(@_);
  }
}

=method is_match

This predicate indicates whether the report is a matching report.

=method is_reject

This predicate indicates whether the report is a rejecting report.

=cut

sub is_match  { return   $_[0]->_is_match }
sub is_reject { return ! $_[0]->_is_match }

__PACKAGE__->meta->make_immutable;
no Moose;
1;
