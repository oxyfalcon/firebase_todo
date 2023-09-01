import 'package:app/Provider/notify_provider.dart';
import 'package:app/screens/todo_list_screen/todo_list_screen.dart';
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
          bottom: TabBar(
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
      body: TabBarView(controller: _tabController, children: [
        const Tiles(),
        Consumer(builder: (_, ref, __) => ref.watch(markedPageDeciderProvider))
      ]),
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

          return Tab(
              child: LayoutBuilder(
                  builder: (context, constraints) => Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        color: color,
                        child: icon,
                      )));
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
