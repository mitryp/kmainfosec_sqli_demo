import 'package:http/http.dart' as http hide get;

import '../constants.dart';
import '../http_get.dart' as http;

part 'bool_attack.dart';

part 'error_attack.dart';

/// An interface defining the Attack class family with the [sqlRequest] getter for sql string to be
/// inserted into the request and [makeValidatedGuess] method for for making the request and
/// returning the whether the response was successful.
abstract interface class Attack {
  /// Makes an http request to the [url] and returns true if the [attemptKeyPattern] is actual
  /// substring of the key therefore signalling that the guess was validated, otherwise, returns
  /// false.
  Future<bool> makeValidatedGuess({required String url, required String attemptKeyPattern});

  /// Returns the string of the sql request to be inserted into the request for the attack to
  /// be executed.
  /// As a rule, one would want the request to contain the [replacePattern] for it to be replaced
  /// with the attempt key pattern during the attack.
  String get sqlRequest;
}
