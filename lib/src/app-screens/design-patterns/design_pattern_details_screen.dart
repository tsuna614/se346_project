import 'package:flutter/material.dart';

class DesignPatternDetailsPage extends StatefulWidget {
  final int pageIndex;
  const DesignPatternDetailsPage({super.key, required this.pageIndex});

  @override
  State<DesignPatternDetailsPage> createState() =>
      _DesignPatternDetailsPageState();
}

class _DesignPatternDetailsPageState extends State<DesignPatternDetailsPage> {
  late String title;
  late List<String> paragraphs;

  @override
  void initState() {
    initPage();
    super.initState();
  }

  void initPage() {
    switch (widget.pageIndex) {
      case 0:
        title = "History of Design Patterns";
        paragraphs = [
          "Who invented patterns? That’s a good, but not a very accurate, question. Design patterns aren’t obscure, sophisticated concepts—quite the opposite. Patterns are typical solutions to common problems in object-oriented design. When a solution gets repeated over and over in various projects, someone eventually puts a name to it and describes the solution in detail. That’s basically how a pattern gets discovered.",
          "The concept of patterns was first described by Christopher Alexander in A Pattern Language: Towns, Buildings, Construction. The book describes a “language” for designing the urban environment. The units of this language are patterns. They may describe how high windows should be, how many levels a building should have, how large green areas in a neighborhood are supposed to be, and so on.",
          "The idea was picked up by four authors: Erich Gamma, John Vlissides, Ralph Johnson, and Richard Helm. In 1994, they published Design Patterns: Elements of Reusable Object-Oriented Software, in which they applied the concept of design patterns to programming. The book featured 23 patterns solving various problems of object-oriented design and became a best-seller very quickly. Due to its lengthy name, people started to call it “the book by the gang of four” which was soon shortened to simply “the GoF book”.",
          "Since then, dozens of other object-oriented patterns have been discovered. The “pattern approach” became very popular in other programming fields, so lots of other patterns now exist outside of object-oriented design as well.",
        ];
        break;
      case 1:
        title = "Why should I learn Design Patterns?";
        paragraphs = [
          "The truth is that you might manage to work as a programmer for many years without knowing about a single pattern. A lot of people do just that. Even in that case, though, you might be implementing some patterns without even knowing it. So why would you spend time learning them?",
          "Design patterns are a toolkit of tried and tested solutions to common problems in software design. Even if you never encounter these problems, knowing patterns is still useful because it teaches you how to solve all sorts of problems using principles of object-oriented design.",
          "Design patterns define a common language that you and your teammates can use to communicate more efficiently. You can say, “Oh, just use a Singleton for that,” and everyone will understand the idea behind your suggestion. No need to explain what a singleton is if you know the pattern and its name."
        ];
        break;
      case 2:
        title = "Criticism of patterns";
        paragraphs = [
          "It seems like only lazy people haven’t criticized design patterns yet. Let’s take a look at the most typical arguments against using patterns.",
          "Kludges for a weak programming language",
          "Usually the need for patterns arises when people choose a programming language or a technology that lacks the necessary level of abstraction. In this case, patterns become a kludge that gives the language much-needed super-abilities.",
          "For example, the Strategy pattern can be implemented with a simple anonymous (lambda) function in most modern programming languages.",
          "Inefficient solutions",
          "Patterns try to systematize approaches that are already widely used. This unification is viewed by many as a dogma, and they implement patterns “to the letter”, without adapting them to the context of their project.",
        ];
        break;
      case 3:
        title = "Classification of patterns";
        paragraphs = [
          "Design patterns differ by their complexity, level of detail and scale of applicability to the entire system being designed. I like the analogy to road construction: you can make an intersection safer by either installing some traffic lights or building an entire multi-level interchange with underground passages for pedestrians.",
          "The most basic and low-level patterns are often called idioms. They usually apply only to a single programming language.",
          "The most universal and high-level patterns are architectural patterns. Developers can implement these patterns in virtually any language. Unlike other patterns, they can be used to design the architecture of an entire application.",
          "In addition, all patterns can be categorized by their intent, or purpose. This book covers three main groups of patterns.",
        ];
        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              ...paragraphs.map((paragraph) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    paragraph,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              }).toList(),
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
