const String tableRestaurant = 'restaurant';

class RestaurantFields {
  static final List<String> values = [
    id,
    name,
    address,
    city,
    state,
    pinCode,
    phoneNumber,
    emailAddress,
    gstin,
    fssai,
    password,
    currency,
    logo,
    purchaseCode,
    validFrom,
    validTill
  ];
  static const String id = '_id';
  static const String name = 'name';
  static const String address = 'address';
  static const String city = 'city';
  static const String state = 'state';
  static const String pinCode = 'pinCode';
  static const String phoneNumber = 'phoneNumber';
  static const String emailAddress = 'emailAddress';
  static const String gstin = 'taxNo';
  static const String fssai = 'foodLicenseNo';
  static const String password = 'pin';
  static const String currency = 'currency';
  static const String logo = 'logo';
  static const String purchaseCode = 'purchaseCode';
  static const String validFrom = 'validFrom';
  static const String validTill = 'validTill';
}

class Restaurant {
  final int? id;
  final String name;
  final String? address;
  final String? city;
  final String? state;
  final String? pinCode;
  final String? phoneNumber;
  final String? emailAddress;
  final String? gstin;
  final String? fssai;
  final String password;
  final String currency;
  final String? logo;
  final String? purchaseCode;
  final DateTime? validFrom;
  final DateTime? validTill;

  const Restaurant(
      {this.id,
      required this.name,
      this.address,
      this.city,
      this.state,
      this.pinCode,
      this.phoneNumber,
      this.emailAddress,
      this.gstin,
      this.fssai,
      required this.password,
      required this.currency,
      this.logo,
      this.purchaseCode,
      this.validFrom,
      this.validTill});

  Restaurant copy({
    int? id,
    String? name,
    String? address,
    String? city,
    String? state,
    String? pinCode,
    String? phoneNumber,
    String? emailAddress,
    String? gstin,
    String? fssai,
    String? password,
    String? currency,
    String? logo,
    String? purchaseCode,
    DateTime? validFrom,
    DateTime? validTill,
  }) =>
      Restaurant(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        city: city ?? this.city,
        state: state ?? this.state,
        pinCode: pinCode ?? this.pinCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        emailAddress: emailAddress ?? this.emailAddress,
        gstin: gstin ?? this.gstin,
        fssai: fssai ?? this.fssai,
        currency: currency ?? this.currency,
        logo: logo ?? this.logo,
        password: password ?? this.password,
        purchaseCode: purchaseCode ?? this.purchaseCode,
        validFrom: validFrom ?? this.validFrom,
        validTill: validTill ?? this.validTill,
      );

  static Restaurant fromJson(Map<String, Object?> json) => Restaurant(
        id: json[RestaurantFields.id] as int?,
        name: json[RestaurantFields.name] as String,
        address: json[RestaurantFields.address] as String?,
        city: json[RestaurantFields.city] as String?,
        state: json[RestaurantFields.state] as String?,
        pinCode: json[RestaurantFields.pinCode] as String?,
        phoneNumber: json[RestaurantFields.phoneNumber] as String?,
        emailAddress: json[RestaurantFields.emailAddress] as String?,
        gstin: json[RestaurantFields.gstin] as String?,
        fssai: json[RestaurantFields.fssai] as String?,
        currency: json[RestaurantFields.currency] as String,
        logo: json[RestaurantFields.logo] as String?,
        password: json[RestaurantFields.password] as String,
        purchaseCode: json[RestaurantFields.purchaseCode] as String?,
        validFrom: json[RestaurantFields.validFrom] != null
            ? DateTime.parse(json[RestaurantFields.validFrom] as String)
            : null,
        validTill: json[RestaurantFields.validTill] != null
            ? DateTime.parse(json[RestaurantFields.validTill] as String)
            : null,
      );

  Map<String, Object?> toJson() => {
        RestaurantFields.id: id,
        RestaurantFields.name: name,
        RestaurantFields.address: address,
        RestaurantFields.city: city,
        RestaurantFields.state: state,
        RestaurantFields.pinCode: pinCode,
        RestaurantFields.phoneNumber: phoneNumber,
        RestaurantFields.emailAddress: emailAddress,
        RestaurantFields.gstin: gstin,
        RestaurantFields.fssai: fssai,
        RestaurantFields.currency: currency,
        RestaurantFields.logo: logo,
        RestaurantFields.password: password,
        RestaurantFields.purchaseCode: purchaseCode,
        RestaurantFields.validFrom: validFrom != null ? validFrom!.toIso8601String() : null,
        RestaurantFields.validTill: validTill != null ? validTill!.toIso8601String() : null,
      };
}
