import 'package:flutter/material.dart';
import 'package:se346_project/src/app-screens/design-patterns/design_pattern_details_screen.dart';

TextSpan first = const TextSpan(
  children: [
    TextSpan(
      text: "Design patterns",
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    TextSpan(
      text:
          ' are typical solutions to commonly occurring problems in software design. They are like pre-made blueprints that you can customize to solve a recurring design problem in your code.',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
  ],
);

TextSpan second = const TextSpan(
  children: [
    TextSpan(
      text:
          'You can’t just find a pattern and copy it into your program, the way you can with off-the-shelf functions or libraries. The pattern is not a specific piece of code, but a general concept for solving a particular problem. You can follow the pattern details and implement a solution that suits the realities of your own program.',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
  ],
);

TextSpan third = const TextSpan(
  children: [
    TextSpan(
      text:
          'Patterns are often confused with algorithms, because both concepts describe typical solutions to some known problems. While an algorithm always defines a clear set of actions that can achieve some goal, a pattern is a more high-level description of a solution. The code of the same pattern applied to two different programs may be different.',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
  ],
);

class DesginPatternPage extends StatefulWidget {
  const DesginPatternPage({super.key});

  @override
  State<DesginPatternPage> createState() => _DesginPatternPageState();
}

class _DesginPatternPageState extends State<DesginPatternPage> {
  late double xOffset;
  int currentDesignPatternBlockIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    xOffset = -width;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Design Patterns',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildDPStack(),
              const SizedBox(height: 20),
              _buildNavigatingButtons(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 64.0),
                child: Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
              ),
              const SizedBox(height: 20),
              _buildCategoriesList(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDPStack() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          _buildDPBox(
            index: 2,
            transform: Matrix4.translationValues(
              [0, 1, 2].contains(currentDesignPatternBlockIndex) ? 0 : xOffset,
              0,
              0,
            ),
          ),
          _buildDPBox(
            index: 1,
            transform: Matrix4.translationValues(
              [0, 1].contains(currentDesignPatternBlockIndex) ? 0 : xOffset,
              0,
              0,
            ),
          ),
          _buildDPBox(
            index: 0,
            transform: Matrix4.translationValues(
              currentDesignPatternBlockIndex == 0 ? 0 : xOffset,
              0,
              0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDPBox({required int index, required Matrix4 transform}) {
    EdgeInsets padding = index == 0
        ? const EdgeInsets.only(
            top: 40,
            right: 20,
            left: 20,
          )
        : index == 1
            ? const EdgeInsets.only(
                top: 30,
                right: 10,
                left: 30,
              )
            : const EdgeInsets.only(
                top: 20,
                left: 40,
              );

    Color color = index == 0
        ? const Color(0xFFD69FFF)
        : index == 1
            ? const Color(0xFF80C9FE)
            : const Color(0xFF02131D);

    return Padding(
      padding: padding,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: transform,
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
          child: _buildDefinitionText(index: index, isTransparent: false),
        ),
      ),
    );
  }

  Widget _buildDefinitionText(
      {required int index, required bool isTransparent}) {
    final scrollController = ScrollController();
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Text.rich(
          index == 0
              ? first
              : index == 1
                  ? second
                  : third,
        ),
      ),
    );
  }

  Widget _buildNavigatingButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentDesignPatternBlockIndex == 0
              ? null
              : () {
                  setState(() {
                    currentDesignPatternBlockIndex--;
                  });
                },
          icon: Icon(Icons.arrow_back_ios),
        ),
        IconButton(
          onPressed: currentDesignPatternBlockIndex == 2
              ? null
              : () {
                  setState(() {
                    currentDesignPatternBlockIndex++;
                  });
                },
          icon: Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }

  Widget _buildCategoriesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text(
            'Tell me more about',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                _buildCategoryTile(index: 0),
                _buildCategoryTile(index: 1),
                _buildCategoryTile(index: 2),
                _buildCategoryTile(index: 3),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryTile({required int index}) {
    late String categoryTitle;

    switch (index) {
      case 0:
        categoryTitle = "History of Design Patterns";
        break;
      case 1:
        categoryTitle = "Why should I learn Design Patterns?";
        break;
      case 2:
        categoryTitle = "Criticism of patterns";
        break;
      case 3:
        categoryTitle = "Classification of patterns";
        break;
      default:
        categoryTitle = "";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DesignPatternDetailsPage(
                    pageIndex: index,
                    pageTitle: categoryTitle,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.arrow_forward_ios),
                  // const Spacer(),
                  SizedBox(
                    width: 40,
                  ),
                  Flexible(
                    // fit: BoxFit.scaleDown,
                    child: Text(
                      categoryTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
