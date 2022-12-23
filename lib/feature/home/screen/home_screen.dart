import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/feature/home/delegate/search_community_delegate.dart';
import 'package:reddit/feature/home/drawers/community_list_drawer.dart';
import 'package:reddit/theme/pallete.dart';
import '../../auth/controller/auth_controller.dart';
import '../drawers/profile_drawer.dart';
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}
  class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;
  void DisplayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }
  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }
  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home',style: TextStyle(color: currentTheme.backgroundColor),),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => DisplayDrawer(context),
            );
          }
        ),
        actions: [
          IconButton(onPressed: () {
            showSearch(context: context, delegate: SearchCommunityDelegate(ref));
          }, icon: const Icon(Icons.search)),
          Builder(
            builder: (context) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
                onPressed: () => displayEndDrawer(context),
              );
            }
          )
        ],
      ),
      body: Constants.tabWidget[_page],
      drawer: const CommunityListDrawer(),
      endDrawer: isGuest ? null : const ProfileDrawer(),
      bottomNavigationBar: isGuest ? null : CupertinoTabBar(
        activeColor: currentTheme.backgroundColor,
        backgroundColor: currentTheme.primaryColor,
        items:  [
          BottomNavigationBarItem(
              activeIcon: const Icon(Icons.home,color: Colors.blue,),
              icon: Icon(Icons.home,color: currentTheme.backgroundColor,),
              label: 'Home'
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(Icons.add,color: Colors.blue,),
              icon: Icon(Icons.add,color: currentTheme.backgroundColor,),
              label: 'Add Post'
          ),
        ],
        onTap: onPageChanged,
        currentIndex: _page,
      ),

    );
  }
}
