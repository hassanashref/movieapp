import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = 'HomePage';


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedNav = 0;
  int selectedMovie = 1;

  final List<String> topMovies = [
    'assets/images/movie2.png',
    'assets/images/movie6.png',
    'assets/images/movie4.png',
  ];

  final List<String> watchMovies = [
    'assets/images/movie3.png',
    'assets/images/movie2.png',
    'assets/images/movie1.png',
  ];

  final List<String> topRatings = ['8.3', '8.8', '8.1'];

  final List<String> watchRatings = ['7.9', '8.5', '8.0'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff17191A),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final s = w / 375;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 470 * s,
                    width: w,
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/movie6.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.76),
                          ),
                        ),
                        Positioned(
                          top: 10 * s,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Image.asset(
                              'assets/images/available_now.png',
                              width: 165 * s,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          left: -70 * s,
                          top: 105 * s,
                          child: _topPoster(
                            image: topMovies[0],
                            rating: topRatings[0],
                            width: 125 * s,
                            height: 240 * s,
                            radius: 14 * s,
                            index: 0,
                          ),
                        ),
                        Positioned(
                          right: -70 * s,
                          top: 105 * s,
                          child: _topPoster(
                            image: topMovies[2],
                            rating: topRatings[2],
                            width: 125 * s,
                            height: 240 * s,
                            radius: 14 * s,
                            index: 2,
                          ),
                        ),
                        Positioned(
                          top: 68 * s,
                          left: (w - (188 * s)) / 2,
                          child: _topPoster(
                            image: topMovies[1],
                            rating: topRatings[1],
                            width: 188 * s,
                            height: 305 * s,
                            radius: 18 * s,
                            index: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.black,
                    padding: EdgeInsets.fromLTRB(18 * s, 4 * s, 18 * s, 0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/watch_now.png',
                          width: 225 * s,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 14 * s),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Action',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13 * s,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('See More'),
                                    duration: Duration(milliseconds: 700),
                                  ),
                                );
                              },
                              child: Text(
                                'See More >',
                                style: TextStyle(
                                  color: const Color(0xffffcf00),
                                  fontSize: 13 * s,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8 * s),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(watchMovies.length, (index) {
                            return _watchPoster(
                              image: watchMovies[index],
                              rating: watchRatings[index],
                              width: 105 * s,
                              height: 152 * s,
                              radius: 10 * s,
                              index: index,
                            );
                          }),
                        ),
                        SizedBox(height: 8 * s),
                        Container(
                          height: 62 * s,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xff242626),
                            borderRadius: BorderRadius.circular(4 * s),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _navItem(
                                icon: Icons.home_rounded,
                                index: 0,
                                scale: s,
                              ),
                              _navItem(
                                icon: Icons.search_rounded,
                                index: 1,
                                scale: s,
                              ),
                              _navItem(
                                icon: Icons.movie_outlined,
                                index: 2,
                                scale: s,
                              ),
                              _navItem(
                                icon: Icons.person_outline_rounded,
                                index: 3,
                                scale: s,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14 * s),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _topPoster({
    required String image,
    required String rating,
    required double width,
    required double height,
    required double radius,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMovie = index;
        });
      },
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Image.asset(image, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      rating,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Image.asset(
                      'assets/images/star.png',
                      width: 10,
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _watchPoster({
    required String image,
    required String rating,
    required double width,
    required double height,
    required double radius,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMovie = index;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Movie ${index + 1} selected'),
            duration: const Duration(milliseconds: 600),
          ),
        );
      },
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Image.asset(image, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      rating,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Image.asset('assets/images/star.png', width: 9, height: 9),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required int index,
    required double scale,
  }) {
    final active = selectedNav == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedNav = index;
        });
      },
      borderRadius: BorderRadius.circular(30 * scale),
      child: SizedBox(
        width: 45 * scale,
        height: 45 * scale,
        child: Center(
          child: Icon(
            icon,
            size: 21 * scale,
            color: active ? const Color(0xffffd400) : Colors.white,
          ),
        ),
      ),
    );
  }
}
