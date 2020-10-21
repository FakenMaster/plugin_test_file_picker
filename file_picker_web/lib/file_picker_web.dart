library file_picker_web;

import 'package:file_picker_platform_interface/file_picker_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class FilePickerPlugin extends FilePickerPlatform {
  /// 使用pubspec.yaml中将本库注册成为web插件，之后在使用了该库的项目就会自动生成注册该web插件的类，会使用下面的方法。
  /// 这就是 约定大于配置（convention over configuration).
  static void registerWith(Registrar registrar) {
    FilePickerPlatform.instance = FilePickerPlugin();
  }

  @override
  Future<String> chooseDirectory() {
    return Future.value('Web目录');
  }
}
