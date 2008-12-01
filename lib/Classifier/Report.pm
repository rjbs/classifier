package Classifier::Report;
use Moose;

has type     => (is => 'ro');
has tags     => (is => 'ro', isa => 'ArrayRef', auto_deref => 1);
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

  sub new_match {
    my $class = shift;
    local $hack{is_match} = 1;
    return $class->new(@_);
  }

  sub new_reject {
    my $class = shift;
    local $hack{is_match} = 0;
    return $class->new(@_);
  }
}

sub is_match  { return   $_[0]->_is_match }
sub is_reject { return ! $_[0]->_is_match }

__PACKAGE__->meta->make_immutable;
no Moose;
1;
