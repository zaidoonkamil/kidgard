import 'package:flutter/material.dart';

class ArrowBack extends StatelessWidget {
  const ArrowBack({super.key,required this.onTap,required this.icon, this.padding});

  final void Function() onTap;
  final Widget icon;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ,
      child: Container(
        padding: EdgeInsets.all(padding??8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: icon,
      ),
    );
  }
}
