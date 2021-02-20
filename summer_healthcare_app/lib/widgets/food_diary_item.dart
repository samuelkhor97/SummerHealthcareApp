import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:summer_healthcare_app/services/firebase/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String backendUrl = env['backendUrl'];

class FoodDiaryItem extends StatefulWidget {
  final String name;
  final String calories;
  final String picture;
  final Function onImageTap;

  FoodDiaryItem({this.name, this.calories, this.picture, this.onImageTap});

  @override
  _FoodDiaryItemState createState() => _FoodDiaryItemState();
}

class _FoodDiaryItemState extends State<FoodDiaryItem> {
  String authToken;

  @override
  void initState() {
    super.initState();
    setToken();
  }

  void setToken() async {
    authToken = await AuthService.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          widget.onImageTap();
        },
        child: CircleAvatar(
          child: widget.picture == null ? Icon(Icons.fastfood_outlined) : GetCachedNetworkImage(
            authToken: authToken,
            foodPicture: widget.picture,)
        ),
      ),
      title: Text(
        widget.name,
      ),
      trailing: Text(
        widget.calories + ' kcal',
      ),
    );
  }
}

class GetCachedNetworkImage extends StatelessWidget {
  final String foodPicture;
  final String authToken;
  final double dimensions;

  GetCachedNetworkImage({this.foodPicture, this.authToken, this.dimensions});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.d_45),
      child: CachedNetworkImage(
        imageUrl:
        '$backendUrl/food-diary/attachment?filename=$foodPicture',
        httpHeaders: {'Authorization': authToken},
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(value: downloadProgress.progress)),
        errorWidget: (context, url, error) => Icon(Icons.error),
        width: dimensions ?? Dimensions.d_35,
        height: dimensions ?? Dimensions.d_35,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}

