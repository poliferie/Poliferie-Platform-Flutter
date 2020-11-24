import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Poliferie.io/bloc/user.dart';
import 'package:Poliferie.io/repositories/repositories.dart';
import 'package:Poliferie.io/bloc/item.dart' as itm;
import 'package:Poliferie.io/models/models.dart';
import 'package:Poliferie.io/utils.dart';

import 'package:Poliferie.io/dimensions.dart';
import 'package:Poliferie.io/styles.dart';
import 'package:Poliferie.io/strings.dart';

import 'package:Poliferie.io/widgets/poliferie_progress_indicator.dart';
import 'package:Poliferie.io/widgets/poliferie_app_bar.dart';
import 'package:Poliferie.io/widgets/poliferie_item_card.dart';
import 'package:Poliferie.io/widgets/poliferie_filter.dart';

// TODO(@amerlo): Evaluate where to locate this variable
List<Filter> preferenceFilters = [
  Filter(
    "isee",
    unit: "€",
    name: "ISEE",
    hint: "Inserisci il tuo ISEE",
    description: "L'indicatore della situazione economica equivalente...",
    icon: Icons.accessibility,
    type: FilterType.selectValue,
    range: [],
  ),
  Filter(
    "cap",
    unit: "",
    name: "Codice Postale",
    hint: "Inserisci il tuo CAP di residenza",
    description: "Il CAP è numero di 5 cifre...",
    icon: Icons.local_post_office,
    type: FilterType.selectValue,
    range: [],
  ),
];

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class ProfileScreenBody extends StatefulWidget {
  final FavoritesRepository favoritesRepository;

  ProfileScreenBody({@required this.favoritesRepository});

  @override
  _ProfileScreenBodyState createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  // Items list are expanded
  Map<ItemType, bool> tabExpanded = {
    ItemType.course: false,
    ItemType.university: false
  };

  // Favorite list
  List<String> favoriteList = [];

  // Strings
  // TODO(@amerlo): Move from here to Strings.dart file
  final Map<ItemType, String> tabStrings = {
    ItemType.course: Strings.searchTabCourse,
    ItemType.university: Strings.searchTabUniversity,
  };

  /// Map of all [Filter]
  Map<int, Filter> filters = Map();
  Map<int, FilterStatus> filterStatus = Map();
  Map<int, Function> filterUpdates = Map();

  // TODO(@amerlo): Could we share this function with the search screen?
  void updateFilterStatus(int index, FilterType type, dynamic newValue) async {
    setState(() {
      if (type == FilterType.selectValue) {
        if (newValue == null) {
          filterStatus[index].values = [];
        } else {
          String newStringValue = newValue as String;
          filterStatus[index].values = [newStringValue];
          setPrefereceKey(filters[index].name, newStringValue);
        }
      } else {
        Text(
            "Error: this type of filter is not supported in the profile screen");
      }
    });
  }

  void _initFilters() async {
    filters = preferenceFilters.asMap();
    for (int i in filters.keys) {
      String storeValue = await getPrefereceKey(filters[i].name);
      if (storeValue != null) {
        filterStatus[i] = FilterStatus([storeValue]);
      } else {
        filterStatus[i] = FilterStatus([]);
      }
    }
    filterUpdates = filterStatus.map((i, s) => MapEntry(
        i,
        (FilterType type, dynamic newValue) =>
            updateFilterStatus(i, type, newValue)));
  }

  @override
  void initState() {
    super.initState();
    _updateFavorites();
    _initFilters();
  }

  // TODO(@amerlo): Could we avoid the duplcated state?
  void _updateFavorites({String toggleIndex}) async {
    if (toggleIndex != null)
      await widget.favoritesRepository.toggle(toggleIndex);
    final List<String> favorites = await widget.favoritesRepository.get();
    setState(() {
      favoriteList = favorites;
    });
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
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 3,
                offset: Offset(0, 1)),
          ],
          color: Styles.poliferieRed),
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
          bottom: 25.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          _buildUserImage(user.image),
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
      height: 60,
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
      margin: EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // TODO(@amerlo): Add separate counter (to do this we need to move
          //                the fetch items procedure in the the initializeState)
          _buildUserStatsCard(
              Strings.favorites, favoriteList.length.toString()),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, User user) {
    return Container(
      color: Styles.poliferieWhite,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _buildUserHero(context, user),
          _buildUserStats(user),
        ],
      ),
    );
  }

  // TODO(@amerlo): Animation is missing!
  Widget _buildItemsList(
      String listName, List<ItemModel> items, ItemType type) {
    List<ItemModel> itemsOfType = items.where((e) => e.type == type).toList();
    List<ItemModel> itemsToShow = [];
    if (itemsOfType.isNotEmpty) {
      itemsToShow = tabExpanded[type] ? itemsOfType : [itemsOfType[0]];
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(listName, style: Styles.tabHeading),
              Material(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (itemsOfType.length > 1) {
                        tabExpanded[type] = !tabExpanded[type];
                      }
                    });
                  },
                  child: Text(
                      tabExpanded[type]
                          ? Strings.listCollapse
                          : Strings.listExpand,
                      style: Styles.profileExpandAll),
                ),
              ),
            ],
          ),
          ...itemsToShow.map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: PoliferieItemCard(
                e,
                isFavorite: favoriteList.contains(e.id),
                onSetFavorite: () => _updateFavorites(toggleIndex: e.id),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(Strings.userSettings, style: Styles.tabHeading),
            ],
          ),
          ...filters.keys.map(
            (k) => PoliferieFilter(
              filters[k],
              filterStatus[k],
              updateValue: filterUpdates[k],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, ItemType type) {
    if (favoriteList.isEmpty) {
      return _buildItemsList(tabStrings[type], [], type);
    }
    BlocProvider.of<itm.ItemBloc>(context).add(itm.FetchItems(favoriteList));
    return BlocBuilder<itm.ItemBloc, itm.ItemState>(
      builder: (BuildContext context, itm.ItemState state) {
        if (state is itm.FetchStateLoading) {
          return PoliferieProgressIndicator();
        }
        if (state is itm.FetchStateSuccess) {
          return _buildItemsList(tabStrings[type], state.items, type);
        }
        return Text('This widge should never be reached');
      },
    );
  }

  Widget _buildUserBody(BuildContext context) {
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
          _buildFilters(context),
          _buildList(context, ItemType.course),
          _buildList(context, ItemType.university),
        ],
      ),
    );
  }

  // Widget _buildBody(BuildContext context, User user) {
  //   return ListView(
  //     children: <Widget>[
  //       Column(
  //         children: <Widget>[
  //           //_buildUserInfo(context, user),
  //           _buildUserBody(context),
  //         ],
  //       )
  //     ],
  //   );
  // }

  Widget build(BuildContext context) {
    final UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(FetchUser(userName: 'test'));

    return BlocBuilder<UserBloc, UserState>(
      builder: (BuildContext context, UserState state) {
        if (state is FetchStateLoading) {
          return Scaffold(
            appBar: PoliferieAppBar(),
            body: PoliferieProgressIndicator(),
          );
        }
        if (state is FetchStateError) {
          return Scaffold(
            appBar: PoliferieAppBar(),
            body: Text(state.error),
          );
        }
        if (state is FetchStateSuccess) {
          return Scaffold(
            body: CustomScrollView(slivers: <Widget>[
              PoliferieAppBar(
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: _buildUserInfo(context, state.user),
                ),
                bottomHeight: 300,
                sliverBar: true,
              ),
              SliverFillRemaining(
                child: _buildUserBody(context),
              ),
            ]),
          );
        }
        return Text('This should never be reached');
      },
    );
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(
              userRepository: RepositoryProvider.of<UserRepository>(context)),
        ),
        BlocProvider<itm.ItemBloc>(
          create: (context) => itm.ItemBloc(
              itemRepository: RepositoryProvider.of<ItemRepository>(context)),
        ),
      ],
      child: ProfileScreenBody(
          favoritesRepository:
              RepositoryProvider.of<FavoritesRepository>(context)),
    );
  }
}
