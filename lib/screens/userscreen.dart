import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  static const routeName = "/UserScreen";
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: const Color(0xff40039B),
        elevation: 0,
        title: const Text(
          'JAJA',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: const EdgeInsets.all(4),
                color: Colors.grey.shade400,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: size.width / 4,
                      height: size.width / 4,
                      imageUrl:
                          'https://hatrabbits.com/wp-content/uploads/2017/01/random.jpg',
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          size: size.width * 0.1,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              // '${user.firstname} ${user.lastname}',
              'Asraful Islam',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              '0 Followers',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xff7BF946),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  'Follow',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Asraful's Recordings",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff7BF946),
        onPressed: () {
          // AuthController().signOut();
          Navigator.pushNamed(context, '/HomeScreen');
        },
        child: const Icon(
          Icons.home,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search',
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.white,
        filled: true,
        border: InputBorder.none,
        prefixIcon: const Icon(
          Icons.search,
          size: 24,
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            width: 2.0,
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            width: 2.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
