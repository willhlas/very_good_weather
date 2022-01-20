import 'package:flutter/material.dart';

class WeatherStateWidget extends StatelessWidget {
  
  const WeatherStateWidget({
    Key? key,
    required this.message,
    this.isLoading = false,
  }): super(key: key);

  final String message;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.lerp(
        Alignment.topCenter,
        Alignment.center,
        isLoading ? 1 : 0.7,
      ),
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
          Visibility(
            visible: isLoading,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

}
