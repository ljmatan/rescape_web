import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rescape_web/data/cart/cart.dart';
import 'package:rescape_web/logic/api/models/specials_model.dart';
import 'package:rescape_web/logic/api/specials.dart';

class CustomerSpecialsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomerSpecialsPageState();
  }
}

class _CustomerSpecialsPageState extends State<CustomerSpecialsPage> {
  int? _maxExtent;
  Timer? _timer;

  int _currentPage = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SpecialsAPI.getAll().then((value) {
        if (mounted) {
          _maxExtent = value.length;
          void _setTimer() {
            _timer?.cancel();
            _timer = Timer.periodic(const Duration(seconds: 4), (_) {
              if (_currentPage < _maxExtent!)
                _pageController.nextPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease);
              else
                _pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease);
            });
          }

          _setTimer();

          Future.delayed(
            const Duration(milliseconds: 100),
            () => _pageController.addListener(
              () {
                final int _actualPage = _pageController.page!.round();
                if (_actualPage != _currentPage) {
                  _currentPage = _actualPage;
                  _setTimer();
                }
              },
            ),
          );
        }

        return value;
      }),
      builder: (context, AsyncSnapshot<List<SpecialsModel>> specials) =>
          specials.connectionState != ConnectionState.done ||
                  specials.hasError ||
                  specials.hasData && specials.data!.isEmpty
              ? Center(
                  child: specials.connectionState != ConnectionState.done
                      ? CircularProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            specials.hasError
                                ? specials.error.toString()
                                : 'Trenutno nema akcijskih ponuda.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                )
              : Stack(
                  children: [
                    PageView(
                      controller: _pageController,
                      children: [
                        for (var special in specials.data!)
                          Stack(
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(
                                      base64Decode(MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      896 &&
                                                  special.images
                                                      .where((e) =>
                                                          e['platform'] ==
                                                          'desktop')
                                                      .isNotEmpty ||
                                              special.images
                                                  .where((e) =>
                                                      e['platform'] == 'mobile')
                                                  .isEmpty
                                          ? special.images.firstWhere((e) =>
                                              e['platform'] ==
                                              'desktop')['imageBytes']
                                          : special.images.firstWhere((e) =>
                                              e['platform'] ==
                                              'mobile')['imageBytes']),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: SizedBox.expand(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Stack(
                                        children: [
                                          Text(
                                            special.description,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26,
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..color = Colors.black
                                                ..strokeWidth = 2,
                                            ),
                                          ),
                                          Text(
                                            special.description,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 26,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 16,
                                child: Center(
                                  child: StatefulBuilder(
                                    builder: (context, newState) => InkWell(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              60, 20, 60, 20),
                                          child: Text(
                                            CartItems.specials
                                                    .contains(special.code)
                                                ? 'UKLONI'
                                                : 'PORUČI',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () => newState(
                                        () => CartItems.specials
                                                .contains(special.code)
                                            ? CartItems.removeSpecial(
                                                special.code)
                                            : CartItems.addSpecial(
                                                special.code),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
