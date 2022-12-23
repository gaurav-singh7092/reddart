import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:reddit/feature/auth/screens/login.dart';
import 'package:reddit/feature/community/screens/add_moderator_screen.dart';
import 'package:reddit/feature/community/screens/community_screen.dart';
import 'package:reddit/feature/community/screens/edit_community_screen.dart';
import 'package:reddit/feature/community/screens/mods_screen.dart';
import 'package:reddit/feature/home/screen/home_screen.dart';
import 'package:reddit/feature/post/screens/add_post_type_screen.dart';
import 'package:reddit/feature/post/screens/comments_screen.dart';
import 'package:reddit/feature/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'feature/community/screens/create_community.dart';
import 'feature/post/screens/comment.dart';
import 'feature/user_profile/screens/edit_profile_screen.dart';

final LoggedOutRoute = RouteMap(routes: {
  '/' : (_) => const MaterialPage(child: LoginScreen()),

});
final LoggedInRoute = RouteMap(routes: {
  '/' : (_) => const MaterialPage(child: HomeScreen()),
  '/create_community' : (_) => const MaterialPage(child: CreateCommunity()),
  '/r/:name' : (route) => MaterialPage(child: CommunityScreen(
    name: route.pathParameters['name']!,
  )
  ),
  '/mod_tools/:name' : (routeData) => MaterialPage(child: ModScreen(
    name: routeData.pathParameters['name']!,
  )),
  '/edit_community/:name' : (routeData) => MaterialPage(child: EditCommunityScreen (
    name: routeData.pathParameters['name']!,
  )),
  '/add_mods/:name' : (routeData) => MaterialPage(child: AddModsScreen (
    name: routeData.pathParameters['name']!,
  )),
  '/u/:uid' : (routeData) => MaterialPage(child: UserProfileScreen (
    uid: routeData.pathParameters['uid']!,
)),
  '/edit_profile/:uid' : (routeData) => MaterialPage(child: EditProfileScreen (
    uid: routeData.pathParameters['uid']!,
  )),
  '/add_post/:type' : (routeData) => MaterialPage(child: AddPostTypeScreen (
    type: routeData.pathParameters['type']!,
  )),
    '/post/:postId/comments' : (routeData) => MaterialPage(child: CommentScreen(
    postId: routeData.pathParameters['postId']!,
  )),
  '/post/:postId/comment_type' : (routeData) => MaterialPage(child: CommentType(
    postId: routeData.pathParameters['postId']!,
  )),
});