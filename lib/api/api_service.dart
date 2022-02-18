import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'network_util.dart';

class ApiService {
  final NetworkUtil _netUtil = NetworkUtil();
  static final _apiService = ApiService();
  static var basicHeaders;
  static const generalErrorMessage =
      "Something went wrong checking phone number, try again later.";
  static const noInternetConnection =
      "It appears you are offline, connect and try again.";

  static ApiService get(String token) {
    basicHeaders = {"Authorization": "Bearer $token"};
    return _apiService;
  }

  //MARK: get list of items
  /// @url, url to fetch data
  Future<dynamic> getData(String url) {
    return _netUtil.get(url, basicHeaders, utf8).then((dynamic data) {
      var statusCode = data["response_code"].toString();
      if (statusCode.isNotEmpty) {
        return data;
      } else {
        throw Exception(
            data["message"] != null ? data["detail"] : data.toString());
      }
    });
  }

  //MARK: post data
  /// @url, url to fetch data
  Future<dynamic> postDataNoHeader(String url, Map<String, String> data) {
    Map<String, String> emptyHeader = {};
    return _netUtil.post(url, emptyHeader, data, utf8).then((dynamic data) {
      var statusCode = data["response_code"].toString();
      if (statusCode.isNotEmpty) {
        return data;
      } else {
        throw Exception(data["message"] != null
            ? data["message"].toString()
            : data.toString());
      }
    });
  }

  //MARK: post data
  /// @url, url to fetch data
  Future<dynamic> postData(String url, Map<String, String> data) {
    return _netUtil.post(url, basicHeaders, data, utf8).then((dynamic data) {
      var statusCode = data["response_code"].toString();
      if (statusCode.isNotEmpty) {
        return data;
      } else {
        throw Exception(data["detail"] ?? data.toString());
      }
    });
  }

  //MARK: post data
  /// @url, url to fetch data
  Future<dynamic> deleteData(String url, Map<String, String> data) {
    return _netUtil.delete(url, basicHeaders, data).then((dynamic data) {
      var statusCode = data["response_code"].toString();
      if (statusCode.isNotEmpty) {
        return data;
      } else {
        throw Exception(data["detail"] ?? data.toString());
      }
    });
  }

  //MARK: put data
  /// @url, url to fetch data
  Future<dynamic> putData(String url, Map<String, String> data) {
    return _netUtil.put(url, basicHeaders, data, utf8).then((dynamic data) {
      var statusCode = data["response_code"].toString();
      if (statusCode.isNotEmpty) {
        return data;
      } else {
        throw Exception(data["detail"] ?? data.toString());
      }
    });
  }

  //MARK: upload image to server
  Future<dynamic> uploadAvatar(String httpMethod, String url, String uploadKey,
      File imageFile, Map<String, String> data) {
    return _netUtil
        .uploadFile(
            httpMethod, url, imageFile, uploadKey, basicHeaders, data, utf8)
        .then((dynamic data) {
      var statusCode = data["response_code"].toString();
      if (statusCode.isNotEmpty) {
        return data;
      } else {
        throw Exception(data["detail"] ?? data.toString());
      }
    });
  }
}
