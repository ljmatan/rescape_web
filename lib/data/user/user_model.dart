class UserModel {
  final String? username, type, companyId;
  double? discount;
  List<int>? locations;

  UserModel({
    this.username,
    this.type,
    this.companyId,
    this.discount,
    this.locations,
  });
}
