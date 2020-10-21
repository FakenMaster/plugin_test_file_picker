# Flutter编写跨平台库
生成一个Federated Plugin插件的过程，以前老版开发跨平台插件使用MethodChannel，新版开发方式进行了改进，成为Federated Plugin.

> 相关文章和库:
> * [How To Write a Flutter Web Plugin: Part 2](https://medium.com/flutter/how-to-write-a-flutter-web-plugin-part-2-afdddb69ece6)
> * [plugin_platform_interface库](https://pub.dev/packages/plugin_platform_interface)
> * [Flutter 官方插件列表，跨Desktop和Web的插件都用本文方式实现](https://github.com/flutter/plugins)
> * [本项目地址](https://github.com/FakenMaster/plugin_test_file_picker)

## 步骤1. 创建file_picker_platform_interface (package)

- **`生成package命令：`**
```s
flutter create --template=package file_picker_platform_interface
```

- [**`file_picker_platform_interface.dart`**](https://github.com/FakenMaster/plugin_test_file_picker/blob/main/file_picker_platform_interface/lib/file_picker_platform_interface.dart)
``` dart
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
```

- [**`method_channel_file_picker.dart`**](https://github.com/FakenMaster/plugin_test_file_picker/blob/main/file_picker_platform_interface/lib/method_channel_file_picker.dart)
``` dart
const MethodChannel _channel = MethodChannel('plugins.faken.io/file_picker');

/// 使用MethodChannel实现默认的PlatformInterface
class MethodChannelFilePicker extends FilePickerPlatform {
  @override
  Future<String> chooseDirectory() {
    return _channel.invokeMethod('chooseDirectory');
  }
}
```

## 步骤2. 创建file_picker_web (package)
- **`生成package命令：`**
``` s
flutter create --template=package file_picker_web
```

- [**`file_picker_web/pubspec.yaml`**](https://github.com/FakenMaster/plugin_test_file_picker/blob/main/file_picker_web/pubspec.yaml)
```yaml
/// 添加file_picker_platform_interface以及必要的flutter_web_plugins
dependency:
    file_picker_platform_interface:
        path: ../file_picker_platform_interface
    flutter_web_plugins:
        sdk: flutter

/// 将本包注册成为web插件，这样使用了该库的项目就会自动生成必要的类来为web项目使用该插件
flutter:
  plugin:
    platforms:
      web:
        pluginClass: FilePickerPlugin
        fileName: file_picker_web
```

- [**`file_picker_web.dart`**](https://github.com/FakenMaster/plugin_test_file_picker/blob/main/file_picker_web/lib/file_picker_web.dart)
```dart
import 'package:file_picker_platform_interface/file_picker_platform_interface.dart';

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
```

## 步骤3. 创建file_picker (plugin)
- **`生成plugin命令：`**
``` s
flutter create --template=plugin --platforms=android,ios file_picker
```

- [**`file_picker/pubspec.yaml`**](https://github.com/FakenMaster/plugin_test_file_picker/blob/main/file_picker/pubspec.yaml)
```yaml
/// 声明使用的库,这样使用了该库的项目就会根据配置生成对应平台的插件实现了

dependency:
  file_picker_web:
    path: ../file_picker_web

flutter:
  plugin:
    platforms:
      android:
        package: com.example.file_picker
        pluginClass: FilePickerPlugin
      ios:
        pluginClass: FilePickerPlugin
      web:
        default_plugin: file_picker_web
```

- [**`file_picker.dart`**](https://github.com/FakenMaster/plugin_test_file_picker/blob/main/file_picker/lib/file_picker.dart)
```dart
import 'dart:async';

import 'package:file_picker_platform_interface/file_picker_platform_interface.dart';

/// 调用file_picker_platform_interface注册的库，并向外界暴露具体的使用方法
class FilePicker {
  static Future<String> chooseDirectory() async {
    return FilePickerPlatform.instance.chooseDirectory();
  }
}
```