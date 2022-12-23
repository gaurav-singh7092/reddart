import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/feature/post/controller/post_controller.dart';
import 'package:reddit/feature/post/widget/comment_card.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/common/Loader.dart';
import '../../../core/common/error_text.dart';
import '../../../model/post_model.dart';
import '../../../theme/pallete.dart';
import '../../auth/controller/auth_controller.dart';
class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({super.key,required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
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
      commentController.text = '';
    });

  }
  void navigateToCommentType() {
    Routemaster.of(context).push('/post/${widget.postId}/comment_type');
  }
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comment Section'),
      ),
      body: ref.watch(getPostbyIdProvider(widget.postId)).when(data: (data) {
        return SafeArea(
            child: Column(
              children: [
                PostCard(post: data),
                ref.watch(getCommentsProvider(widget.postId)).when(data: (comments) {
                  return Expanded(
                    child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (BuildContext context, int index) {
                      final comment = comments[index];
                      return CommentCard(comment: comment);
            }),
                  );
                }, error: (error,stackTrace) => ErrorText(error: error.toString()),
                    loading: () => const Loader()),
                if(!isGuest)
                  GestureDetector(
                    onTap: () => navigateToCommentType(),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
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
        );
      }, error: (error,stackTrace) => ErrorText(error: error.toString()) ,
          loading: () => const Loader()),
    );
  }
}
