library file_picker_platform_interface;

import 'package:file_picker_platform_interface/method_channel_file_picker.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FilePickerPlatform extends PlatformInterface {

  /// 参照PlatformInterface 20-36行的提示，生成如下的代码
  /// MethodChannelFilePicker 是将旧版的插件库的MethodChannel代码移到此处，作为默认的实现。
  /// 这样就能实现Android，iOS依旧使用MethodChannel了。
  FilePickerPlatform() : super(token: _token);

  static const Object _token = Object();
  
  static FilePickerPlatform _instance = MethodChannelFilePicker();

  static FilePickerPlatform get instance => _instance;

  static set instance(FilePickerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 具体需要实现的功能
  Future<String> chooseDirectory() {
    throw UnimplementedError('chooseDirectory() is not implemented.');
  }
}
