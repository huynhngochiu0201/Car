import '../utils/util.dart';

class AddressMapModel {
  String? id;
  String? name;
  String? address;
  double? latitude;
  double? longitude;
}

List<AddressMapModel> coffeeShops = [
  AddressMapModel()
    ..id = Util.getID()
    ..name = 'Thanh Bình Coffee'
    ..address = '233 Nguyễn Tất Thành, Thanh Bình, Hải Châu, Đà Nẵng'
    ..latitude = 16.07992
    ..longitude = 108.21099,
  AddressMapModel()
    ..id = Util.getID()
    ..name = 'M Cafe'
    ..address = '306 Đống Đa, Thanh Bình, Hải Châu, Đà Nẵng'
    ..latitude = 16.07558
    ..longitude = 108.21509,
  AddressMapModel()
    ..id = Util.getID()
    ..name = 'Tiệm Cà Phê Yên'
    ..address = '134/6 Quang Trung, Thạch Thang, Hải Châu, Đà Nẵng'
    ..latitude = 16.07454
    ..longitude = 108.21652,
  AddressMapModel()
    ..id = Util.getID()
    ..name = 'Long Car'
    ..address = '79 Hải Phòng, Thạch Thang, Hải Châu, Đà Nẵng'
    ..latitude = 16.07245
    ..longitude = 108.21850,
  AddressMapModel()
    ..id = Util.getID()
    ..name = 'Highlands Coffee'
    ..address = '145 Quang Trung, Thạch Thang, Hải Châu, Đà Nẵng'
    ..latitude = 16.07349
    ..longitude = 108.21398,
  AddressMapModel()
    ..id = Util.getID()
    ..name = 'One Coffee'
    ..address = '338 Trần Cao Vân, Xuân Hà, Thanh Khê, Đà Nẵng'
    ..latitude = 16.07118
    ..longitude = 108.20156,
  AddressMapModel()
    ..id = Util.getID()
    ..name = 'Kem Cà Phê'
    ..address = '50 Bế Văn Đàn, Chính Gián, Thanh Khê, Đà Nẵng'
    ..latitude = 16.06516
    ..longitude = 108.20018,
  AddressMapModel()
    ..id = Util.getID()
    ..name = 'Cafe Ghita'
    ..address = '96 Thi Sách, Hòa Thuận Nam, Hải Châu, Đà Nẵng'
    ..latitude = 16.05244
    ..longitude = 108.20493,
  AddressMapModel()
    ..id = Util.getID()
    ..name = 'Hương Lan Coffee'
    ..address = '1 Đặng Thùy Trâm, Hải Châu, Đà Nẵng'
    ..latitude = 16.05257
    ..longitude = 108.20945,
  AddressMapModel()
    ..id = Util.getID()
    ..name = 'Az Coffee'
    ..address = '149 Lê Đình Lý, Bình Thuận, Hải Châu, Đà Nẵng'
    ..latitude = 16.05434
    ..longitude = 108.21214,
];
