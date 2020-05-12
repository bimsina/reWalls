import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/theme.dart';

class ResolutionSelector extends StatefulWidget {
  final String deviceResolution;
  final Function(String) onTap;

  ResolutionSelector({Key key, this.onTap, this.deviceResolution})
      : super(key: key);
  @override
  _ResolutionSelectorState createState() => _ResolutionSelectorState();
}

class _ResolutionSelectorState extends State<ResolutionSelector> {
  int selected = 0;
  List<String> list = [];

  @override
  void initState() {
    super.initState();
    list.insertAll(0, phoneResolutions);
    if (phoneResolutions.contains(widget.deviceResolution)) {
      list.removeWhere((item) => item == widget.deviceResolution);
    }
    list.insert(0, widget.deviceResolution);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final stateData = Provider.of<ThemeNotifier>(context);
    final ThemeData themeData = stateData.getTheme();
    return SizedBox(
      height: 45,
      child: list.length == 0
          ? Container()
          : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    if (index != selected) {
                      setState(() {
                        selected = index;
                      });
                      widget.onTap(list[index]);
                    }
                  },
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: index == selected
                                ? themeData.accentColor
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(40.0)),
                      child: Text(
                        list[index],
                        style: themeData.textTheme.bodyText1
                            .copyWith(fontSize: 14),
                      )),
                );
              },
            ),
    );
  }
}
