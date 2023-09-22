import '../constants.dart';
import '../range.dart';

const _singleCharacterPlaceholder = '_';

/// Creates an SQL LIKE pattern that matches a [keyPartRange] of the key and starts with the given
/// [attemptKeyPart].
///
/// For example:
/// ```dart
/// createKeyPattern(attemptKeyPart: '123', keyPartRange: (4, 8))
///   > ____123_________________________
/// // pattern starts from 4, puts the attemptKeyPart and pads its missing characters with '_' char.
/// // to place the attemptKeyPart in its place in the pattern, the '_' characters are used again.
/// ```
String createKeyPattern({required String attemptKeyPart, required Range keyPartRange}) {
  final (from, to) = keyPartRange;
  final targetKeyPartLength = keyPartRange.length;
  final missingCharsLength = targetKeyPartLength - attemptKeyPart.length;

  assert(targetKeyPartLength > 0 && targetKeyPartLength <= keyLength);
  assert(from < to);
  assert(from >= 0 && from < keyLength);
  assert(to > 0 && to <= keyLength + 1);
  assert(missingCharsLength >= 0);

  final fromWidth = attemptKeyPart.length + from;

  return attemptKeyPart
      .padLeft(fromWidth, _singleCharacterPlaceholder)
      .padRight(fromWidth + keyLength - to + 1 + missingCharsLength, _singleCharacterPlaceholder);
}
