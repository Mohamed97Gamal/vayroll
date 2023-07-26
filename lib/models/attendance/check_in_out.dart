import 'package:json_annotation/json_annotation.dart';

part 'check_in_out.g.dart';

@JsonSerializable()
class CheckInOut {
  String? id;
  double? latitude;
  double? longitude;
  DateTime? time;
  bool? isManual;
  double? workingHours;

  CheckInOut({this.id, this.latitude, this.longitude, this.time, this.isManual, this.workingHours});

  factory CheckInOut.fromJson(Map<String, dynamic> json) => _$CheckInOutFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInOutToJson(this);
}
