import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategorySection extends StatelessWidget {
  const HomeCategorySection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Image(
            image: AssetImage("assets/images/bean_oi_category.png"),
            width: 95,
            height: 25,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Color(0xff333333),
            ),
          ),
          width: Get.width,
          height: 170,
          child: GridView.count(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
            crossAxisSpacing: 10,
            crossAxisCount: 4,
            children: List.filled(8, buildCategoryItem()),
          ),
        ),
      ],
    );
  }

  Widget buildCategoryItem() {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          print('Click category');
        },
        child: Container(
          child: Column(
            children: [
              Container(
                width: 45,
                height: 45,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/unidelivery-fad6f.appspot.com/o/images%2Ficons8-rice-bowl-48.png?alt=media&token=5a66159a-0bc1-4527-857d-7fc2801026f4',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 100,
                      color: Colors.grey,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    MaterialIcons.broken_image,
                    color: kPrimary.withOpacity(0.5),
                  ),
                ),
              ),
              Text('Cơm', style: kTitleTextStyle.copyWith(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
