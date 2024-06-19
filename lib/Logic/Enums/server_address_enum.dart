// ignore_for_file: constant_identifier_names

enum ServerAddressEnum {
  LOCAL1,
}

extension AddressExtension on ServerAddressEnum {
  String get ipAddress {
    switch (this) {
      case ServerAddressEnum.LOCAL1:
        return 'http://192.168.255.106/graphql';
      default:
        return '';
    }
  }
}
