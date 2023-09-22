import '../constants.dart';
import '../range.dart';
import 'create_key_pattern.dart';

/// Creates an attack url from the [baseUrl] and [sqlRequest] by adding the strings, and inserts
/// the attempt key pattern into the resulting request.
String makeAttackUrl({
  required String baseUrl,
  required String sqlRequest,
  required String attemptKeyPart,
  required Range keyPartRange,
}) {
  final keyPattern = createKeyPattern(attemptKeyPart: attemptKeyPart, keyPartRange: keyPartRange);

  return '$baseUrl$sqlRequest'.replaceFirst(replacePattern, keyPattern);
}
