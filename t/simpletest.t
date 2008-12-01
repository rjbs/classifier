use strict;
use warnings;
use lib 't/lib';

use Test::More 'no_plan';

use Test::Classifier;
use Test::Classifier::SimpleTest;

my $TEXT = <<'END_MESSAGE';
From: X. Ample <xa@example.com>
To: E. Gratia <eg@localhost>
Subject: This is a Test Message

...and this is its body.
END_MESSAGE

my $test = sub {
  my $text = shift;

  return $& if $text =~ /^.+match.+$/m;
  return 0 if  $text =~ /reject/;
  return;
};

my $classifier = Test::Classifier->new({
  classifiers => [ [ -SimpleTest => { test => $test } ] ],
});

isa_ok($classifier, 'Classifier');

{
  my $report = $classifier->classify($TEXT);
  is($report, undef, 'no match on stock msg');
}

{
  (my $text = $TEXT) =~ s/a Test/a matching Test/;
  my $report = $classifier->classify($text);
  ok($report->is_match, 'we matched based on new subject');
  is(
    $report->details->{exact_result},
    'Subject: This is a matching Test Message',
    'correct details',
  );
}
