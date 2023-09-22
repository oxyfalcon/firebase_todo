import 'package:app/Provider/future_provider.dart';
import 'package:app/profile.dart';
import 'package:app/screens/done_list_screen/marked_todo_list.dart';
import 'package:app/screens/todo_list_screen/todo_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 0;
  int previousIndex = 0;
  bool onTapFlag = false;

  void changeFlag() {
    setState(() {
      onTapFlag = false;
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
        previousIndex = _tabController.previousIndex;
      });
    });
    _tabController.animation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) onTapFlag = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            StreamBuilder(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) =>
                    Text(snapshot.data?.displayName ?? "")),
            InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage())),
                child: Consumer(builder: (context, ref, child) {
                  var profileUrl = ref.watch(profileUrlProvider);
                  return profileUrl.when(
                      data: (url) => CustomUserAvatar(url: url),
                      error: (error, stacktrace) => Text(error.toString()),
                      loading: () =>
                          const CircularProgressIndicator.adaptive());
                })),
          ],
          bottom: TabBar(
              labelPadding: EdgeInsets.zero,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              indicator: const UnderlineTabIndicator(),
              controller: _tabController,
              onTap: (value) => setState(() {
                    onTapFlag = true;
                  }),
              tabs: [
                CustomTabs(
                    index: 0,
                    controller: _tabController,
                    currentIndex: currentIndex,
                    onTapFlag: onTapFlag,
                    previousIndex: previousIndex,
                    icon: const Icon(Icons.list)),
                CustomTabs(
                    index: 1,
                    controller: _tabController,
                    currentIndex: currentIndex,
                    onTapFlag: onTapFlag,
                    previousIndex: previousIndex,
                    icon: const Icon(Icons.check)),
              ]),
          title: const Text("Todo"),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: TabBarView(
          controller: _tabController,
          children: const <Widget>[TileDisplay(), MarkedTiles()]),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    );
  }
}

class CustomTabs extends StatelessWidget {
  const CustomTabs({
    super.key,
    required this.index,
    required TabController controller,
    required this.currentIndex,
    required this.onTapFlag,
    required this.previousIndex,
    required this.icon,
  }) : _tabController = controller;
  final TabController _tabController;
  final int previousIndex;
  final int currentIndex;
  final bool onTapFlag;
  final int index;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _tabController.animation!,
        builder: (context, child) {
          double offset = _tabController.offset;
          int different = currentIndex - previousIndex;
          double colorOffset = offset / different.abs();
          Color? color = _colorFinder(
              offset,
              index,
              colorOffset,
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.inversePrimary);

          return Tab(child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: color,
              ),
              width: constraints.biggest.width,
              height: constraints.maxHeight,
              child: icon,
            );
          }));
        });
  }

  Color? _colorFinder(double offset, int index, double colorOffset,
      Color primary, Color secondary) {
    Color? localColor;
    if (offset > 0) {
      if (index <= currentIndex + 1 && index >= currentIndex) {
        if (currentIndex == index) {
          localColor = Color.lerp(primary, secondary, offset);
        } else if (onTapFlag == false) {
          localColor = Color.lerp(secondary, primary, offset);
        } else if (previousIndex == index && onTapFlag == true) {
          localColor = Color.lerp(secondary, primary, colorOffset);
        }
      } else if (previousIndex == index && onTapFlag == true) {
        localColor = Color.lerp(secondary, primary, colorOffset);
      }
    } else {
      if (index <= currentIndex && index >= currentIndex - 1) {
        if (currentIndex == index) {
          localColor = Color.lerp(primary, secondary, -offset);
        } else if (onTapFlag == false) {
          localColor = Color.lerp(secondary, primary, -offset);
        } else if (previousIndex == index && onTapFlag == true) {
          localColor = Color.lerp(secondary, primary, -colorOffset);
        }
      } else if (previousIndex == index && onTapFlag == true) {
        localColor = Color.lerp(secondary, primary, -colorOffset);
      }
    }
    return localColor;
  }
}
