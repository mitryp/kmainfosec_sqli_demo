import 'dart:io';

import 'package:http/http.dart' as http;

Future<http.Response> get(Uri url) => http.get(url, headers: {
      HttpHeaders.userAgentHeader: 'KMAINFOSEC-AGENT',
    });
