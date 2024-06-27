import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

final iosOptions =
    IOSOptions(accessibility: KeychainAccessibility.first_unlock);
final storage =
    FlutterSecureStorage(aOptions: _getAndroidOptions(), iOptions: iosOptions);
