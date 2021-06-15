import 'package:flutter/material.dart';
import 'package:nd/constants.dart';

class CategoryTitle extends StatelessWidget {
  final String title;
  final bool active;
  const CategoryTitle({
    Key key,
    this.title,
    this.active = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 7, right: 5, left: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: secondColor),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 30, top: 10, bottom: 10),
        child: Text(
          title,
          style: Theme.of(context).textTheme.button.copyWith(
                color: active ? secondColor : Colors.black45,
              ),
        ),
      ),
    );
  }
}

// We need statefull widget because we are gonna change some state on our category
class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  // by default first item will be selected
  int selectedIndex = 0;
  List categories = [
    'Принятые',
    'Срочные',
    'Одобренные',
    'Редактирование',
    'Отказано'
  ];
  List statuses = [
    'all',
    'fast',
    'success',
    'edit',
    'error',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30 / 2),
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: 10,
              right: index == categories.length - 1 ? 10 : 0,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color:
                    index == selectedIndex ? secondColor : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 1, color: secondColor)),
            child: Text(
              categories[index],
              style: TextStyle(
                color: index == selectedIndex ? Colors.white : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
