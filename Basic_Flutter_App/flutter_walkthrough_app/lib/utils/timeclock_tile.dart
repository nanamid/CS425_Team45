import 'package:flutter/material.dart';

/// A little tile showing a timestamp pair for the task detail view
/// Intended to be used in a list
class TimeclockTile extends StatelessWidget {
  List<DateTime?> clockPair;
  TimeclockTile({required this.clockPair});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          children: [
            _TimeBlock(
              time: clockPair[0] ?? DateTime(0),
              align: CrossAxisAlignment.center,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                  visible: clockPair[1] != null,
                  child: Icon(Icons.double_arrow)),
            ),
            Spacer(),
            Visibility(
              visible: clockPair[1] != null,
              child: _TimeBlock(
                  time: clockPair[1] ?? DateTime(0),
                  align: CrossAxisAlignment.center),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper widget to help format the DateTime fields
class _TimeBlock extends StatelessWidget {
  DateTime time;
  CrossAxisAlignment align;
  _TimeBlock({required this.time, this.align = CrossAxisAlignment.center});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
            '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}'),
        Text('${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}')
      ],
    );
  }
}
