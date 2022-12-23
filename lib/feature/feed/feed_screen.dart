import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/Loader.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/feature/community/controller/community_controller.dart';
import 'package:reddit/feature/post/controller/post_controller.dart';
import '../../core/common/post_card.dart';
import '../auth/controller/auth_controller.dart';
class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    if(!isGuest) {
      return ref.watch(userCommunitiesProvider).when(data: (communities) =>
          ref.watch(userPostProvider(communities)).when(data: (data) {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final post = data[index];
                  return PostCard(post: post);
                });
          },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader())
          ,
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader());
    }
    return ref.watch(userCommunitiesProvider).when(data: (communities) =>
        ref.watch(userPostProvider(communities)).when(data: (data) {
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final post = data[index];
                return PostCard(post: post);
              });
        },
            error: (error,stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader())
        ,
        error: (error,stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
