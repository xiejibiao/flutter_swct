class PersonTeamAchievementVo {
  String code;
  String message;
  PersonTeamAchievementData data;

  PersonTeamAchievementVo({this.code, this.message, this.data});

  PersonTeamAchievementVo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new PersonTeamAchievementData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class PersonTeamAchievementData {
  int teamSum;
  dynamic teamAchievement;

  PersonTeamAchievementData({this.teamSum, this.teamAchievement});

  PersonTeamAchievementData.fromJson(Map<String, dynamic> json) {
    teamSum = json['teamSum'];
    teamAchievement = json['teamAchievement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamSum'] = this.teamSum;
    data['teamAchievement'] = this.teamAchievement;
    return data;
  }
}