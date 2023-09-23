import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:codefury/helper/helper_function.dart';
import 'package:codefury/pages/chat_page.dart';
import 'package:codefury/service/database_service.dart';
import 'package:codefury/widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  String userName = "";
  bool isJoined = false;
  User? user;
  List<QueryDocumentSnapshot> filteredResults = [];

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Search",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      initiateSearchMethod(value);
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search groups....",
                        hintStyle:
                        TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod(searchController.text);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          )
              : groupList(),
        ],
      ),
    );
  }

  Widget groupList() {
    if (searchSnapshot == null || filteredResults.isEmpty) {
      return Center(
        child: Text(
          "No Results Found",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: filteredResults.length,
        itemBuilder: (context, index) {
          return groupTile(
            userName,
            filteredResults[index]['groupId'],
            filteredResults[index]['groupName'],
            filteredResults[index]['admin'],
          );
        },
      );
    }
  }

  initiateSearchMethod(String query) async {
    setState(() {
      isLoading = true;
      filteredResults = [];
    });

    if (query.isNotEmpty) {
      await DatabaseService()
          .searchByName(query)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          filterResults(query);
        });
      });
    } else {
      setState(() {
        searchSnapshot = null;
        isLoading = false;
      });
    }
  }

  void filterResults(String query) {
    filteredResults = searchSnapshot!.docs.where((doc) {
      final groupName = doc['groupName'].toLowerCase();
      for (var i = 1; i <= query.length; i++) {
        if (!groupName.startsWith(query.substring(0, i))) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title:
      Text(groupName, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid)
              .toggleGroupJoin(groupId, userName, groupName);
          if (isJoined) {
            setState(() {
              isJoined = !isJoined;
            });
            showSnackbar(context, Colors.green, "Successfully joined he group");
            Future.delayed(const Duration(seconds: 2), () {
              nextScreen(
                  context,
                  ChatPage(
                      groupId: groupId,
                      groupName: groupName,
                      userName: userName));
            });
          } else {
            setState(() {
              isJoined = !isJoined;
              showSnackbar(context, Colors.red, "Left the group $groupName");
            });
          }
        },
        child: isJoined
            ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 1),
          ),
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const Text(
            "Joined",
            style: TextStyle(color: Colors.white),
          ),
        )
            : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor,
          ),
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const Text("Join Now",
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
