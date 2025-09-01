class AadhaarResponse {
  final int code;
  final int timestamp;
  final AadhaarData data;
  final String transactionId;

  AadhaarResponse({
    required this.code,
    required this.timestamp,
    required this.data,
    required this.transactionId,
  });

  factory AadhaarResponse.fromJson(Map<String, dynamic> json) {
    return AadhaarResponse(
      code: json["code"],
      timestamp: json["timestamp"],
      data: AadhaarData.fromJson(json["data"]),
      transactionId: json["transaction_id"],
    );
  }
}

class AadhaarData {
  final String entity;
  final int referenceId;
  final String status;
  final String message;
  final String careOf;
  final String fullAddress;
  final String dateOfBirth;
  final String gender;
  final String name;
  final Address address;
  final int yearOfBirth;
  final String mobileHash;
  final String photo;
  final String shareCode;

  AadhaarData({
    required this.entity,
    required this.referenceId,
    required this.status,
    required this.message,
    required this.careOf,
    required this.fullAddress,
    required this.dateOfBirth,
    required this.gender,
    required this.name,
    required this.address,
    required this.yearOfBirth,
    required this.mobileHash,
    required this.photo,
    required this.shareCode,
  });

  factory AadhaarData.fromJson(Map<String, dynamic> json) {
    return AadhaarData(
      entity: json["@entity"],
      referenceId: json["reference_id"],
      status: json["status"],
      message: json["message"],
      careOf: json["care_of"],
      fullAddress: json["full_address"],
      dateOfBirth: json["date_of_birth"],
      gender: json["gender"],
      name: json["name"],
      address: Address.fromJson(json["address"]),
      yearOfBirth: json["year_of_birth"],
      mobileHash: json["mobile_hash"],
      photo: json["photo"],
      shareCode: json["share_code"],
    );
  }
}

class Address {
  final String country;
  final String district;
  final String house;
  final String landmark;
  final int pincode;
  final String postOffice;
  final String state;
  final String street;
  final String subdistrict;
  final String vtc;

  Address({
    required this.country,
    required this.district,
    required this.house,
    required this.landmark,
    required this.pincode,
    required this.postOffice,
    required this.state,
    required this.street,
    required this.subdistrict,
    required this.vtc,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      country: json["country"],
      district: json["district"],
      house: json["house"],
      landmark: json["landmark"],
      pincode: json["pincode"],
      postOffice: json["post_office"],
      state: json["state"],
      street: json["street"],
      subdistrict: json["subdistrict"],
      vtc: json["vtc"],
    );
  }
}
