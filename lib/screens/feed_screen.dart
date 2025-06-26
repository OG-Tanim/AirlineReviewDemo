import 'package:flutter/material.dart';
import 'package:airlineapp/models/comment_model.dart';
import 'package:airlineapp/widgets/custom_drawer.dart';
import 'package:airlineapp/widgets/post_widget.dart';

/// A dedicated FeedScreen widget that matches the design from 'feed top.png',
/// displays an advertisement banner, and populates with review posts using PostWidget.
class FeedScreen extends StatelessWidget {
  FeedScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Use a ValueNotifier so new posts trigger a UI rebuild without altering the UI structure
  static final ValueNotifier<List<PostModel>>
  _postsNotifier = ValueNotifier<List<PostModel>>([
    const PostModel(
      avatarUrl: 'assets/avatar.png',
      userName: 'Davidlee',
      timeAgo: 'Mar 27',
      rating: 5.0,
      departureCode: 'DPS',
      arrivalCode: 'LHR',
      airline: 'Qatar Airways',
      travelClass: 'Business',
      travelDate: 'Jan 2024',
      reviewText:
          'DPS to LHR with Qatar Business Class. Truly a 5-star experience, Qatar never disappoints.',
      imageUrls: [
        'assets/post11.jpg',
        'assets/post12.jpg',
        'assets/post13.jpg',
        'assets/post14.jpg',
        'assets/post14.jpg',
        'assets/post14.jpg',
        'assets/post14.jpg',
      ],
      likeCount: 2,
      commentCount: 0,
      initialComments: <Comment>[],
    ),
    const PostModel(
      avatarUrl: 'assets/avatar.png',
      userName: 'Myat',
      timeAgo: '4 days ago',
      rating: 5.0,
      departureCode: 'LHR',
      arrivalCode: 'BKK',
      airline: 'Thai Airways International',
      travelClass: 'Business',
      travelDate: 'Jun 2025',
      reviewText:
          'Excellent Thai Airways Flight: London to Bangkok My Thai Airways flight from London Heathrow to Bangkok on their new B777 was outstanding! The "Excellent Thai Hospitality" was evident from the attentive crew to the comfortable and stylish business class cabin. The spacious seating and top-notch entertainment system made for a relaxing journey. Onboard dining was a true highlight, with beautifully presented and delicious meals. Every detail contributed to a premium experience. Way to go, Thai Airways! Highly recommend for a comfortable and enjoyable flight.',
      imageUrls: ['assets/post 21.jpeg', 'assets/post 22.jpeg'],
      likeCount: 5,
      commentCount: 1,
      initialComments: <Comment>[],
    ),
    const PostModel(
      avatarUrl: 'assets/avatar.png',
      userName: 'Alex',
      timeAgo: '2 weeks ago',
      rating: 4.5,
      departureCode: 'HKG',
      arrivalCode: 'ICN',
      airline: 'Cathay Pacific',
      travelClass: 'First Class',
      travelDate: 'Mar 2025',
      reviewText:
          'First time taking Cathay Business class! Food was great. But I fell asleep after starter and missed the main meal😅. Spacious and of course, slept very well.',
      imageUrls: ['assets/post 31.jpeg'],
      likeCount: 12,
      commentCount: 3,
      initialComments: <Comment>[],
    ),
  ]);

  /// Call this to add a post; triggers the ValueListenableBuilder
  static void addPost(PostModel post) {
    _postsNotifier.value = [post, ..._postsNotifier.value];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ----- Custom Top Section -----
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Airline Review',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Color(0xFF232323),
                    ),
                  ),
                  Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.notifications_none,
                            color: Color(0xFF232323),
                            size: 28,
                          ),
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF232323),
                                borderRadius: BorderRadius.circular(8.5),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 15,
                                minHeight: 15,
                              ),
                              child: const Center(
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.9,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Plus Jakarta Sans',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF232323),
                            width: 1.35,
                          ),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: const ClipOval(
                          child: Image(
                            image: AssetImage('assets/avatar.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                        child: const Icon(
                          Icons.menu,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // ---- Rest of the feed screen -----
            Expanded(
              child: ValueListenableBuilder<List<PostModel>>(
                valueListenable: _postsNotifier,
                builder: (context, posts, _) {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: posts.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/share'),
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text(
                              'Share your experience',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 23,
                              ),
                              textStyle: const TextStyle(letterSpacing: 1.5),
                            ),
                          ),
                        );
                      } else if (index == 1) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/advertisement.png',
                              fit: BoxFit.cover,
                              height: 128,
                              width: double.infinity,
                            ),
                          ),
                        );
                      } else {
                        final post = posts[index - 2];
                        return Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: PostWidget(
                            avatarUrl: post.avatarUrl,
                            userName: post.userName,
                            timeAgo: post.timeAgo,
                            rating: post.rating,
                            departureCode: post.departureCode,
                            arrivalCode: post.arrivalCode,
                            airline: post.airline,
                            travelClass: post.travelClass,
                            travelDate: post.travelDate,
                            reviewText: post.reviewText,
                            imageUrls: post.imageUrls,
                            likeCount: post.likeCount,
                            commentCount: post.commentCount,
                            initialComments: post.initialComments,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple model for feeding mock data into PostWidget
class PostModel {
  final String avatarUrl;
  final String userName;
  final String timeAgo;
  final double rating;
  final String departureCode;
  final String arrivalCode;
  final String airline;
  final String travelClass;
  final String travelDate;
  final String reviewText;
  final List<String> imageUrls;
  final int likeCount;
  final int commentCount;
  final List<Comment> initialComments;

  const PostModel({
    required this.avatarUrl,
    required this.userName,
    required this.timeAgo,
    required this.rating,
    required this.departureCode,
    required this.arrivalCode,
    required this.airline,
    required this.travelClass,
    required this.travelDate,
    required this.reviewText,
    required this.imageUrls,
    required this.likeCount,
    required this.commentCount,
    required this.initialComments,
  });
}
