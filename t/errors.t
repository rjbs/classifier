use strict;
use warnings;
use lib 't/lib';

use Test::More 'no_plan';

use Test::Classifier;
use Test::Classifier::AlwaysMatch;
use Test::Classifier::AlwaysPass;
use Test::Classifier::AlwaysReject;

{
  eval {
    my $classifier = Test::Classifier->new({
      classifiers => [ sub{} ],
    });
  };

  like($@, qr/invalid classifier/, "can't use coderef as classifier spec");

  eval {
    my $x = bless [] => 'whatever';
    my $classifier = Test::Classifier->new({
      classifiers => [ $x ],
    });
  };

  like($@, qr/invalid classifier/, "can't use blessed arrayref");
}
