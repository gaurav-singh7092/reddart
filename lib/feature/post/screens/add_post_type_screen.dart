import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/Loader.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/feature/community/controller/community_controller.dart';
import 'package:reddit/feature/post/controller/post_controller.dart';
import '../../../core/utils.dart';
import '../../../model/community_model.dart';
import '../../../theme/pallete.dart';
class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  List<Community> communtities = [];
  Community? selectedCommunity;
  File? bannerFile;
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }
  void selectedBanner() async{
    final res = await pickImage();
    if(res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }
  void sharePost() {
    if (widget.type == 'image' && bannerFile != null &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).ShareImagePost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communtities[0],
          file: bannerFile);
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).ShareTextPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communtities[0],
          description: descriptionController.text.trim());
    } else if (widget.type == 'link' && linkController.text.isNotEmpty &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).ShareLinkPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communtities[0],
          link: linkController.text.trim());
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }
  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}',style: TextStyle(color: currentTheme.backgroundColor),),
        actions: [
          TextButton(
              onPressed: sharePost,
              child: const Text('Share')),
        ],
      ),
      body: isLoading ? const Loader() : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'An Interesting Title...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18),
              ),
              maxLength: 30 ,
            ),
            const SizedBox(height: 10,),
            if(isTypeImage)
              GestureDetector(
                onTap: selectedBanner,
                child: DottedBorder(
                  borderType: BorderType.RRect ,
                  radius: const Radius.circular(10),
                  dashPattern: const [10,4],
                  strokeCap: StrokeCap.round,
                  color: currentTheme .textTheme.bodyText2!.color!,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:  bannerFile!=null ? Image.file(bannerFile!) :
                    const Center(
                      child: Icon(Icons.camera_alt_outlined, size: 40,),
                    )
                  ),
                ),
              ),
            if(isTypeText)
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter Description here',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
                maxLines: 5,
              ),
            if(isTypeLink)
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter Link here',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
              ),
            const SizedBox(height: 25,),
            const Align(
              alignment: Alignment.topLeft,
              child: Text('Select Community'),
            ),
            ref.watch(userCommunitiesProvider).when(
                data: (data) {
                  communtities = data;
                  if(data.isEmpty) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.only(left: 16,right: 16),
                      decoration: BoxDecoration(
                         border: Border.all(
                           color: Colors.black,
                           width: 2
                         ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButton(
                        elevation: 10,
                          hint: const Text('Select Community'),
                          dropdownColor: currentTheme.primaryColor,
                          iconSize: 36,
                          isExpanded: true,
                          value: selectedCommunity ?? data[0],
                          items: data.map((e) => DropdownMenuItem(value: e,child: Text('r/${e.name}'))).toList(),
                           onChanged: (val) {
                            setState(() {
                              selectedCommunity = val;
                            });
                           }),
                    ),
                  );
                },
                error: (error,stackTrace) => ErrorText(error: error.toString()),
                loading: () => const Loader())
          ],
        ),
      ),
    );
  }
}
