import 'package:flutter/material.dart';
import 'package:animated_splash/animated_splash.dart';
import 'package:presence_nan/pages/home.dart';
import 'package:presence_nan/pages/qrcode.dart';
import 'pages/login.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(PresenceApp());

class GraphDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    // First 
    // Je creer mon lien ( c est le lien qui me fournit les data graph)
    final HttpLink httpLink = HttpLink(
      uri: 'https://countries.trevorblades.com/',
    );

    /// Second 
    // Je creer un client qui excutera mes requettes
    //avec add de cache
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: httpLink,
      ),
    );
    
    /// Third 
    // GraphQLProvider doit envelopper notre materialApp

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
      
      // Requete
      //
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
