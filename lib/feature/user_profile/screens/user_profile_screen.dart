import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/feature/auth/controller/auth_controller.dart';
import 'package:reddit/feature/user_profile/controller/user_profile_controller.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/Loader.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/post_card.dart';
class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({super.key,required this.uid});

  void navigateToEditProfile(BuildContext context) {
    Routemaster.of(context).push('/edit_profile/$uid');
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
          data: (user) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 250,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                            child: Image.network(user.banner,
                              fit: BoxFit.cover,
                            ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(20).copyWith(bottom: 70),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePic),
                            radius: 45,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(20),
                          child: OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: currentTheme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              onPressed: () => navigateToEditProfile(context) ,
                              child: Text('Edit Profile',style: TextStyle(color: currentTheme.backgroundColor),)),
                        )
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          const SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('r/${user.name}',style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(''
                                '${user.karma} karma'),
                          ),
                          const SizedBox(height: 10,),
                          const Divider(thickness: 2,)
                        ],
                      ),),
                  )
                ];
              },
              body: ref.watch(getUserPostsProvider(uid)).when(data: (data) {
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
