import 'dart:convert';

import 'package:contacts_plus_plus/clients/api_client.dart';
import 'package:contacts_plus_plus/models/users/friend.dart';
import 'package:contacts_plus_plus/models/personal_profile.dart';
import 'package:contacts_plus_plus/models/users/user.dart';
import 'package:contacts_plus_plus/models/users/user_profile.dart';
import 'package:contacts_plus_plus/models/users/friend_status.dart';
import 'package:contacts_plus_plus/models/users/user_status.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UserApi {
  static Future<Iterable<User>> searchUsers(ApiClient client, {required String needle}) async {
    final response = await client.get("/users?name=$needle");
    client.checkResponse(response);
    final data = jsonDecode(response.body) as List;
    return data.map((e) => User.fromMap(e));
  }
  
  static Future<User> getUser(ApiClient client, {required String userId}) async {
    final response = await client.get("/users/$userId/");
    client.checkResponse(response);
    final data = jsonDecode(response.body);
    return User.fromMap(data);
  }

  static Future<UserStatus> getUserStatus(ApiClient client, {required String userId}) async {
    return UserStatus.empty();
    final response = await client.get("/users/$userId/status");
    client.checkResponse(response);
    final data = jsonDecode(response.body);
    return UserStatus.fromMap(data);
  }
  
  static Future<void> notifyOnlineInstance(ApiClient client) async {
    final response = await client.post("/stats/instanceOnline/${client.authenticationData.secretMachineIdHash}");
    client.checkResponse(response);
  }

  static Future<void> setStatus(ApiClient client, {required UserStatus status}) async {
    return;
    final pkginfo = await PackageInfo.fromPlatform();
    status = status.copyWith(
      neosVersion: "${pkginfo.version} of ${pkginfo.appName}",
      isMobile: true,
    );
    final body = jsonEncode(status.toMap(shallow: true));
    final response = await client.put("/users/${client.userId}/status", body: body);
    client.checkResponse(response);
  }

  static Future<PersonalProfile> getPersonalProfile(ApiClient client) async {
    final response = await client.get("/users/${client.userId}");
    client.checkResponse(response);
    final data = jsonDecode(response.body);
    return PersonalProfile.fromMap(data);
  }
}