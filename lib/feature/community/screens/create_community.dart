import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/Loader.dart';
import 'package:reddit/feature/community/controller/community_controller.dart';

class CreateCommunity extends ConsumerStatefulWidget {
  const CreateCommunity({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateCommunityState();
}

class _CreateCommunityState extends ConsumerState<CreateCommunity> {
  final communityNamecontrolller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    communityNamecontrolller.dispose();
  }
  void createCommunity() {
    ref.read(communityControllerProvider.notifier).CreateCommunity(communityNamecontrolller.text.trim(),
        context);
  }
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Community'),
      ),
      body: isLoading ? const Loader() : Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Align(alignment: Alignment.topLeft,
                child: Text('Community Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: communityNamecontrolller,
              decoration: const InputDecoration(
                hintText: 'r/Community_name',
                filled: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18),
              ),
              maxLength: 21,
            ),
            const SizedBox(height: 30,),
            ElevatedButton(onPressed: createCommunity,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity,50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )
              ),
                child: const Text('Create community',
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),
            )
          ],
        ),
      ),
    );
  }
}