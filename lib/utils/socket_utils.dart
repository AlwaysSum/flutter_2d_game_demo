import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rpg_game_2d/utils/pomeoe_protocol.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert' as convert;

class SocketUtils {
  SocketUtils._internal() {}

  static final SocketUtils _socketUtils = SocketUtils._internal();
  IOWebSocketChannel? _channel;
  Timer? _timer;

  factory SocketUtils() {
    return _socketUtils;
  }

  void initSocket() {
    _channel =
        IOWebSocketChannel.connect(Uri.parse("ws://127.0.0.1:3250/nano"));
    Map<String, dynamic> params = <String, dynamic>{};
    // params["userId"] = SpUtils().getUserInfo().appUserDetailsVO.drvId;
    // params["userName"] = SpUtils().getUserInfo().appUserDetailsVO.drvName;
    // params["token"] = SpUtils().getUserInfo().token;
    params["sys"] = {
      "version": "1.0.0",
      "type": "js-websocket",
    };
    params["user"] = {};

    if (_channel != null) {
      var data = PomeloProtocol.packageEncode(
          PomeloProtocol.packageTypeHandshake, convert.jsonEncode(params));
      debugPrint("握手：${data}");
      _channel?.sink.add(data);
      _channel?.stream.listen(onData, onError: onError, onDone: onDone);
      startCountdownTimer();
    }
  }

  ///开启心跳
  void startCountdownTimer() {
    const oneSec = Duration(seconds: 10);
    callback(timer) async {
      if (_channel == null) {
        initSocket();
      } else {
        debugPrint("开启心跳...");
        // if(SpUtils().getUserInfo() != null){
        //   _channel.sink
        //       .add("10002${SpUtils().getUserInfo().appUserDetailsVO.drvId}");
        // }
      }
    }

    _timer = Timer.periodic(oneSec, callback);
  }

  onDone() {
    debugPrint("消息关闭");
    _channel?.sink?.close();
    _channel = null;
  }

  onError(err) {
    debugPrint("消息错误$err");
    _channel?.sink.close();
    _channel = null;
  }

  onData(event) {
    try {
      if (event != null) {
        debugPrint("接收消息--1$event");
        event = PomeloProtocol.packageDecode(event);
        debugPrint("接收消息$event");
        var body = const convert.JsonDecoder().convert(event['body'] ?? "{}");
        switch (event['type']) {
          case 1:
            if (body['code'] == 200) {
              debugPrint("---握手成功");
            }else{
              debugPrint("---握手失败");
            }
            break;
          default:
            debugPrint("---无响应");
            break;
        }


        // switch (event) {
        //   case "10001": //服务器回应正常
        //   case "10002":
        //     break;
        //   case "10005":
        //     this.dispose();
        //     EventBusUtil.getInstance().fire(PageEvent(
        //         eventType: EventBusUtil.UNAUTHORIZED,
        //         data: "已在其他设备上登录\n请重新登录"));
        //     break;
        //   default:
        //     event = convert.jsonDecode(event);
        //     switch (event["msgtype"]) {
        //       //消息类型
        //       case 10006:
        //         //新的通知消息
        //         EventBusUtil.getInstance()
        //             .fire(PageEvent(eventType: EventBusUtil.NEWMESSAGE));
        //         break;
        //
        //       case 20012:
        //         //通知刷新列表
        //         EventBusUtil.getInstance()
        //             .fire(PageEvent(eventType: EventBusUtil.REFRESHORDERLIST));
        //         break;
        //       case 20014:
        //         ///有新订单
        //         EventBusUtil.getInstance()
        //             .fire(PageEvent(eventType: EventBusUtil.NEWORDERMESSAGE));
        //         break;
        //     }
        // }
      }
    } catch (e) {
      debugPrint(e?.toString());
    }
  }

  void dispose() {
    if (_channel != null) {
      _channel?.sink.close();
      debugPrint("socket通道关闭");
      _channel = null;
    }
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }
}
