use strict;
use warnings;
use lib 't/lib';

use Test::More 'no_plan';

use Email::Abstract;
use Test::Email::Classifier;
use Test::Email::Classifier::SimpleTest;

my $TEXT = <<'END_MESSAGE';
From: X. Ample <xa@example.com>
To: E. Gratia <eg@localhost>
Subject: This is a Test Message

...and this is its body.
END_MESSAGE

my $email = Email::Abstract->new($TEXT);

my $test = sub {
  my $email = shift;
  my $subj = $email->get_header('Subject');

  return $subj if $subj =~ /match/;
  return 0     if $subj =~ /reject/;
  return;
};

my $classifier = Test::Email::Classifier->new({
  classifiers => [ [ -SimpleTest => { test => $test } ] ],
});

isa_ok($classifier, 'Email::Classifier');

{
  my $report = $classifier->classify($email);
  is($report, undef, 'no match on stock msg');
}

{
  $email->set_header(Subject => 'This will match');
  my $report = $classifier->classify($email);
  ok($report->is_match, 'we matched based on new subject');
  is($report->details->{exact_result}, 'This will match', 'correct details');
}
