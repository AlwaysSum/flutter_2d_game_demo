import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

///pomelo 通信协议
class PomeloProtocol {
  static const pkgHeaderBytes = 4;
  static const packageTypeHandshake = 1;
  static const packageTypeHandshakeAck = 2;
  static const packageTypeHeartbeat = 3;
  static const packageTypeData = 4;
  static const packageTypeKick = 5;

  ///packaage
  static packageEncode(int type, String? body) {
    var length = body?.length ?? 0;

    var buffer = Uint8List(pkgHeaderBytes + length);
    var index = 0;
    buffer[index++] = type & 0xff;
    buffer[index++] = (length >> 16) & 0xff;
    buffer[index++] = (length >> 8) & 0xff;
    buffer[index++] = length & 0xff;
    if (body != null) {
      for (var code in body.codeUnits) {
        buffer[index++] = code;
      }
    }
    return buffer;
  }

  /// packageDecode
  static packageDecode(Uint8List bytes) {
    var offset = 0;
    var length = 0;
    var rs = [];
    while (offset < bytes.length) {
      var type = bytes[offset++];
      length = ((bytes[offset++]) << 16 |
              (bytes[offset++]) << 8 |
              bytes[offset++]) >>>
          0;
      var body = length > 0 ? Uint8List(length) : null;
      if (body != null) {
        for (var i = 0; i < body.length; i++) {
          body[i] = bytes[offset + i];
        }
      }
      offset += length;
      rs.add({'type': type, 'body': body != null ? strdecode(body) : null});
    }
    return rs.length == 1 ? rs[0] : rs;
  }

  static strdecode(Uint8List bytes) {
    // // List<int> array = [];
    // var result = "";
    // var offset = 0;
    // var charCode = 0;
    // var end = bytes.length;
    // while (offset < end) {
    //   if (bytes[offset] < 128) {
    //     charCode = bytes[offset];
    //     offset += 1;
    //   } else if (bytes[offset] < 224) {
    //     charCode = ((bytes[offset] & 0x3f) << 6) + (bytes[offset + 1] & 0x3f);
    //     offset += 2;
    //   } else {
    //     charCode = ((bytes[offset] & 0x0f) << 12) +
    //         ((bytes[offset + 1] & 0x3f) << 6) +
    //         (bytes[offset + 2] & 0x3f);
    //     offset += 3;
    //   }
    //   // array.add(charCode);
    //   result += String.fromCharCode(charCode);
    // }
    // // debugPrint("----$array");
    // // var str = String.fromCharCode(array);
    // // debugPrint(str);
    // debugPrint("----$result");
    // return result;
    return const Utf8Decoder().convert(bytes);
  }
}
