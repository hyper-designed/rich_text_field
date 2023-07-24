import 'package:flutter/material.dart';

import '../default_regexes.dart';
import '../matching.dart';

class StrikeThroughMatch extends EncapsulatedMatch {
  StrikeThroughMatch(
    super.match, {
    required super.opening,
    required super.closing,
    required super.content,
  });

  StrikeThroughMatch.from(EncapsulatedMatch match)
      : this(
          match.match,
          opening: match.opening,
          closing: match.closing,
          content: match.content,
        );
}

class StrikeThroughMatcher extends RichMatcher<StrikeThroughMatch> {
  StrikeThroughMatcher()
      : super(
          regex: strikeThroughRegex,
          matchBuilder: (match) => defaultEncapsulatedMatchBuilder(
            match,
            [
              'strikeThroughOpening',
              'strikeThroughContent',
              'strikeThroughClosing'
            ],
            StrikeThroughMatch.from,
          ),
        );

  @override
  bool canClaimMatch(String match) =>
      match.startsWith('~') && match.endsWith('~');

  @override
  List<InlineSpan> rasterizedStyleBuilder(
    BuildContext context,
    StrikeThroughMatch match,
    RecurMatchBuilder recurMatch,
  ) =>
      [
        TextSpan(
          text: match.content.text,
          style: const TextStyle(decoration: TextDecoration.lineThrough),
        ),
      ];

  @override
  List<InlineSpan> styleBuilder(
    BuildContext context,
    StrikeThroughMatch match,
    RecurMatchBuilder recurMatch,
  ) =>
      [
        TextSpan(
          text: match.opening.text,
          style: const TextStyle(color: Colors.grey),
        ),
        TextSpan(
          text: match.content.text,
          style: const TextStyle(decoration: TextDecoration.lineThrough),
        ),
        TextSpan(
          text: match.closing.text,
          style: const TextStyle(color: Colors.grey),
        ),
      ];
}
