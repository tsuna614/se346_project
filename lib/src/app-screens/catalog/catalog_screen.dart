import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<String> creationalPatterns = [
  'Factory Method',
  'Abstract Factory',
  'Builder',
  'Prototype',
  'Singleton',
];

List<String> structuralPatterns = [
  'Adapter',
  'Bridge',
  'Composite',
  'Decorator',
  'Facade',
  'Flyweight',
  'Proxy',
];

List<String> behavioralPatterns = [
  'Chain of Responsibility',
  'Command',
  'Iterator',
  'Mediator',
  'Memento',
  'Observer',
  'State',
  'Strategy',
  'Template Method',
  'Visitor',
];

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  bool isSearchBarExtended = false;
  bool hideCatalogCard = false;
  final _searchBarController = TextEditingController();
  final _notifier = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.blue.shade900,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCatalogCard(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: _buildSearchBar(context),
              ),
            ],
          ),
        ),
        Expanded(child: _buildCatalogListView()),
      ],
    );
  }

  Widget _buildCatalogCard() {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "The Catalog of Design Patterns",
                    style: TextStyle(
                      fontSize: 36,
                      // fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.lobsterTwo().fontFamily,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/categoryhand.png',
                  // fit: BoxFit.cover,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 20, right: 40),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 40,
            width: isSearchBarExtended
                ? MediaQuery.of(context).size.width * 1
                : 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearchBarExtended = !isSearchBarExtended;
                });
              },
            ),
          ),
          Positioned(
            top: 5,
            left: 50,
            right: 20,
            child: SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: _searchBarController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Search for a design pattern...',
                ),
                onChanged: (value) {
                  _notifier.value = value;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogListView() {
    return ListView(
      padding: const EdgeInsets.all(8),
      // shrinkWrap: true,
      children: <Widget>[
        Center(
          child: Text(
            "Creational patterns",
            style: TextStyle(
              fontSize: 40,
              // fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.lobsterTwo().fontFamily,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        _buildCatalogGridView(patterns: creationalPatterns),
        Center(
          child: Text(
            "Structural patterns",
            style: TextStyle(
              fontSize: 40,
              // fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.lobsterTwo().fontFamily,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        _buildCatalogGridView(patterns: structuralPatterns),
        Center(
          child: Text(
            "Behavioral patterns",
            style: TextStyle(
              fontSize: 40,
              // fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.lobsterTwo().fontFamily,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        _buildCatalogGridView(patterns: behavioralPatterns),
      ],
    );
  }

  Widget _buildCatalogTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          children: [
            Text(
              'Creational Patterns',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogGridView({required List<String> patterns}) {
    return ValueListenableBuilder(
      valueListenable: _notifier,
      builder: (context, value, child) {
        return GridView.count(
          // primary: false,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            ...patterns
                .where((pattern) => pattern
                    .toLowerCase()
                    .contains(_notifier.value.toLowerCase()))
                .map(
                  (pattern) => _buildCatalogGridViewTile(
                    pattern,
                    pattern.toLowerCase(),
                  ),
                ),
          ],
        );
      },
    );
  }

  Widget _buildCatalogGridViewTile(String title, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.blue.shade100,
        border: Border.all(
          color: Colors.grey.withOpacity(0.4),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/design pattern/$imageUrl.png',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
