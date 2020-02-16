import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poliferie_platform_flutter/bloc/test.dart';
import 'package:poliferie_platform_flutter/repositories/test_repository.dart';
import 'package:poliferie_platform_flutter/repositories/test_user_client.dart';
import 'package:poliferie_platform_flutter/repositories/test_user_cache.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO(@amerlo): Move from here
//import 'package:http/http.dart' as http;

final TestUserRepository usersRepository = TestUserRepository(
  usersApiClient: TestUserApiClient(
      //httpClient: http.Client(),
      ),
  usersCache: TestUserCache(),
);

class TestUserScreen extends StatefulWidget {
  final TestUserRepository usersRepository;

  const TestUserScreen({Key key, this.usersRepository}) : super(key: key);

  @override
  _TestUserScreenState createState() => _TestUserScreenState();
}

class _TestUserScreenState extends State<TestUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Github Users'),
      ),
      body: BlocProvider(
        create: (context) =>
            TestUserBloc(usersRepository: widget.usersRepository),
        child: SearchForm(),
      ),
    );
  }
}

// TODO(@amerlo): Move from here to widgets folder
class SearchForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_SearchBar(), _SearchBody()],
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _textController = TextEditingController();
  TestUserBloc _usersBloc;

  @override
  void initState() {
    super.initState();
    _usersBloc = BlocProvider.of<TestUserBloc>(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autocorrect: false,
      onChanged: (text) {
        _usersBloc.add(
          TextChanged(text: text),
        );
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: GestureDetector(
          child: Icon(Icons.clear),
          onTap: _onClearTapped,
        ),
        border: InputBorder.none,
        hintText: 'Enter a search term',
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    _usersBloc.add(TextChanged(text: ''));
  }
}

class _SearchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestUserBloc, TestUserState>(
      bloc: BlocProvider.of<TestUserBloc>(context),
      builder: (BuildContext context, TestUserState state) {
        if (state is SearchStateEmpty) {
          return Text('Please enter a term to begin');
        }
        if (state is SearchStateLoading) {
          return CircularProgressIndicator();
        }
        if (state is SearchStateError) {
          return Text(state.error);
        }
        if (state is SearchStateSuccess) {
          return state.items.isEmpty
              ? Text('No Results')
              : Expanded(child: _SearchResults(items: state.items));
        }
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<SearchResultItem> items;

  const _SearchResults({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _SearchResultItem(item: items[index]);
      },
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final SearchResultItem item;

  const _SearchResultItem({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Image.network(item.owner.avatarUrl),
      ),
      title: Text(item.fullName),
      // TODO(@amerlo): Make internal webview
      onTap: () async {
        if (await canLaunch(item.htmlUrl)) {
          await launch(item.htmlUrl);
        }
      },
    );
  }
}
