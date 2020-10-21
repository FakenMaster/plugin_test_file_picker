import 'package:file_picker_platform_interface/file_picker_platform_interface.dart';
import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('plugins.faken.io/file_picker');

/// 使用MethodChannel实现默认的PlatformInterface
class MethodChannelFilePicker extends FilePickerPlatform {
  @override
  Future<String> chooseDirectory() {
    return _channel.invokeMethod('chooseDirectory');
  }
}
