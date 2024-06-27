import 'package:flutter/material.dart';
import 'package:se346_project/src/data/global_data.dart' as globals;

List<String> pageTitles = [
  'History of Design Patterns',
  'Why should I learn Design Patterns?',
  'Criticism of patterns',
  'Classification of patterns',
];

class DesignPatternDetailsPage extends StatefulWidget {
  final int pageIndex;
  final String pageTitle;
  const DesignPatternDetailsPage(
      {super.key, required this.pageIndex, required this.pageTitle});

  @override
  State<DesignPatternDetailsPage> createState() =>
      _DesignPatternDetailsPageState();
}

class _DesignPatternDetailsPageState extends State<DesignPatternDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              ...globals.designPatternsContents[widget.pageTitle] ??
                  [const Text('No content')],
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Divider(
                  thickness: 2,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: NavigateButton(
                        isForward: false,
                        pageIndex: widget.pageIndex,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: NavigateButton(
                        isForward: true,
                        pageIndex: widget.pageIndex,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigateButton extends StatefulWidget {
  final bool isForward;
  final int pageIndex;
  const NavigateButton(
      {super.key, required this.isForward, required this.pageIndex});

  @override
  State<NavigateButton> createState() => _NavigateButtonState();
}

class _NavigateButtonState extends State<NavigateButton> {
  double _padding = 6;

  bool enableButton() {
    if (widget.isForward) {
      return widget.pageIndex != 3;
    } else {
      return widget.pageIndex != 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = enableButton()
        ? Color.fromARGB(255, 40, 187, 255)
        : Colors.grey.shade600;
    final secondaryColor =
        enableButton() ? Color.fromARGB(255, 110, 209, 255) : Colors.grey;

    return GestureDetector(
      onTap: () {
        if (!enableButton()) return;
        // redirect to the next page
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DesignPatternDetailsPage(
            pageIndex:
                widget.isForward ? widget.pageIndex + 1 : widget.pageIndex - 1,
            pageTitle: pageTitles[
                widget.isForward ? widget.pageIndex + 1 : widget.pageIndex - 1],
          ),
        ));
      },
      onTapDown: (_) {
        setState(() {
          _padding = 0;
        });
      },
      onTapCancel: () {
        setState(() {
          _padding = 6;
        });
      },
      onTapUp: (_) {
        setState(() {
          _padding = 6;
        });
      },
      child: AnimatedContainer(
        padding: EdgeInsets.only(bottom: _padding),
        margin: EdgeInsets.only(top: -(_padding - 6)),
        decoration: BoxDecoration(
          // color: Theme.of(context).primaryColor,
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(milliseconds: 50),
        child: Container(
          // width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: secondaryColor,
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (!widget.isForward)
                  const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFFFFFFF),
                  ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.isForward ? "Read next" : "Read last",
                    style: const TextStyle(
                      letterSpacing: 2,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                if (widget.isForward)
                  const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFFFFFFFF),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
