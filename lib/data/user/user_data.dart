import 'package:rescape_web/data/user/user_model.dart';
import 'package:rescape_web/logic/cache/prefs.dart';

abstract class UserData {
  static UserModel _instance = UserModel(
    username: Prefs.instance.getString('username'),
    type: Prefs.instance.getString('type'),
    companyId: Prefs.instance.getString('companyId'),
    discount: Prefs.instance.getDouble('discount'),
    locations: <int>[
      if (Prefs.instance.getStringList('locations') != null)
        for (var location in Prefs.instance.getStringList('locations')!)
          int.parse(location),
    ],
  );

  static UserModel get instance => _instance;

  static Future<void> setInstance(
    String? username,
    String? type,
    String? companyId,
    double? discount,
    List<int>? locations,
  ) async {
    _instance = UserModel(
      username: username,
      type: type,
      companyId: companyId,
      discount: discount,
      locations: locations,
    );
    await Prefs.instance.setString('username', username!);
    await Prefs.instance.setString('type', type!);
    if (companyId != null)
      await Prefs.instance.setString('companyId', companyId);
    if (discount != null) await Prefs.instance.setDouble('discount', discount);
    if (locations != null)
      await Prefs.instance.setStringList(
          'locations', [for (var location in locations) location.toString()]);
  }

  static bool get authenticated => _instance.username != null;

  static bool get isAdmin => _instance.type == 'admin';
}
