import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final void Function() alternateDrawer;
  const ProfileScreen({super.key, required this.alternateDrawer});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.alternateDrawer,
        ),
      ),
      body: const Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}
