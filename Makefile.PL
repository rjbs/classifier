
use strict;
use warnings;

use inc::Module::Install;

name          ('Classifier');
author        ('Ricardo Signes <rjbs@cpan.org>');
license       ('perl');
all_from      ('lib/Classifier.pm');

requires('Scalar::Util'    => 0.000); # used for blessed, reftype
requires('List::MoreUtils' => 0.000); # uniq

WriteAll();
