import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/bloc/user.dart';
import 'package:Poliferie.io/repositories/repositories.dart';

import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';
import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_badge.dart';
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

final _badgeList = <PoliferieBadge>[
  PoliferieBadge(
    imagePath: 'assets/images/mars.png',
    name: 'Esploratore',
    description: "Hai esplorato lo spazio profondo dell'offerta universitaria",
  ),
  PoliferieBadge(
    imagePath: 'assets/images/mars.png',
    name: 'Camminatore',
    description:
        "Hai approfondito le opportunità di studio in maniera lenta e dettagliata",
  )
];

Widget _buildUserHero(BuildContext context, String userImagePath, double size) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 25.0),
    child: Hero(
      tag: userImagePath,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(62.5),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(userImagePath),
          ),
        ),
      ),
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
    style: Styles.subHeadline,
  );
}

Widget _buildUserStatsCard(String tag, String value) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(value, style: Styles.profileStats),
      SizedBox(height: 5.0),
      Text(
        tag,
        style: Styles.profileUserInfoLabel,
      )
    ],
  );
}

Widget _buildUserStatsRow(int followers) {
  return Padding(
    padding: EdgeInsets.all(30.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildUserStatsCard(
            Strings.userFollowers.toUpperCase(), followers.toString()),
        _buildUserStatsCard(Strings.userUniversities.toUpperCase(), '31'),
        _buildUserStatsCard('Bucket List'.toUpperCase(), '21'),
      ],
    ),
  );
}

// TODO(@amerlo): Add list of onPressed() function
Widget _buildUserFilterBadges(List<IconData> icons) {
  return Padding(
    padding: EdgeInsets.only(left: 15.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for (var icon in icons)
          IconButton(
            icon: Icon(icon),
            onPressed: () {},
          )
      ],
    ),
  );
}

Widget _buildBody(BuildContext context, User user) {
  return ListView(
    children: <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildUserHero(context, 'assets/images/andrea_profile.png', 150.0),
          _buildUserName(user.name),
          _buildUserSubHeadline(user.city),
          _buildUserStatsRow(user.followers),
          _buildUserFilterBadges([Icons.table_chart, Icons.menu]),
          ..._badgeList.where((b) => user.badges.contains(b.name)),
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
