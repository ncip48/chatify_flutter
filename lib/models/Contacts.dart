// ignore_for_file: prefer_void_to_null, file_names, unnecessary_new, unnecessary_this, unnecessary_question_mark, prefer_collection_literals

class Contacts {
  int? id;
  String? name;
  String? email;
  Null? phone;
  String? photo;
  String? status;
  Null? lastActive;
  Null? firebaseToken;
  String? createdAt;
  String? updatedAt;
  String? targetChat;
  bool? recentChatMe;
  RecentChat? recentChat;

  Contacts(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.photo,
      this.status,
      this.lastActive,
      this.firebaseToken,
      this.createdAt,
      this.updatedAt,
      this.targetChat,
      this.recentChatMe,
      this.recentChat});

  Contacts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    photo = json['photo'];
    status = json['status'];
    lastActive = json['last_active'];
    firebaseToken = json['firebase_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    targetChat = json['target_chat'];
    recentChatMe = json['recent_chat_me'];
    recentChat = json['recent_chat'] != null
        ? new RecentChat.fromJson(json['recent_chat'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['photo'] = this.photo;
    data['status'] = this.status;
    data['last_active'] = this.lastActive;
    data['firebase_token'] = this.firebaseToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['target_chat'] = this.targetChat;
    data['recent_chat_me'] = this.recentChatMe;
    if (this.recentChat != null) {
      data['recent_chat'] = this.recentChat!.toJson();
    }
    return data;
  }
}

class RecentChat {
  int? id;
  String? userId;
  int? targetId;
  String? message;
  Null? attachment;
  int? isRead;
  int? isRetracted;
  String? createdAt;
  String? updatedAt;
  String? timeParse;

  RecentChat(
      {this.id,
      this.userId,
      this.targetId,
      this.message,
      this.attachment,
      this.isRead,
      this.isRetracted,
      this.createdAt,
      this.timeParse,
      this.updatedAt});

  RecentChat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    targetId = json['target_id'];
    message = json['message'];
    attachment = json['attachment'];
    isRead = json['is_read'];
    isRetracted = json['is_retracted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    timeParse = json['time_parse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['target_id'] = this.targetId;
    data['message'] = this.message;
    data['attachment'] = this.attachment;
    data['is_read'] = this.isRead;
    data['is_retracted'] = this.isRetracted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['time_parse'] = this.timeParse;
    return data;
  }
}
