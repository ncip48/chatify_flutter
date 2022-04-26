// ignore_for_file: unnecessary_this, prefer_collection_literals, unnecessary_new, file_names

class Message {
  int? id;
  int? userId;
  int? targetId;
  int? targetUserId;
  String? message;
  String? attachment;
  int? isRead;
  int? isRetracted;
  String? createdAt;
  String? timeParse;
  String? updatedAt;
  String? status;
  bool? recentChatMe;
  bool? isPending;

  Message(
      {this.id,
      this.userId,
      this.targetId,
      this.targetUserId,
      this.message,
      this.attachment,
      this.isRead,
      this.isRetracted,
      this.createdAt,
      this.timeParse,
      this.updatedAt,
      this.status,
      this.recentChatMe,
      this.isPending});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    targetId = json['target_id'];
    targetUserId = json['target_user_id'];
    message = json['message'];
    attachment = json['attachment'];
    isRead = json['is_read'];
    isRetracted = json['is_retracted'];
    createdAt = json['created_at'];
    timeParse = json['time_parse'];
    updatedAt = json['updated_at'];
    status = json['status'];
    recentChatMe = json['recent_chat_me'];
    isPending = json['is_pending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['target_id'] = this.targetId;
    data['target_user_id'] = this.targetUserId;
    data['message'] = this.message;
    data['attachment'] = this.attachment;
    data['is_read'] = this.isRead;
    data['is_retracted'] = this.isRetracted;
    data['created_at'] = this.createdAt;
    data['time_parse'] = this.timeParse;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['recent_chat_me'] = this.recentChatMe;
    data['is_pending'] = this.isPending;
    return data;
  }
}
