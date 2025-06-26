import 'dart:io';
import 'package:airlineapp/models/comment_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'comment_section.dart';

class PostWidget extends StatefulWidget {
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

  const PostWidget({
    super.key,
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

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  static const _bgChip = Color(0xFFF2F4F8);
  static const _textDark = Color(0xFF34303E);
  static const _textBlack = Color(0xFF232323);

  bool _liked = false;
  late int _likeCount;
  late int _commentCount;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.likeCount;
    _commentCount = widget.commentCount;
  }

  void _openImageViewer(BuildContext context, List<String> urls, int start) {
    final controller = PageController(initialPage: start);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              itemCount: urls.length,
              itemBuilder: (ctx, i) => InteractiveViewer(
                child: Image.network(
                  urls[i],
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, size: 30, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              left: 10,
              top: MediaQuery.of(context).size.height / 2 - 30,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () => controller.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: MediaQuery.of(context).size.height / 2 - 30,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () => controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Header: Avatar, Name, Time, Rating ─────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.avatarUrl),
                  radius: 21,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      widget.rating.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // ─── Flight Info Chips ──────────────────────────────────────
            Wrap(
              spacing: 8,
              children: [
                _buildChip(widget.departureCode),
                _buildChip(widget.arrivalCode),
                _buildChip(widget.airline),
                _buildChip(widget.travelClass),
                _buildChip(widget.travelDate),
              ],
            ),
            const SizedBox(height: 16),
            // ─── Review Text ────────────────────────────────────────────
            Text(
              widget.reviewText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _textBlack,
              ),
            ),
            const SizedBox(height: 16),
            // ─── Image Grid ─────────────────────────────────────────────
            if (widget.imageUrls.isNotEmpty) _buildImageGrid(widget.imageUrls),
            // ─── Like & Comment Count ──────────────────────────────────
            Row(
              children: [
                Text(
                  '$_likeCount Likes',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _textBlack,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '·',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 77, 69, 69),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$_commentCount Comments',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _textBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // ─── Action Buttons: Like & Share ──────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (_liked) {
                        _likeCount--;
                      } else {
                        _likeCount++;
                      }
                      _liked = !_liked;
                    });
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/like.svg',
                        width: 20.6,
                        height: 20.6,
                        colorFilter: ColorFilter.mode(
                          _liked ? Colors.blue : _textBlack,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Like',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _liked ? Colors.blue : _textBlack,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // onTap behavior here
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/share.svg',
                        width: 20.6,
                        height: 20.6,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _textBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ─── Comments Section (modular) ───────────────────────────
            CommentSection(
              initialComments: widget.initialComments,
              currentUserAvatar: widget.avatarUrl,
              currentUserName: widget.userName,
              onCommentAdded: () {
                setState(() {
                  _commentCount++;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.95, vertical: 3.47),
      decoration: BoxDecoration(
        color: _bgChip,
        borderRadius: BorderRadius.circular(8.68),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12.16,
          fontWeight: FontWeight.w600,
          color: _textDark,
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<String> imageUrls) {
    if (imageUrls.isEmpty) return const SizedBox();

    final total = imageUrls.length;
    final displayCount = total > 4 ? 4 : total;
    final crossAxisCount = total == 1 ? 1 : 2;
    final childAspectRatio = total == 1 ? 16 / 9 : 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: childAspectRatio.toDouble(),
        ),
        itemBuilder: (context, idx) {
          final url = imageUrls[idx];
          // Use Image.file for local paths, Image.network otherwise
          final isLocal = url.startsWith('/') || url.startsWith('file://');
          final img = ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isLocal
                ? Image.file(File(url), fit: BoxFit.cover)
                : Image.network(url, fit: BoxFit.cover),
          );

          Widget cell;
          if (idx == 3 && total > 4) {
            cell = Stack(
              fit: StackFit.expand,
              children: [
                img,
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(color: Colors.black45),
                ),
                Center(
                  child: Text(
                    '+${total - 4}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          } else {
            cell = img;
          }
          return GestureDetector(
            onTap: () => _openImageViewer(context, imageUrls, idx),
            child: cell,
          );
        },
      ),
    );
  }
}
