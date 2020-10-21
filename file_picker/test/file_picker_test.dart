import 'package:file_picker_platform_interface/file_picker_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FilePickerPlatform.instance = _TestFilePickerPlatform();
  });

  tearDown(() {});

  test('chooseDirectory', () async {
    expect(await FilePicker.chooseDirectory(), 'Test目录');
  });
}

class _TestFilePickerPlatform extends FilePickerPlatform {
  @override
  Future<String> chooseDirectory() {
    return Future.value('Test目录');
  }
}
