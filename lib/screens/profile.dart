import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/widgets/poliferie_item_card.dart';
import 'package:Poliferie.io/bloc/user.dart';
import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/bloc/item.dart' as itm;
import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:Poliferie.io/models/models.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';

// TODO(@amerlo): Where the repositories have to be declared?
final ItemRepository itemRepository =
    ItemRepository(itemClient: ItemClient(useLocalJson: true));

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
    // TODO(@amerlo): Add university and courses values
    width: 200,
    padding: EdgeInsets.all(10.0),
    margin: EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildUserStatsCard(Strings.userUniversities, '31'),
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

// TODO(@amerlo): Update this to support a list
Widget _buildItemsList(String listName, ItemModel item) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          child: Text(listName, style: Styles.tabHeading),
          padding: EdgeInsets.only(bottom: 10.0),
        ),
        PoliferieItemCard(item),
      ],
    ),
  );
}

Widget _buildList(BuildContext context, String listName, List<int> ids) {
  // TODO(@amerlo): Fetch multiple ids
  BlocProvider.of<itm.ItemBloc>(context).add(itm.FetchItem(ids[0]));

  return BlocBuilder<itm.ItemBloc, itm.ItemState>(
    builder: (BuildContext context, itm.ItemState state) {
      if (state is itm.FetchStateLoading) {
        return CircularProgressIndicator();
      }
      if (state is itm.FetchStateSuccess) {
        return _buildItemsList(listName, state.item);
      }
      return Text('This widge should never be reached');
    },
  );
}

Widget _buildUserBody(BuildContext context) {
  // TODO(@amerlo): Retrieve persistence lists
  final List<int> favoriteCourses = [1001];
  final List<int> favoriteProvider = [1002];

  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.bodyPaddingLeft, vertical: 10.0),
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Styles.poliferieWhite),
    child: Column(
      children: [
        _buildList(context, 'Corsi', favoriteCourses),
        _buildList(context, 'Università', favoriteProvider),
      ],
    ),
  );
}

Widget _buildBody(BuildContext context, User user) {
  return ListView(
    children: <Widget>[
      Column(
        children: <Widget>[
          _buildUserInfo(context, user),
          _buildUserBody(context),
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
      body: MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(userRepository: profileRepository),
          ),
          BlocProvider<itm.ItemBloc>(
            create: (context) => itm.ItemBloc(itemRepository: itemRepository),
          ),
        ],
        child: ProfileScreenBody(),
      ),
    );
  }
}
