use strict;
use warnings;

package Test::Email::Classifier;
use base 'Email::Classifier';

sub classifier_base_namespace { 'Test::Email::Classifier' }

1;
