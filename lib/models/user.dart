class User {
  final String id;
  final String name;
  final User? leader;
  final String password;
  final String username;

  final List authorities;
  final bool accountNonExpired = true;
  final bool accountNonLocked = true;
  final bool credentialsNonExpired = true;
  final bool enabled = true;
  final bool activated;

  User(this.id, this.name, this.leader, this.password, this.username,
      this.authorities, this.activated);

  factory User.fromJson(Map<String, dynamic> json) {
    User? leader;
    if ((json[leader]) != null) {
      leader = User.fromJson(json['leader']);
    }

    return User(json['id'], json['name'], leader, json['password'],
        json['username'], json['authorities'], json['activated']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'leader': leader,
        'password': password,
        'username': username,
        'authorities': authorities,
        'activated': activated
      };
}

/*
class Authorities {
  List authorities;

  Authorities(this.authorities);

  factory Authorities.fromJson(Map<String, dynamic> json) {
    List authorities = json as List;
    return Authorities(
        authorities.map((authority) => authority['authority']).toList());
  }

  Map<String, dynamic> toJson() => {'authorities': authorities};
}
*/
