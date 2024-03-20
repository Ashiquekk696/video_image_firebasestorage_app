import 'dart:convert';
import 'dart:io';
import 'package:assignment1/helpers/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http; 

import '../constants/endpoints.dart';



class ApiBaseHelper {  
Future<dynamic> get(String endPoint) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(ApiEndpoints.baseUrl+endPoint));
      responseJson = _returnResponse(response);
    } on SocketException {
              Fluttertoast.showToast(msg:"No internet connection !!!",
       textColor: Colors.white); 
    }
    on UnauthorisedException{
      Fluttertoast.showToast(msg:"Unauthorised !!!",
       textColor: Colors.white); 
    }
    return responseJson;
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      print(responseJson);
   return responseJson; 
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
  
}
}


