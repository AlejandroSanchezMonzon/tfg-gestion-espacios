class Reserva {
  Reserva({
    this.uuid,
    required this.userId,
    required this.spaceId,
    required this.startTime,
    required this.endTime,
    required this.userName,
    required this.spaceName,
    this.phone,
    this.status,
  });

  String? uuid;
  String userId;
  String spaceId;
  String startTime;
  String endTime;
  String userName;
  String spaceName;
  String? phone;
  String? status;
}