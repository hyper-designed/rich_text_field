import 'dart:math';

import 'package:flutter/material.dart';

import '../default_regexes.dart';
import '../matching.dart';

class HeadingMatch extends RichMatch {
  final TextEditingValue hashtags;
  final TextEditingValue content;

  HeadingMatch(
    super.match, {
    required this.hashtags,
    required this.content,
  });
}

class HeadingMatcher extends RichMatcher<HeadingMatch> {
  HeadingMatcher()
      : super(
          regex: headingRegex,
          matchBuilder: (RegExpMatch match) {
            final hashtagsString = match.namedGroup('headingHashtags')!;
            final contentString = match.namedGroup('headingContent')!;

            final TextEditingValue hashtags = TextEditingValue(
              text: hashtagsString,
              selection: TextSelection.collapsed(
                offset: match.start,
              ),
            );
            final TextEditingValue content = TextEditingValue(
              text: contentString,
              selection: TextSelection.collapsed(
                offset: match.start + match.end - 2,
              ),
            );

            return HeadingMatch(match, hashtags: hashtags, content: content);
          },
        );

  @override
  bool canClaimMatch(String match) => match.startsWith('#');

  @override
  List<InlineSpan> rasterizedStyleBuilder(
    BuildContext context,
    HeadingMatch match,
    RecurMatchBuilder recurMatch,
  ) {
    final hashtagCount = min(6, match.hashtags.text.replaceAll(' ', '').length);

    // font size should be inverse of hashtag count. maximum hashtags for
    // smallest title is 6.
    final fontSize = 16 + (6 - hashtagCount) * 2.0;
    return [
      TextSpan(
        text: match.content.text,
        style: TextStyle(fontSize: fontSize),
      ),
    ];
  }

  @override
  List<InlineSpan> styleBuilder(
    BuildContext context,
    HeadingMatch match,
    RecurMatchBuilder recurMatch,
  ) {
    final hashtagCount = min(6, match.hashtags.text.replaceAll(' ', '').length);

    // font size should be inverse of hashtag count. maximum hashtags for
    // smallest title is 6.
    final fontSize = 16 + (6 - hashtagCount) * 2.0;

    return [
      TextSpan(
        text: match.hashtags.text,
        style: const TextStyle(color: Colors.grey),
      ),
      TextSpan(
        text: match.content.text,
        style: TextStyle(fontSize: fontSize),
      ),
    ];
  }
}
