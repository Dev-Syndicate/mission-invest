import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppLoading extends StatelessWidget {
  final double? height;
  final double? width;

  const AppLoading({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height ?? 48,
        width: width ?? 48,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.height = 80,
    this.width = double.infinity,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surface,
      highlightColor:
          Theme.of(context).colorScheme.onSurface.withAlpha(25),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
