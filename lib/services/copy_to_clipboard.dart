import 'package:flutter/services.dart';

copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}