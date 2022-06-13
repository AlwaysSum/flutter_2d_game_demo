import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rpg_game_2d/utils/pomelo_protocol.dart';
import 'package:web_socket_channel/io.dart';

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
          PomeloProtocol.packageTypeHandshake,
          Uint8List.fromList(jsonEncode(params).codeUnits));
      debugPrint("握手：${data}");
      _channel?.sink.add(data);
      _channel?.stream.listen(onData, onError: onError, onDone: onDone);
      // startCountdownTimer();
    }
  }

  ///开启心跳
  void startCountdownTimer() {
    const oneSec = Duration(microseconds: 30);
    debugPrint("开启心跳...");
    callback(timer) async {
      if (_channel == null) {
        initSocket();
      } else {
        // debugPrint("发送心跳...");
        _channel?.sink.add(PomeloProtocol.packageEncode(
            PomeloProtocol.packageTypeHandshakeAck, null));
      }
    }

    //是否开启心跳
    // _timer = Timer.periodic(oneSec, callback);
    //第一次应答
    _channel?.sink.add(PomeloProtocol.packageEncode(
        PomeloProtocol.packageTypeHandshakeAck, null));
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
        var body = const JsonDecoder().convert(event['body'] ?? "{}");
        switch (event['type']) {
          case 1:
            if (body['code'] == 200) {
              debugPrint("---握手成功");
              startCountdownTimer();
            } else {
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

  ///发送一个消息
  void sendMessage(int reqId, String route, String msg) {
    int type =
        reqId > 0 ? PomeloProtocol.typeRequest : PomeloProtocol.typeNotify;

    var compressRoute = false;
    // if (dict && dict[route]) {
    //   route = dict[route];
    //   compressRoute = 1;
    // }
    //发送消息
    var encodeMsg =
        PomeloProtocol.messageEncode(reqId, type, compressRoute, route, msg);
    debugPrint("加密消息 $encodeMsg");
    var sendMsg =
        PomeloProtocol.packageEncode(PomeloProtocol.packageTypeData, encodeMsg);
    debugPrint("最终发送消息 $sendMsg");
    _channel?.sink.add(sendMsg);
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
