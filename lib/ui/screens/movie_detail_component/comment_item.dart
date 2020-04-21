import 'package:flutter/material.dart';

import 'package:movie_app/models.dart';
import 'package:movie_app/uis.dart';

class CommentItem extends StatelessWidget {
  final Review review;
  CommentItem(this.review);
  
  @override
  Widget build(BuildContext context) {
    return _buildCommentItem(review);
  }

  Widget _buildCommentItem(Review review) {
    Widget avatar;
    Widget rate;
    Widget rateDate;
    if (review != null && review.detail != null) {
      if ( review.detail.avatarUrl != null ) {
        avatar = CommonWidgetBuilder.loadNetworkImage(
          review.detail.avatarUrl, width: 50, height: 50,
          roundRadius: 50
        );
      }
      if (review.detail.rateNum != null) {
        var rateNum = double.parse(review.detail.rateNum);
        rateNum = (rateNum / 10) * 5;
        rate = VoteStar(rating: rateNum, size: 10, starAlign: 7, textPadding: 5, textSize: 12);
      }
      if (review.detail.datetime != null) {
        rateDate = Text(
          review.detail.datetime,
          style: TextStyle(
            fontSize: 10, color: Color(0xFF9B9B9B)
          ),
        );
      }
    }
    if (avatar == null) {
      avatar = Icon(
        Icons.person
      );
    }
    if (rate == null) {
      rate = Container();
    }
    if (rateDate == null) {
      rateDate = Container();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50, height: 50,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration (
              border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
              borderRadius: BorderRadius.circular(40),
              color: Color(0xFF00CBCF)
            ),
            child: avatar,
          ),
          Container(
            width: 278,
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: review == null ? 22 : null,
                  width: review == null ? 130 : null,
                  color: review == null ? Color(0xFF4A4A4A) : null,
                  child: Text(
                   review == null ? "" : review.author,
                   style: TextStyle(color: Color(0xFF4A4A4A), fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 40,
                  width: review == null ? 278 : null,
                  color: review == null ? Color(0xFF4A4A4A) : null,
                  margin: review == null ? EdgeInsets.only(top: 10) : null,
                  child: Text(
                    review == null ? "" : review.content,
                    style: TextStyle(color: Color(0xFF4A4A4A)),
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: rate,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: rateDate,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Divider(color: Color(0xFFE1E1E1), height: 3),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}