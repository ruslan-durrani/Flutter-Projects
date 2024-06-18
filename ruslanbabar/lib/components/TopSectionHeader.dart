import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/responsive.dart';

class TopSectionHeader extends StatefulWidget {
  final String title;
  final String subtitle;
  TopSectionHeader({super.key, required this.title, required this.subtitle});

  @override
  State<TopSectionHeader> createState() => _TopSectionHeaderState();
}

class _TopSectionHeaderState extends State<TopSectionHeader> {
  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home_max_rounded,color: Colors.black,),
                title: Text('Home',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
                onTap: () {
                  setState(() {
                    context.go('/');
                  });}
              ),
              ListTile(
                leading: Icon(Icons.person_outline,color: Colors.black,),
                title: Text('About',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
                onTap: () {
                  setState(() {
                    context.go('/about');
                  });}
              ),
              ListTile(
                  leading: Icon(Icons.cases_outlined,color: Colors.black,),
                  title: Text('Services',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
                  onTap: () {
                    setState(() {
                      context.go('/services');
                    });}
              ),
              ListTile(
                  leading: Icon(Icons.developer_mode,color: Colors.black,),
                  title: Text('Projects',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
                  onTap: () {
                    setState(() {
                      context.go('/projects');
                    });}
              ),
              ListTile(
                  leading: Icon(Icons.phone,color: Colors.black,),
                  title: Text('Contact',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
                  onTap: () {
                    setState(() {
                      context.go('/contacts');
                    });}
              ),

            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double pad =  28.0;
    return Container(
      width: Responsive.isDesktop(context)?MediaQuery.of(context).size.width/2 :MediaQuery.of(context).size.width,
      padding:  EdgeInsets.only(top: pad,left: pad,right: pad),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(widget.title,style: Theme.of(context).textTheme.displayLarge,),
              Text(widget.subtitle,style: Theme.of(context).textTheme.bodyMedium,)
            ],
          ),
          Spacer(),
          Responsive.isDesktop(context)?Container():InkWell(onTap:(){
            _showActionMenu(context);
          },child: Icon(Icons.menu,color: Theme.of(context).primaryColor,))
        ],
      ),
    );
  }
}
