import 'package:flutter/material.dart';

class UnitTile extends StatefulWidget {
  const UnitTile({
    super.key,
    this.title = const Text(""),
    this.subtitle = const Text(""),
    this.leading = const Text(""),
    this.trailing = const Text(""),
    this.selected = false,
    this.removable = false,
    this.isThreeLine = false,
    this.onTap,
  });

  final Widget title;
  final Widget subtitle;
  final Widget leading;
  final Widget trailing;
  final bool selected;
  final VoidCallback? onTap;
  final bool removable;
  final bool isThreeLine;

  @override
  State<UnitTile> createState() => _UnitTileState();
}

class _UnitTileState extends State<UnitTile> {
  bool _selected = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    Widget result = ListTile(
      contentPadding: const EdgeInsets.all(10),
      titleAlignment: ListTileTitleAlignment.center,
      title: widget.title,
      subtitle: widget.subtitle,
      leading: widget.leading,
      trailing: widget.trailing,
      selected: _selected,
      isThreeLine: widget.isThreeLine,
      selectedColor: Colors.blueAccent,
      onTap: () {
        // _selected = !_selected;
        setState(() {});
        if (widget.onTap != null) {
          widget.onTap!();
          setState(() {});
        }
      },
    );
    if (widget.removable) {
      result = Dismissible(
        key: ValueKey(result),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) async {},
        child: result,
      );
    }
    return result;
  }
}
