// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningdart/Pages/post_detail_page.dart';

class PostTypes extends StatefulWidget {
  final List<Map<String, dynamic>> posts;
  
  const PostTypes({
    super.key, 
    required this.posts,
  });

  @override
  PostTabState createState() => PostTabState();
}

class PostTabState extends State<PostTypes> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabcontroller = TabController(length: 3, vsync: this);
    return Column(
      children: [
        Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
                controller: _tabcontroller,
                isScrollable: true,
                labelPadding: EdgeInsets.only(left: 20, right: 40),
                labelColor: Color.fromRGBO(117, 216, 216, 1),
                unselectedLabelColor: Colors.white,
                indicatorColor: Color.fromRGBO(117, 216, 216, 1),
                tabs: [
                  Tab(
                      child: Text(
                    "Posts",
                    style: GoogleFonts.daysOne(fontSize: 14),
                  )),
                  Tab(
                      child: Text(
                    "Society",
                    style: GoogleFonts.daysOne(fontSize: 14),
                  )),
                  Tab(
                      child: Text(
                    "Tagged",
                    style: GoogleFonts.daysOne(fontSize: 14),
                  )),
                ]),
          ),
        ),
        Container(
          width: double.maxFinite,
          height: 300,
          child: TabBarView(
            controller: _tabcontroller, 
            children: [
              // Posts Tab
              widget.posts.isEmpty
                  ? _buildEmptyState("No posts yet", Icons.photo_library_outlined)
                  : GridView.builder(
                      itemCount: widget.posts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2),
                      itemBuilder: (context, index) {
                        final post = widget.posts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailPage(post: post),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                image: post['image_path'] != null
                                    ? DecorationImage(
                                        image: NetworkImage(post['image_path']),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: post['image_path'] == null
                                  ? Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        );
                      }),
              
              // Society Tab - Empty State
              _buildEmptyState("No society posts yet", Icons.groups_outlined),
              
              // Tagged Tab - Empty State
              _buildEmptyState("No tagged posts yet", Icons.tag_outlined),
            ]
          ),
        )
      ],
    );
  }
  
  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 60,
            color: Colors.grey[600],
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
