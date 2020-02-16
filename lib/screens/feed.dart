import 'package:flutter/material.dart';

import 'package:poliferie_platform_flutter/widgets/poliferie_app_bar.dart';
import 'package:poliferie_platform_flutter/models/models.dart';
import 'package:poliferie_platform_flutter/styles.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // TODO(@amerlo): Change to real data
  final _posts = mockPosts;

  // UI values
  static const _paddingPost = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PoliferieAppBar(icon: Icons.message, onTap: () {}),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, position) {
          PostModel _post = _posts[position];
          return InkWell(
            onTap: () {},
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(_paddingPost),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(_post.imagePath),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: _paddingPost),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: RichText(
                                        maxLines: 2,
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: _post.username,
                                            style: Styles.feedPostTitle,
                                          ),
                                          TextSpan(
                                            text: " " + _post.userHandle,
                                            style: Styles.feedPostHandle,
                                          ),
                                          TextSpan(
                                            text: " ${_post.time}",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.grey),
                                          )
                                        ]),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    flex: 5,
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.more_horiz,
                                        color: Styles.poliferieDarkGrey,
                                      ),
                                      onPressed: () {},
                                    ),
                                    flex: 1,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: _paddingPost),
                              child: Text(
                                _post.post,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.message,
                                    color: Styles.poliferieDarkGrey,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(
                                    _post.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _post.isLiked
                                        ? Styles.poliferieRedAccent
                                        : Styles.poliferieDarkGrey,
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.share,
                                    color: Styles.poliferieDarkGrey,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
