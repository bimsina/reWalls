library bottom_navy_bar;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomNavyBar extends StatelessWidget {
  final int selectedIndex;
  final double iconSize;
  final Color backgroundColor, selectedColor, unselectedColor;
  final bool showElevation;
  final Duration animationDuration;
  final List<BottomNavyBarItem> items;
  final ValueChanged<int> onItemSelected;

  BottomNavyBar(
      {Key key,
      this.selectedIndex = 0,
      this.showElevation = true,
      this.iconSize = 20,
      this.backgroundColor,
      this.selectedColor,
      this.unselectedColor,
      this.animationDuration = const Duration(milliseconds: 250),
      @required this.items,
      @required this.onItemSelected}) {
    assert(items != null);
    assert(items.length >= 2 && items.length <= 5);
    assert(onItemSelected != null);
  }

  Widget _buildItem(BottomNavyBarItem item, bool isSelected) {
    return AnimatedContainer(
      width: isSelected ? 120 : 50,
      height: double.maxFinite,
      duration: animationDuration,
      decoration: BoxDecoration(
        color: isSelected ? selectedColor.withOpacity(0.2) : backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(100.0)),
      ),
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconTheme(
                  data: IconThemeData(
                      size: iconSize,
                      color: isSelected ? selectedColor : unselectedColor),
                  child: item.icon,
                ),
              ),
              isSelected
                  ? DefaultTextStyle.merge(
                      style: TextStyle(
                          fontSize: 16,
                          color: selectedColor,
                          fontWeight: FontWeight.bold),
                      child: item.title,
                    )
                  : SizedBox.shrink()
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Container(
        width: double.infinity,
        height: 55,
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.map((item) {
            var index = items.indexOf(item);
            return GestureDetector(
              onTap: () {
                onItemSelected(index);
              },
              child: _buildItem(item, selectedIndex == index),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class BottomNavyBarItem {
  final Icon icon;
  final Text title;

  BottomNavyBarItem({
    @required this.icon,
    @required this.title,
  }) {
    assert(icon != null);
    assert(title != null);
  }
}
