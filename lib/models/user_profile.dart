class UserProfile {
  String fullName;
  String mobileNumber;
  String email;
  String gender; // Male, Female, Other
  String preferredCoachType; // Sleeper, 3A, 2A, 1A, CC, General
  String preferredBerthType; // LB, MB, UB, SL, SU
  String acPreference; // AC, Non-AC
  String? profileImageUrl;

  UserProfile({
    this.fullName = '',
    this.mobileNumber = '',
    this.email = '',
    this.gender = 'Male',
    this.preferredCoachType = 'Sleeper',
    this.preferredBerthType = 'LB',
    this.acPreference = 'AC',
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'email': email,
      'gender': gender,
      'preferredCoachType': preferredCoachType,
      'preferredBerthType': preferredBerthType,
      'acPreference': acPreference,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullName: json['fullName'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? 'Male',
      preferredCoachType: json['preferredCoachType'] ?? 'Sleeper',
      preferredBerthType: json['preferredBerthType'] ?? 'LB',
      acPreference: json['acPreference'] ?? 'AC',
      profileImageUrl: json['profileImageUrl'],
    );
  }
}
