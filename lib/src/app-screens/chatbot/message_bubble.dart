import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.isChosenMessage,
    required this.createdTime,
  });

  final String message;
  final bool isCurrentUser;
  final bool isChosenMessage;
  final DateTime createdTime;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  double verticalMargin = 3;

  String formattedTime(int time) {
    if (time < 10) {
      return "0$time";
    } else {
      return time.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentDate =
        "${widget.createdTime.day.toString()}/${widget.createdTime.month.toString()}/${widget.createdTime.year.toString()} AT ${formattedTime(widget.createdTime.hour)}:${formattedTime(widget.createdTime.minute)}";

    return Stack(
      children: [
        Column(
          children: [
            if (widget.isChosenMessage)
              Padding(
                padding: EdgeInsets.only(
                    // left: widget.isCurrentUser ? 0 : 10,
                    // right: widget.isCurrentUser ? 10 : 0,
                    // bottom: 5,
                    ),
                child: Text(
                  currentDate,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            Align(
              alignment: widget.isCurrentUser
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: widget.isCurrentUser ? 100 : 0,
                  right: widget.isCurrentUser ? 0 : 100,
                ),
                // padding: EdgeInsets.all(0),
                child: Container(
                  // duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.only(
                    top: widget.isChosenMessage ? 10 : 3,
                    bottom: widget.isChosenMessage ? 10 : 3,
                  ),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: widget.isCurrentUser
                        ? widget.isChosenMessage
                            ? Colors.blue[700]
                            : Colors.blue
                        : widget.isChosenMessage
                            ? Colors.grey[400]
                            : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: widget.isCurrentUser
                          ? Radius.circular(50)
                          : Radius.zero,
                      topRight: widget.isCurrentUser
                          ? Radius.zero
                          : Radius.circular(50),
                      bottomLeft: widget.isCurrentUser
                          ? Radius.circular(50)
                          : Radius.zero,
                      bottomRight: widget.isCurrentUser
                          ? Radius.zero
                          : Radius.circular(50),
                    ),
                  ),
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: widget.isCurrentUser ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
