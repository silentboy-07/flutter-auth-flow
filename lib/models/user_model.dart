class UserModel {
  final String fullName;
  final String email;
  final String? username;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? instagramUsername;
  final String? youtubeChannelUsername;
  final String signupType; 
  final String? profilePhotoUrl;

  UserModel({
    required this.fullName,
    required this.email,
    this.username,
    this.dateOfBirth,
    this.gender,
    this.instagramUsername,
    this.youtubeChannelUsername,
    required this.signupType,
    this.profilePhotoUrl,
  });
}
