// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';  // BlocProvider uchun
// import '../../bloc/recip_bloc.dart';
// import '../../bloc/recip_event.dart';
// import '../../bloc/recip_state.dart';
// import '../../services/firebase_auth_service.dart';
// import '../widgets/add_recip.dart';
// import '../widgets/recips_list.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(() {
//       setState(() {
//         _searchQuery = _searchController.text;
//       });
//     });
//
//     // Blocni ishga tushurish
//     context.read<RecipBloc>().add(LoadRecips());
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Retseplar"),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               final firebaseAuth = FirebaseAuthService();
//               await firebaseAuth.logout();
//               Navigator.pushReplacementNamed(context, '/login'); // Ensure '/login' route is defined
//             },
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: BlocBuilder<RecipBloc, RecipState>(
//         builder: (context, state) {
//           if (state is RecipLoadInProgress) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is RecipLoadSuccess) {
//             final recips = state.recips.where((recip) => recip.recepName.contains(_searchQuery)).toList();
//             return Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Search field
//                   TextField(
//                     controller: _searchController,
//                     decoration: const InputDecoration(
//                       labelText: 'Search by name',
//                       border: OutlineInputBorder(),
//                       suffixIcon: Icon(Icons.search),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // RecipsList widget with filtered recipes
//                   Expanded(
//                     child: RecipsList(searchQuery: _searchQuery),
//                   ),
//                 ],
//               ),
//             );
//           } else if (state is RecipLoadFailure) {
//             return Center(child: Text('Failed to load recipes: ${state.error}'));
//           }
//           return const Center(child: Text('Select an action'));
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (ctx) {
//               return ManageRecip();
//             },
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/recip_bloc.dart';
import '../../bloc/recip_event.dart';
import '../../bloc/recip_state.dart';
import '../../services/firebase_auth_service.dart';
import '../widgets/add_recip.dart';
import '../widgets/recips_list.dart';
import 'profile_screen.dart'; // Import the new profile screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });

    // Blocni ishga tushurish
    context.read<RecipBloc>().add(LoadRecips());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = BlocBuilder<RecipBloc, RecipState>(
          builder: (context, state) {
            if (state is RecipLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecipLoadSuccess) {
              final recips = state.recips.where((recip) => recip.recepName.contains(_searchQuery)).toList();
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search field
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search by name',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // RecipsList widget with filtered recipes
                    Expanded(
                      child: RecipsList(searchQuery: _searchQuery),
                    ),
                  ],
                ),
              );
            } else if (state is RecipLoadFailure) {
              return Center(child: Text('Failed to load recipes: ${state.error}'));
            }
            return const Center(child: Text('Select an action'));
          },
        );
        break;
      case 1:
        body = const ProfileScreen();
        break;
      default:
        body = const Center(child: Text('Select an action'));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Retseplar"),
        actions: [
          IconButton(
            onPressed: () async {
              final firebaseAuth = FirebaseAuthService();
              await firebaseAuth.logout();
              Navigator.pushReplacementNamed(context, '/login'); // Ensure '/login' route is defined
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return ManageRecip();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
