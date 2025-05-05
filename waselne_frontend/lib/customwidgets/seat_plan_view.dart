import 'package:waselne_frontend/utils/colors.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class SeatPlanView extends StatelessWidget {
  final int totalSeat;
  final String bookedSeatNumbers;
  final int totalSeatBooked;
  final bool isBusinessClass;
  final Function(bool, String) onSeatSelected;

  const SeatPlanView({
    Key? key,
    required this.totalSeat,
    required this.bookedSeatNumbers,
    required this.totalSeatBooked,
    required this.isBusinessClass,
    required this.onSeatSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noOfRows = (isBusinessClass ? totalSeat / 3 : totalSeat / 4).toInt();
    final noOfColumns = isBusinessClass ? 3 : 4;
    List<List<String>> seatArrangement = [];

    for (int i = 0; i < noOfRows; i++) {
      List<String> columns = [];
      for (int j = 0; j < noOfColumns; j++) {
        columns.add('${seatLabelList[i]}${j + 1}');
      }
      seatArrangement.add(columns);
    }

    final List<String> bookedSeatList =
    bookedSeatNumbers.isEmpty ? [] : bookedSeatNumbers.split(',');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'FRONT',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const Divider(height: 24, thickness: 1.2),
          Column(
            children: seatArrangement.map((row) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: row.map((seat) {
                  final isBooked = bookedSeatList.contains(seat);
                  final isRightGap = (!isBusinessClass && seat.endsWith('2')) ||
                      (isBusinessClass && seat.endsWith('1'));
                  return Row(
                    children: [
                      Seat(
                        isBooked: isBooked,
                        label: seat,
                        onSelect: (value) => onSeatSelected(value, seat),
                      ),
                      if (isRightGap) const SizedBox(width: 24),
                    ],
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class Seat extends StatefulWidget {
  final String label;
  final bool isBooked;
  final Function(bool) onSelect;

  const Seat({
    Key? key,
    required this.label,
    required this.isBooked,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<Seat> createState() => _SeatState();
}

class _SeatState extends State<Seat> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isBooked
          ? null
          : () {
        setState(() => selected = !selected);
        widget.onSelect(selected);
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.isBooked
              ? seatBookedColor
              : selected
              ? seatSelectedColor
              : seatAvailableColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: widget.isBooked
              ? null
              : [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: widget.isBooked ? Colors.white70 : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
