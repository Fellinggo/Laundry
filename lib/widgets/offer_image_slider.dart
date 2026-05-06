import 'dart:async';
import 'package:flutter/material.dart';

class OfferImageAutoSlider extends StatefulWidget {
  const OfferImageAutoSlider({super.key, required this.onTap});

  final ValueChanged<int> onTap;

  @override
  State<OfferImageAutoSlider> createState() => _OfferImageAutoSliderState();
}

class _OfferImageAutoSliderState extends State<OfferImageAutoSlider> {
  final PageController _controller = PageController();
  Timer? _timer;
  int _index = 0;

  final List<String> _images = const [
    'assets/images/promos.png',
    'assets/images/paydays.png',
    'assets/images/bedcoverss.png',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _index = (_index + 1) % _images.length;
      _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: PageView.builder(
        controller: _controller,
        itemCount: _images.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => widget.onTap(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(_images[i], fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }
}
