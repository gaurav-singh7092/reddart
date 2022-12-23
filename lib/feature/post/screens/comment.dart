import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/Loader.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:routemaster/routemaster.dart';
import '../../../model/post_model.dart';
import '../../../theme/pallete.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/post_controller.dart';
class CommentType extends ConsumerStatefulWidget {
  final String postId;
  const CommentType({super.key,required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentTypeState();
}

class _CommentTypeState extends ConsumerState<CommentType> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }
  void addComment(Post post) {

    ref.read(postControllerProvider.notifier).addComment(
        context: context,
        text: commentController.text.trim(),
        post: post
    );
    setState(() {
      commentController.clear();
    });
    Routemaster.of(context).push('/post/${widget.postId}/comments');
  }
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
        appBar: AppBar(
        title: const Text('Comment'),
    ),
      body: ref.watch(getPostbyIdProvider(widget.postId)).when(data: (data) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  onSubmitted: (val) => addComment(data),
                  controller: commentController,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: "What's your thought?",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLength: 30,
                ),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: () => addComment(data),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Pallete.blueColor,
                        shape: BoxShape.rectangle,
                        ),
                      child: const Center(
                        child: Text(
                          'Comment',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],

            ),
          ),
        );
      },
          error: (error,stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}


