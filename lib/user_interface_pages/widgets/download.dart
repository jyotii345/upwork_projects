import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class Download {
  final String apiKey = "L9F6ZJ00CKFJ4Z!";
  Future<String> downloadFile(
      {required String fileURL, required String fileName}) async {
    try {
      Dio dio = Dio();
      var dir = await getApplicationDocumentsDirectory();
      var filePath = '${dir.path}/$fileName.pdf';
      await dio.download(fileURL, filePath,
          options: Options(
            headers: {'apikey': apiKey, 'Content-Type': 'application/json'},
          ));
      return filePath;
    } on DioError catch (e) {
      print(e);
      return "";
    }
  }
}
