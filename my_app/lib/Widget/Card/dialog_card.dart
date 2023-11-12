import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Theme/theme.dart';

class DialogCard extends StatefulWidget {
  final String dialogTitle;
  final String message;
  final Icon dialogIcon;
  final VoidCallback OnOKAction;
  final VoidCallback OnCancelAction;
  final String OnOKActionName;

  final String onCancelActionName;
  const DialogCard(
      {Key? key,
      required this.dialogTitle,
      required this.message,
      required this.dialogIcon,
      required this.OnOKAction,
      required this.OnCancelAction,
      required this.OnOKActionName,
      required this.onCancelActionName})
      : super(key: key);

  @override
  State<DialogCard> createState() => _DialogCardState();
}

class _DialogCardState extends State<DialogCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.dialogIcon,
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white30),
              child: Card(
                elevation: 10,
                color: Colors.white70,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.dialogTitle,
                        style: tpharagraph.copyWith(fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AutoSizeText(
                        widget.message,
                        style: tpharagraph3,
                        minFontSize: 12,
                        maxLines: 10,
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        TextButton(
                          onPressed: widget.OnOKAction,
                          child: Text(
                            widget.OnOKActionName,
                            style: tpharagraph2,
                          ),
                        ),
                        TextButton(
                          onPressed: widget.OnCancelAction,
                          child: Text(
                            widget.onCancelActionName,
                            style: tpharagraph2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
