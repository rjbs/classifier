
use strict;
use warnings;

use inc::Module::Install;

name          ('Email-Classifier');
author        ('Ricardo Signes <rjbs@cpan.org>');
license       ('perl');
all_from      ('lib/Email/Classifier.pm');

requires('Email::Abstract' => 2.10);  # Email::Abstract->new (for testing)
requires('Scalar::Util'    => 0.000); # used for blessed, reftype
requires('List::MoreUtils' => 0.000); # uniq

WriteAll();
