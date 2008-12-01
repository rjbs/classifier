use strict;
use warnings;
use lib 't/lib';

use Test::More 'no_plan';

use Test::Classifier;
use Test::Classifier::AlwaysMatch;
use Test::Classifier::AlwaysPass;
use Test::Classifier::AlwaysReject;

my $TEXT = <<'END_MESSAGE';
From: X. Ample <xa@example.com>
To: E. Gratia <eg@localhost>
Subject: This is a Test Message

...and this is its body.
END_MESSAGE

is(Classifier->_expand_class('-Foo'), 'Classifier::Foo', 'basic expando test');

{
  my $classifier = Test::Classifier->new({
    classifiers => [ qw(-AlwaysPass -AlwaysMatch) ],
  });

  isa_ok($classifier, 'Classifier');

  my $report = $classifier->classify($TEXT);

  isa_ok($report, 'Classifier::Report');
  ok($report->is_match, 'the report is a match');
  is($report->type, 'alwaysmatched', 'got the the correct report type');

  my $details = $report->details;
  is($details->{match_number}, 1, "we got the first match from AlwaysMatch");
  is_deeply(
    [ sort $report->tags ],
    [ qw(alwaysmatch test) ],
    'got the expected tags',
  );
}

{
  my $classifier = Test::Classifier->new({
    classifiers => [ qw(-AlwaysPass -AlwaysReject) ],
  });

  isa_ok($classifier, 'Classifier');

  my $report = $classifier->classify($TEXT);
  is($report, undef, "with only pass and reject, we get no report");
}

{
  my $classifier = Test::Classifier->new({
    classifiers => [ qw(
      -AlwaysReject -AlwaysPass
      Test::Classifier::AlwaysMatch
    ) ],
  });

  isa_ok($classifier, 'Classifier');

  my $report = $classifier->classify($TEXT);

  isa_ok($report, 'Classifier::Report');
  ok($report->is_match, 'the report is a match');
  is($report->type, 'alwaysmatched', 'got the the correct report type');

  my $details = $report->details;
  is($details->{match_number}, 2, "this is the second match from AlwaysMatch");
  is_deeply(
    [ sort $report->tags ],
    [ qw(alwaysmatch test) ],
    'got the expected tags',
  );

  my $report_set = $classifier->analyze($TEXT);

  my ($reject_report, $match_report, @rest) = $report_set->reports;
  is(@rest, 0, 'only two reports in the set');

  ok($reject_report->is_reject, 'first report is a reject');
  ok($match_report->is_match,   'second report is a match');

  my @matches = $report_set->matches;
  is(@matches, 1, "one match in ->matches");
  ok($matches[0] == $match_report, "and it's the one we saw earlier");

  my @rejects = $report_set->rejects;
  is(@rejects, 1, "one reject in ->rejects");
  ok($rejects[0] == $reject_report, "and it's the one we saw earlier");

  is_deeply(
    [ sort $report_set->match_tags ],
    [ qw(alwaysmatch test)     ],
    "->match_tags",
  );

  is_deeply(
    [ sort $report_set->reject_tags ],
    [ qw(alwaysreject test)   ],
    "->reject_tags",
  );
}
