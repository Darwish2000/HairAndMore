import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

import 'apiPaths.dart';

/// all api calls to our api pass through these.
/// offers easy-to-use api calls, with retries.
class RestApiService {
  static var apiHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  /// Fires a Get request to an endpoint('path')
  /// Note that query params MUST BE STRINGS or lists of strings.
  static Future<http.Response> get(String path,
      [Map<String, dynamic> queryParams = const {}]) async {
    final url = Uri.https(ApiPaths.base, path, queryParams);
    print('url is $url');
    return retry(
        () => http.get(url, headers: apiHeaders).timeout(Duration(seconds: 4)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
        maxAttempts: 4);
  }

  static Future<http.Response> post(String path,
      [Object? requestBody,
      Map<String, dynamic> queryParams = const {}]) async {
    final url = Uri.https(ApiPaths.base, path, queryParams);
    print('post url is $url');
    log('post url payload is $requestBody');
    return retry(
        () => http
            .post(url, headers: apiHeaders, body: jsonEncode(requestBody))
            .timeout(Duration(seconds: 4)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
        maxAttempts: 4);
  }

  static Future<http.Response> put(String path,
      [Object? requestBody,
      Map<String, dynamic> queryParams = const {}]) async {
    final url = Uri.https(ApiPaths.base, path, queryParams);
    print(url);
    print(requestBody);
    return retry(
        () => http
            .put(url, headers: apiHeaders, body: jsonEncode(requestBody))
            .timeout(Duration(seconds: 4)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
        maxAttempts: 4);
  }

  static Future<http.Response> patch(String path,
      [Object? requestBody,
      Map<String, dynamic> queryParams = const {}]) async {
    final url = Uri.https(ApiPaths.base, path, queryParams);
    print(url);
    print(requestBody);
    return retry(
        () => http
            .patch(url, headers: apiHeaders, body: jsonEncode(requestBody))
            .timeout(Duration(seconds: 4)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
        maxAttempts: 4);
  }

  static Future<http.Response> delete(String path,
      [Object? requestBody,
      Map<String, dynamic> queryParams = const {}]) async {
    final url = Uri.https(ApiPaths.base, path, queryParams);
    return retry(
        () => http
            .delete(url, headers: apiHeaders, body: jsonEncode(requestBody))
            .timeout(Duration(seconds: 4)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
        maxAttempts: 4);
  }
}
