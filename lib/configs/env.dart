import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Future<void> load() async {
     const env = String.fromEnvironment('FLAVOR',defaultValue: 'root');
      String envFile;
      switch (env) {
        case 'root':
        envFile = 'env/.env.root';
        break;
        case 'dongnguyen':
        envFile = 'env/.env.dongnguyen';
        break;
        default:
        envFile = 'env/.env.root';
        break;
      }
      return await dotenv.load(fileName: envFile);
  }
}