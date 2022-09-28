import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchUser extends StatelessWidget {
  static const routeName = "/SearchUserScreen";
  const SearchUser({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff40039B),
        elevation: 0,
        title: const Text(
          'JAJA',
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 14,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(
              size: size.width,
              context: context,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Trending",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildUserCard(
              onTap: () {
                Navigator.pushNamed(context, '/UserScreen');
                log('message1');
              },
              title: 'Asraful Islam',
              follewers: '0 Followers',
              imageurl:
                  'https://hatrabbits.com/wp-content/uploads/2017/01/random.jpg',
              size: size.width,
            ),
            _buildUserCard(
              onTap: () {
                log('message2');
              },
              title: 'Asraful Islam',
              follewers: '0 Followers',
              imageurl: '',
              size: size.width,
            ),
          ],
        ),
      ),
    );
  }

  _buildSearchBar({required double size, required BuildContext context}) {
    return Row(
      children: [
        Flexible(
          child: TextField(
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
          ),
        ),
        SizedBox(
          width: size * 0.02,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/ProfileScreen');
          },
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person,
              size: size * 0.1,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ],
    );
  }

  _buildUserCard({
    required String imageurl,
    required String title,
    required String follewers,
    required double size,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Card(
        elevation: 2,
        child: ListTile(
          title: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            follewers,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: const EdgeInsets.all(2),
              color: Colors.grey.shade400,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: size / 7,
                    height: size / 7,
                    imageUrl: imageurl,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        size: size * 0.1,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
