import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/bloc/user.dart';
import 'package:Poliferie.io/repositories/repositories.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:Poliferie.io/models/models.dart';

final UserRepository profileRepository = UserRepository(
  userClient: UserClient(useLocalJson: true),
  userCache: UserCache(),
);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

Widget _buildUserImage(String userImagePath) {
  return Hero(
    tag: userImagePath,
    child: Container(
      height: 100.0,
      width: 100.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Styles.poliferieWhite,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(62.5),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(userImagePath),
        ),
      ),
    ),
  );
}

Widget _buildUserHero(BuildContext context, User user) {
  return Container(
    margin: EdgeInsetsDirectional.only(bottom: 40.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: Styles.poliferieRed),
    padding: EdgeInsets.symmetric(vertical: 25.0),
    width: double.infinity,
    child: Column(
      children: <Widget>[
        _buildUserImage('assets/images/andrea_profile.png'),
        _buildUserName(user.name),
        _buildUserSubHeadline(user.school),
        _buildUserSubHeadline(user.city),
      ],
    ),
  );
}

Widget _buildUserName(String userName) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
    child: Text(
      userName,
      style: Styles.profileUserName,
    ),
  );
}

Widget _buildUserSubHeadline(String text) {
  return Text(
    text,
    style: Styles.profileSubHeadline,
  );
}

Widget _buildUserStatsCard(String tag, String value) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(value, style: Styles.profileStats),
      Divider(
        height: 5.0,
      ),
      Text(
        tag,
        style: Styles.profileUserInfoLabel,
      )
    ],
  );
}

Widget _buildUserStats(User user) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 3,
              offset: Offset(0, 1)),
        ],
        color: Styles.poliferieWhite),
    // TODO(@amerlo): How to properly scale this?
    width: 200,
    padding: EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildUserStatsCard(Strings.userUniversities.toUpperCase(), '31'),
        _buildUserStatsCard(Strings.userCourses, '21'),
      ],
    ),
  );
}

Widget _buildUserInfo(BuildContext context, User user) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: <Widget>[
      _buildUserHero(context, user),
      _buildUserStats(user),
    ],
  );
}

Widget _buildBody(BuildContext context, User user) {
  final List<ItemModel> favoriteCourses = null;
  final List<ItemModel> favoriteProvider = null;
  return ListView(
    children: <Widget>[
      Column(
        children: <Widget>[
          _buildUserInfo(context, user),
          //_buildList('Corsi', favoriteCourses),
          //_buildList('Università', favoriteProvider),
        ],
      )
    ],
  );
}

class ProfileScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(FetchUser());

    return BlocBuilder<UserBloc, UserState>(
      builder: (BuildContext context, UserState state) {
        if (state is FetchStateLoading) {
          return CircularProgressIndicator();
        }
        if (state is FetchStateError) {
          return Text(state.error);
        }
        if (state is FetchStateSuccess) {
          return _buildBody(context, state.user);
        }
        return Text('This widge should never be reached');
      },
    );
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PoliferieAppBar(),
      body: BlocProvider<UserBloc>(
        create: (context) => UserBloc(userRepository: profileRepository),
        child: ProfileScreenBody(),
      ),
    );
  }
}
