import 'package:flutter/material.dart';

import '../default_regexes.dart';
import '../matching.dart';

class BoldMatch extends EncapsulatedMatch {
  const BoldMatch(
    super.match, {
    required super.openingChar,
    required super.closingChar,
    required super.content,
  });
}

final RichMatcher boldMatcher = RichMatcher<BoldMatch>(
  regex: boldRegex,
  formatSelection: (TextEditingValue value, String selectedText) =>
      value.copyWith(
    text: value.text.replaceFirst(selectedText, '*$selectedText*'),
    selection: value.selection.copyWith(
      baseOffset: value.selection.baseOffset + 1,
      extentOffset: value.selection.extentOffset + 1,
    ),
  ),
  styleBuilder: (context, match, style) => [
    TextSpan(
      text: match.openingChar.text,
      style: const TextStyle(color: Colors.grey),
    ),
    TextSpan(
      text: match.content.text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    TextSpan(
      text: match.closingChar.text,
      style: const TextStyle(color: Colors.grey),
    ),
  ],
  rasterizedStyleBuilder: (context, match, style) => [
    TextSpan(
      text: match.content.text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ],
  matchBuilder: (RegExpMatch match) {
    final openingChar = match.group(1)!;
    final contentString = match.group(2)!;
    final closingChar = match.group(3)!;

    final TextEditingValue opening = TextEditingValue(
      text: openingChar,
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
    final TextEditingValue closing = TextEditingValue(
      text: closingChar,
      selection: TextSelection.collapsed(
        offset: match.end - 1,
      ),
    );

    return BoldMatch(
      match,
      openingChar: opening,
      closingChar: closing,
      content: content,
    );
  },
);
