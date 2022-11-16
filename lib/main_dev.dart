import 'package:tfc/app_runner.dart';
import 'package:tfc/config/app_config.dart';
import 'package:tfc/config/env/env.dart';

void main() async {
  AppConfig(env: Env.dev());
  await AppRunner.instance.runApplication();
}
