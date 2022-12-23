import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/Loader.dart';
import 'package:reddit/core/common/error_text.dart';
import 'package:reddit/feature/auth/controller/auth_controller.dart';
import 'package:reddit/feature/community/controller/community_controller.dart';
import 'package:reddit/feature/community/repository/community_repository.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/post_card.dart';
import '../../../model/community_model.dart';
class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateToMods(BuildContext context) {
    Routemaster.of(context).push('/mod_tools/$name');
  }
  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref.read(communityControllerProvider.notifier).joinCommunity(community, context);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
          data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                       children: [
                         Positioned.fill(
                             child: Image.network(community.banner,
                           fit: BoxFit.cover,))
                       ],
                    ),
                  ),
                  SliverPadding(
                      padding: const EdgeInsets.all(8),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                      [
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                            radius: 35,
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('r/${community.name}',style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                            if(!isGuest)
                            community.moderators.contains(user.uid) ?
                            OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                              ),
                                onPressed: () => navigateToMods(context),
                                child: const Text('Mod Tools'))
                            : OutlinedButton(
                              style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              onPressed: () => joinCommunity(ref, community, context) ,
                              child: Text(community.members.contains(user.uid) ? 'Joined' : 'Join'))
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 0.2),
                        child: Text(''
                            '${community.members.length} members'),),
                      ],
                    ),),
                  )
                ];
              },
              body: ref.watch(getCommunityPostsProvider(name)).when(data: (data) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = data[index];
                      return PostCard(post: post);
                    });
              }, error: (error,stackTrace) => ErrorText(error: error.toString()),
                  loading: () => const Loader()),
          ),
          error: (error,stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
