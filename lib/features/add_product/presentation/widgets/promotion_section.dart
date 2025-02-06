import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PromotionSection extends StatefulWidget {
  final bool isPromoted;
  final ValueChanged<bool> onPromotionChanged;

  const PromotionSection({
    Key? key,
    required this.isPromoted,
    required this.onPromotionChanged,
  }) : super(key: key);

  @override
  State<PromotionSection> createState() => _PromotionSectionState();
}

class _PromotionSectionState extends State<PromotionSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:30, right:18, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Promocionar prenda (1€)',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'UrbaneMedium',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Destaca tu prenda en búsquedas y secciones principales para aumentar su visibilidad y llegar a más usuarios.',
                  style: TextStyle(
                    color: Color(0x80000000),
                    fontFamily: 'OpenSans',
                    fontSize: 11,
                  ),
                ),
              ),
              CupertinoSwitch(
                value: widget.isPromoted,
                onChanged: (value) {
                  setState(() => widget.onPromotionChanged(value));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}