import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
class ModScreen extends StatelessWidget {
  final String name;
  const ModScreen({Key? key, required this.name}) : super(key: key);

  void navigateToMods(BuildContext context) {
    Routemaster.of(context).push('/edit_community/$name');
  }
  void navigateToAddMods(BuildContext context) {
    Routemaster.of(context).push('/add_mods/$name');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod Tools'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text('Add Moderators'),
            onTap: () => navigateToAddMods(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Community'),
            onTap: () => navigateToMods(context),
          )
        ],
      ),
    );
  }
}
