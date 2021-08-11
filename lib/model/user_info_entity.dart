import 'package:flutter_framework/generated/json/base/json_convert_content.dart';

class UserInfo with JsonConvert<UserInfo> {
	String? name;
	String? passwd;
	String? token;
}
