import 'package:flutter/material.dart';
import 'package:animated_splash/animated_splash.dart';
import 'package:presence_nan/pages/home.dart';
import 'package:presence_nan/pages/qrcode.dart';
import 'pages/login.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(PresenceApp());

class PresenceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.black),
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplash(
        imagePath: 'images/logo-nan.png',
        home: LoginPage(),
        duration: 2000,
        type: AnimatedSplashType.StaticDuration,
      ),
    );
  }
}

class GraphDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      uri: 'https://countries.trevorblades.com/',
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: httpLink,
      ),
    );

    return GraphQLProvider(
      child: MaterialApp(
        title: "Demo GraphQl",
        theme: ThemeData.dark(),
        home: HomeGraphQl(),
      ),
      client: client,
    );
  }
}

class HomeGraphQl extends StatefulWidget {
  @override
  _HomeGraphQlState createState() => _HomeGraphQlState();
}

class _HomeGraphQlState extends State<HomeGraphQl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("use graphQl with Tary"),
      ),
      body: Query(options: QueryOptions(document: r""" 
            query GetCountries{
                countries {
                  name
                  phone
                }
              } """),
          builder: (QueryResult result , { VoidCallback refetch, FetchMore fetchMore }){

            if (result.errors != null) {
              return Text(result.errors.toString());
            }

            if (result.loading) {
              return Text('Loading');
            }

            List countries = result.data['countries'];

            return ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  final country = countries[index];

                  return Text(country['name']);
                });
          }),
    );
  }
}
