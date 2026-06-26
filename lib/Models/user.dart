class UserDetails{
    final String? uid;
    String? firstName;
    String? lastName;
    String? phoneNumber;
    UserDetails({this.uid,this.firstName,this.lastName,this.phoneNumber});

    UserDetails copyWith({
        String? uid,
        String? firstName,
        String? lastName,
        String? phoneNumber,
    }) {
        return UserDetails(
            uid: uid ?? this.uid,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            phoneNumber: phoneNumber ?? this.phoneNumber,
        );
    }

}