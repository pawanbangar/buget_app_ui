import 'package:buget_app_ui/data/data.dart';
import 'package:buget_app_ui/models/category_model.dart';
import 'package:buget_app_ui/util/color_helper.dart';
import 'package:buget_app_ui/widget/bar_chart.dart';
import 'package:flutter/material.dart';

import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            forceElevated: true,
            floating: true,
            expandedHeight: 100.0,
            leading: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
              iconSize: 30.0,
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Simple Budget"),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
                iconSize: 30.0,
              )
            ],
          ),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index == 0) {
              return Container(
                margin: EdgeInsets.fromLTRB(3.0, 3.0, 3.0, 5.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 6.0),
                    ]),
                child: BarChart(weeklySpending),
              );
            } else {
              final Category category = categories[index - 1];
              double totalAmountSpent = 0;
              category.expenses.forEach((element) {
                totalAmountSpent += element.cost;
              });
              return _buildCategory(category, totalAmountSpent);
            }
          }, childCount: 1 + categories.length)),
        ],
      ),
    );
  }

  Widget _buildCategory(Category category, double totalAmountSpent) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryScreen(category: category),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        padding: EdgeInsets.all(20.0),
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, offset: Offset(0, 2), blurRadius: 0.6)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(category.name,
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0)),
                Text(
                  "\$ ${(category.maxAmount - totalAmountSpent).toStringAsFixed(2)} / \$ ${category.maxAmount.toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                )
              ],
            ),
            SizedBox(height: 10.0),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double maxBarWidth = constraints.maxWidth;
                final double percent = (category.maxAmount - totalAmountSpent) /
                    category.maxAmount;
                double barWidth = maxBarWidth * percent;
                if (barWidth < 0) {
                  barWidth = 0;
                }
                return Stack(
                  children: <Widget>[
                    Container(
                        height: 20.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15.0))),
                    Container(
                        height: 20.0,
                        width: barWidth,
                        decoration: BoxDecoration(
                            color: getColor(context, percent),
                            borderRadius: BorderRadius.circular(15.0)))
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
