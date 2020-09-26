class AccountDTO {
  final int uid;
  final String name, phone, gender, email;
  final DateTime birthdate;
  final double balance;
  final double point;
  // balance. point;
  final bool isFirstLogin;
  AccountDTO({
    this.uid,
    this.name,
    this.phone,
    this.gender,
    this.email,
    this.birthdate,
    this.isFirstLogin = true,
    this.balance,
    this.point,
  });

  factory AccountDTO.fromJson(dynamic json) => AccountDTO(
        uid: json["customer_id"],
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        gender: (json['gender'] as bool) == true ? 'nam' : 'nu',
        balance: json['balance'],
        point: json['point'],
        isFirstLogin: json['is_first_login'] as bool,
        birthdate: json['birthdate'] as String != null
            ? DateTime.parse(json['birthdate'] as String)
            : null,
      );

  Map<String, dynamic> toJson() {
    return {
      "userId": uid.toString(),
      "name": name,
      "email": email,
      "phone": phone,
      "gender": gender == 'nam',
      "birth_day": birthdate.toString(),
      "pic_url": "https://randomuser.me/api/portraits/women/28.jpg",
    };
  }
}
