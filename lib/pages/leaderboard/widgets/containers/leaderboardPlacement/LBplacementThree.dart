import 'package:auto_size_text/auto_size_text.dart';
import 'package:collect_the_world/pages/leaderboard/widgets/containers/leaderBoardWidget/LBprofilePicture.dart';
import 'package:collect_the_world/pages/leaderboard/widgets/containers/leaderboardPlacement/LBplacementXpWidget.dart';
import 'package:flutter/material.dart';

class LBplacementThree extends StatelessWidget {
  final List userInfo;
  const LBplacementThree({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,

        children: <Widget>[
          
          Container(
            margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 16,0,8),
            decoration: BoxDecoration(
                color: Colors.brown[600],
                borderRadius: BorderRadius.circular(8)),
            child: const PlacementContent(),
          )
        ],
      ),
    );
  }
}

class PlacementContent extends StatelessWidget {
  const PlacementContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const TmpProfile(),
        const SizedBox(
          height: 8,
        ),
        const AutoSizeText(
          overflow: TextOverflow.ellipsis,
          "Tentamens",
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        Text(
          "3",
          style: TextStyle(
            color: Colors.yellow[50],
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 10),
        const LBplacementXpWidget(
          count: 2000,
        )
      ],
    );
  }
}