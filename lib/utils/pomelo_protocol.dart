import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

///pomelo 通信协议
class PomeloProtocol {
  static const pkgHeaderBytes = 4;
  static const msgFlagBytes = 1;
  static const msgRouteCodeBytes = 2;
  static const msgRouteLenBytes = 1;
  static const msgCompressRouteMask = 0x1;
  static const msgTypeMask = 0x7;

  static const packageTypeHandshake = 1;
  static const packageTypeHandshakeAck = 2;
  static const packageTypeHeartbeat = 3;
  static const packageTypeData = 4;
  static const packageTypeKick = 5;

  static const typeRequest = 0;
  static const typeNotify = 1;
  static const typeResponse = 2;
  static const typePush = 3;

  static const msgRouteCodeMax = 0xffff;

  ///packaage
  static packageEncode(int type, Uint8List? body) {
    var length = body?.length ?? 0;

    var buffer = Uint8List(pkgHeaderBytes + length);
    var index = 0;
    buffer[index++] = type & 0xff;
    buffer[index++] = (length >> 16) & 0xff;
    buffer[index++] = (length >> 8) & 0xff;
    buffer[index++] = length & 0xff;
    if (body != null) {
      for (var code in body) {
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
      rs.add({
        'type': type,
        'body': body != null ? const Utf8Decoder().convert(body) : null
      });
    }
    return rs.length == 1 ? rs[0] : rs;
  }

  ///
  ///加密encode
  static messageEncode(
      int id, int type, bool compressRoute, dynamic route, String msg) {
    // caculate message max length
    var idBytes = _msgHasId(type) ? _caculateMsgIdBytes(id) : 0;
    var msgLen = msgFlagBytes + idBytes;

    Uint8List routeBytes = Uint8List(route.length);
    if (_msgHasRoute(type)) {
      if (compressRoute) {
        msgLen += msgRouteCodeBytes;
      } else {
        msgLen += msgRouteLenBytes;
        if (route.isNotEmpty) {
          routeBytes = const Utf8Encoder().convert(route);
          if (route.length > 255) {
            throw 'route maxlength is overflow';
          }
          msgLen += routeBytes.length;
        }
      }
    }

    if (msg.isNotEmpty) {
      msgLen += msg.length;
    }

    var buffer = Uint8List(msgLen.toInt());
    var offset = 0;

    // add flag
    offset = _encodeMsgFlag(type, compressRoute, buffer, offset);

    print("加密 flag----> $offset  $buffer");
    // add message id
    if (_msgHasId(type)) {
      offset = _encodeMsgId(id, buffer, offset);
    }
    print("加密 id----> $offset    $buffer");

    // add route
    if (_msgHasRoute(type)) {
      offset = _encodeMsgRoute(
          compressRoute, compressRoute ? route : routeBytes, buffer, offset);
    }
    print("加密 root $type----> $offset    $buffer");
    // add body
    if (msg.isNotEmpty) {
      offset = _encodeMsgBody(msg, buffer, offset);
    }
    return buffer;
  }

  ///消息解密
  static messageDecode(Uint8List bytes) {
    var bytesLen = bytes.lengthInBytes;
    var offset = 0;
    var id = 0;
    var route; //路由

    // parse flag
    var flag = bytes[offset++];
    var compressRoute = (flag & msgCompressRouteMask)==1;
    var type = (flag >> 1) & msgTypeMask;

    // parse id
    if (_msgHasId(type)) {
      var m = bytes[offset].toInt();
      var i = 0;
      do {
        var m = bytes[offset].toInt();
        id = id + ((m & 0x7f) * pow(2, (7 * i)).toInt());
        offset++;
        i++;
      } while (m >= 128);
    }

    // parse route
    if (_msgHasRoute(type)) {
      if (compressRoute) {
        route = (bytes[offset++]) << 8 | bytes[offset++];
      } else {
        var routeLen = bytes[offset++];
        print("解析route: $routeLen");
        if (routeLen > 0) {
          // copyArray(route, 0, bytes, offset, routeLen);
          route = const Utf8Decoder().convert(
              Uint8List.fromList(List.from(bytes.getRange(offset, routeLen))));
        } else {
          route = '';
        }
        offset += routeLen;
      }
    }
    print("解析了route: $compressRoute   $route  $type");

    // parse body
    var bodyLen = bytesLen - offset;
    var body = Uint8List.fromList(List.from(bytes.getRange(offset, bodyLen)));

    return {
      'id': id,
      'type': type,
      'compressRoute': compressRoute,
      'route': route,
      'body': const Utf8Decoder().convert(body)
    };
  }

  static _msgHasId(type) {
    return type == typeRequest || type == typeResponse;
  }

  static _msgHasRoute(type) {
    return type == typeRequest || type == typeNotify || type == typePush;
  }

  static _caculateMsgIdBytes(id) {
    var len = 0;
    do {
      len += 1;
      id >>= 7;
    } while (id > 0);
    return len;
  }

  ///encode flag
  static _encodeMsgFlag(int type, compressRoute, buffer, offset) {
    if (type != typeRequest &&
        type != typeNotify &&
        type != typeResponse &&
        type != typePush) {
      throw 'unkonw message type: $type';
    }

    buffer[offset] = (type << 1) | (compressRoute ? 1 : 0);
    return offset + msgFlagBytes;
  }

  ///加密msg id
  static _encodeMsgId(int id, Uint8List buffer, int offset) {
    do {
      var tmp = id % 128;
      var next = (id / 128).floor();

      if (next != 0) {
        tmp = tmp + 128;
      }
      buffer[offset++] = tmp;

      id = next;
    } while (id != 0);
    return offset;
  }

  static _encodeMsgRoute(
      compressRoute, dynamic route, Uint8List buffer, int offset) {
    if (compressRoute) {
      int routeInt = route;
      if (routeInt > msgRouteCodeMax) {
        throw 'route number is overflow';
      }
      buffer[offset++] = (routeInt >> 8) & 0xff;
      buffer[offset++] = routeInt & 0xff;
    } else {
      Uint8List routeBytes = route;
      if (routeBytes.isNotEmpty) {
        buffer[offset++] = routeBytes.length & 0xff;
        for (var byte in routeBytes) {
          buffer[offset++] = byte;
        }
        // offset += routeBytes.length;
      } else {
        buffer[offset++] = 0;
      }
    }
    return offset;
  }

  ///加密消息
  static _encodeMsgBody(String msg, Uint8List buffer, int offset) {
    const Utf8Encoder().convert(msg).forEach((byte) {
      buffer[offset++] = byte;
    });
    return buffer.length;
  }
}
