// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:get/get.dart';
import 'package:timelines/timelines.dart';

class ProgressTimeline extends StatelessWidget {
  final double points;
  const ProgressTimeline(this.points, {Key key}) : super(key: key);

  static const _tiers = [25, 100, 200, 300, 400];
  static const double _indicatorSize = 15;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          direction: Axis.horizontal,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.after,
          itemCount: _tiers.length,
          itemExtent: Get.width / 5,
          contentsBuilder: (context, index) => Text(
            _tiers[index].toString(),
            style: rubikMedium.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          indicatorBuilder: (_, index) => points >= _tiers[index]
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  width: _indicatorSize,
                  height: _indicatorSize,
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  width: _indicatorSize,
                  height: _indicatorSize,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    margin: EdgeInsets.all(1),
                  ),
                ),
          firstConnectorBuilder: (context) => MyLPI(
            points: points,
            min: 0,
            max: 25,
          ),
          lastConnectorBuilder: (context) => MyLPI(
            points: points,
            min: 400,
            max: 500,
            // value: points / tiers[index].toDouble(),
          ),
          connectorBuilder: (_, index, type) => type != ConnectorType.start
              ? MyLPI(
                  points: points,
                  min: _tiers[index].toDouble(),
                  max: ((_tiers[index] + _tiers[index + 1]) ~/ 2).toDouble(),
                )
              : MyLPI(
                  points: points,
                  min: ((_tiers[index] + _tiers[index + 1]) ~/ 2).toDouble(),
                  max: _tiers[index + 1].toDouble(),
                ),
        ),
      ),
    );
  }
}

class MyLPI extends StatelessWidget {
  final points;
  final double min;
  final double max;
  const MyLPI({Key key, this.points, this.min, this.max}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.grey.shade300,
      color: Theme.of(context).primaryColor,
      value: points > min ? (points - min) / (max - min) : 0,
    );
  }
}
