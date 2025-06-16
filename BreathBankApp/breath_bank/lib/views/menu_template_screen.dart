import 'package:breath_bank/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/widgets/navigation_menu.dart';

class MenuTemplateScreen extends StatefulWidget {
  final String title;
  final int currentIndex;
  final List<Tab> tabs;
  final List<Widget> tabViews;

  const MenuTemplateScreen({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.tabs,
    required this.tabViews,
  });

  @override
  State<MenuTemplateScreen> createState() => _MenuTemplateScreenState();
}

class _MenuTemplateScreenState extends State<MenuTemplateScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: kWhiteColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 7, 71, 94),
            child: TabBar(
              controller: _tabController,
              labelColor: kBackgroundColor,
              unselectedLabelColor: kWhiteColor,
              indicatorColor: kBackgroundColor,
              tabs: widget.tabs,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.tabViews,
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationMenu(currentIndex: widget.currentIndex),
    );
  }
}
