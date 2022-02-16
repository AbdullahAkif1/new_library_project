class URL {
  // android emulator
  static const String root = "10.0.2.2:3000";
  // static const String root = "192.168.43.13:3000";

  static requirementsUrl() {
    return Uri.http(root, "/library");
  }

  static requirementsUrlId(int id) {
    return Uri.http(root, "/library", {"id": id.toString()});
  }
}
