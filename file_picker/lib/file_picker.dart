import 'dart:async';

import 'package:file_picker_platform_interface/file_picker_platform_interface.dart';

/// 调用file_picker_platform_interface注册的库，并向外界暴露具体的使用方法
class FilePicker {
  static Future<String> chooseDirectory() async {
    return FilePickerPlatform.instance.chooseDirectory();
  }
}
