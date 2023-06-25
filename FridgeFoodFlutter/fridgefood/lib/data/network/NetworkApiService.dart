import 'dart:convert';
import 'dart:io';

import 'package:fridgefood/data/app_exceptions.dart';
import 'package:fridgefood/data/network/BaseApiService.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class NetworkApiServices extends BaseApiServices {
  // GET
  @override
  Future getGetApiResonse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    }
    // when internet is off
    on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

// POST
  @override
  Future getPostApiResonse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      Response response = await post(
        Uri.parse(url),
        body: data,
      ).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    }
    // when internet is off
    on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

// ERROR FUNCTION
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnauthorizedException(response.body.toString());
      default:
        throw FetchDataException(
            "Error Occured while communication with server" "with status code" +
                response.body.toString());
    }
  }
}
