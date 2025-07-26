import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'constants.dart';

enum Environment { test, live }

extension EnvExt on Environment {
  String parse() => this == Environment.live ? 'live' : 'test';
}

class EsewaConfig {
  final String clientId;
  final String secretId;
  final Environment environment;

  EsewaConfig({
    required this.clientId,
    required this.secretId,
    required this.environment,
  });

  Map<String, dynamic> toMap() => {
        "client_id": this.clientId,
        "client_secret": this.secretId,
        "environment": this.environment.parse(),
      };
}

class EsewaPayment {
  final String productId;
  final String productName;
  final String productPrice;
  final String callbackUrl;

  EsewaPayment({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.callbackUrl,
  });

  Map<String, dynamic> toMap() => {
        "product_id": this.productId,
        "product_name": this.productName,
        "product_price": this.productPrice,
        "callback_url": this.callbackUrl,
      };
}

class EsewaPaymentSuccessResult {
  final String productId;
  final String productName;
  final String totalAmount;
  final String environment;
  final String code;
  final String merchantName;
  final String message;
  final String status;
  final String date;
  final String refId;

  EsewaPaymentSuccessResult({
    required this.productId,
    required this.productName,
    required this.totalAmount,
    required this.environment,
    required this.code,
    required this.merchantName,
    required this.message,
    required this.status,
    required this.date,
    required this.refId,
  });

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "totalAmount": totalAmount,
        "environment": environment,
        "code": code,
        "merchantName": merchantName,
        "message": message,
        "status": status,
        "date": date,
        "refId": refId,
      };
}

class EsewaFlutterSdk {
  static const MethodChannel _channel =
      const MethodChannel(METHOD_CHANNEL_NAME);

  static void showToast(String message) {
    _channel.invokeMethod('showToast', {"message": message});
  }

  static void initPayment({
    required EsewaConfig esewaConfig,
    required EsewaPayment esewaPayment,
    required Function(EsewaPaymentSuccessResult) onPaymentSuccess,
    required Function onPaymentFailure,
    required Function onPaymentCancellation,
  }) {
    _channel.invokeMethod(
        'initPayment', _buildArgs(esewaConfig, esewaPayment));
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case PAYMENT_METHOD_SUCCESS:
          print(":::METHOD CALL RESULT SUCCESS");
          final Map<String, dynamic> result;
          if (Platform.isIOS) {
            result = Map<String, dynamic>.from(call.arguments);
          } else {
            result = json.decode(call.arguments);
          }
          final EsewaPaymentSuccessResult paymentResult = EsewaPaymentSuccessResult(
            productId: result["productID"] ?? result["productId"],
            productName: result["productName"],
            totalAmount: result["totalAmount"],
            environment: result["environment"],
            code: result["code"],
            merchantName: result["merchantName"],
            message: result["message"]["successMessage"],
            status: result["transactionDetails"]["status"],
            date: result["transactionDetails"]["date"],
            refId: result["transactionDetails"]["referenceId"],
          );
          onPaymentSuccess(paymentResult);
          break;
        case PAYMENT_METHOD_FAILURE:
          print(":::METHOD CALL RESULT FAILURE");
          onPaymentFailure(call.arguments);
          break;
        case PAYMENT_METHOD_CANCELLATION:
          print(":::METHOD CALL RESULT CANCELLATION");
          onPaymentCancellation(call.arguments);
          break;
      }
    });
  }

  static Map<String, dynamic> _buildArgs(
    EsewaConfig esewaConfig,
    EsewaPayment esewaPayment,
  ) =>
      {
        ARGS_KEY_CONFIG: esewaConfig.toMap(),
        ARGS_KEY_PAYMENT: esewaPayment.toMap(),
      };
}
