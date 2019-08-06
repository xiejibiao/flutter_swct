import 'package:flutter/material.dart';

class PersonAchievementPageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: myAchievements.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  _buildImage(myAchievements[index].month),
                  SizedBox(
                    width: 10.0,
                  ),
                  _buildAchievements(index)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Image _buildImage (int month) {
  return Image.asset(
      'assets/date_icon_image/$month.png',
      width: 32.0,
    );
  }
  Column _buildAchievements (int index) {
    return Column(
      children: <Widget>[
        _buildAchievementsText('总业绩', myAchievements[index].sumAchievement),
        _buildAchievementsText('分享业绩', myAchievements[index].sumAchievement),
        _buildAchievementsText('创业业绩', myAchievements[index].sumAchievement),
      ],
    );
  }

  Row _buildAchievementsText (String title, double money) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: 100,
          child: Text(
            '$title：',
            style: TextStyle(
              fontSize: 16.0
            ),
          ),
        ),
        Text(
          '$money',
          style: TextStyle(
            fontSize: 16.0
          ),
        ),
      ],
    );
  }
}

class MyAchievement {
  MyAchievement({
    this.id,
    this.month,
    this.sumAchievement,
    this.shareAchievement,
    this.pioneerAchievement
  });
  int id, month;
  double sumAchievement, shareAchievement, pioneerAchievement;
}

List<MyAchievement> myAchievements = [
  MyAchievement(
    id: 1,
    month: 1,
    sumAchievement: 10000.0,
    shareAchievement: 100000.0,
    pioneerAchievement: 1000000.0
  ),
  MyAchievement(
    id: 2,
    month: 2,
    sumAchievement: 20000.0,
    shareAchievement: 200000.0,
    pioneerAchievement: 2000000.0
  ),
  MyAchievement(
    id: 3,
    month: 3,
    sumAchievement: 30000.0,
    shareAchievement: 300000.0,
    pioneerAchievement: 3000000.0
  ),
  MyAchievement(
    id: 4,
    month: 4,
    sumAchievement: 40000.0,
    shareAchievement: 400000.0,
    pioneerAchievement: 4000000.0
  ),
  MyAchievement(
    id: 5,
    month: 5,
    sumAchievement: 50000.0,
    shareAchievement: 500000.0,
    pioneerAchievement: 5000000.0
  ),
  MyAchievement(
    id: 5,
    month: 5,
    sumAchievement: 50000.0,
    shareAchievement: 500000.0,
    pioneerAchievement: 5000000.0
  ),
  MyAchievement(
    id: 5,
    month: 5,
    sumAchievement: 50000.0,
    shareAchievement: 500000.0,
    pioneerAchievement: 5000000.0
  ),
  MyAchievement(
    id: 5,
    month: 5,
    sumAchievement: 50000.0,
    shareAchievement: 500000.0,
    pioneerAchievement: 5000000.0
  ),
];