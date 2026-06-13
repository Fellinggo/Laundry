class MainShellState {
  final int selectedIndex;
  final bool isLoggedIn;
  final String? userFirstName;

  MainShellState({
    required this.selectedIndex,
    required this.isLoggedIn,
    this.userFirstName,
  });

  MainShellState copyWith({
    int? selectedIndex,
    bool? isLoggedIn,
    String? userFirstName,
  }) {
    return MainShellState(
      selectedIndex:
          selectedIndex ??
          this.selectedIndex,
      isLoggedIn:
          isLoggedIn ??
          this.isLoggedIn,
      userFirstName:
          userFirstName ??
          this.userFirstName,
    );
  }
}

class NavigationTarget {
  static const int home = 0;
  static const int myOrders = 1;
  static const int services = 2;
  static const int offers = 3;
  static const int profile = 4;
}

class ScreenConfig {
  final int index;
  final String routeName;
  final String title;

  const ScreenConfig({
    required this.index,
    required this.routeName,
    required this.title,
  });

  static const List<
    ScreenConfig
  >
  screens = [
    ScreenConfig(
      index: NavigationTarget.home,
      routeName: '/home',
      title: 'Beranda',
    ),
    ScreenConfig(
      index: NavigationTarget.myOrders,
      routeName: '/my-orders',
      title: 'Pesanan Saya',
    ),
    ScreenConfig(
      index: NavigationTarget.services,
      routeName: '/services',
      title: 'Layanan',
    ),
    ScreenConfig(
      index: NavigationTarget.offers,
      routeName: '/offers',
      title: 'Penawaran',
    ),
    ScreenConfig(
      index: NavigationTarget.profile,
      routeName: '/profile',
      title: 'Profil',
    ),
  ];

  static ScreenConfig? fromIndex(
    int index,
  ) {
    try {
      return screens.firstWhere(
        (
          screen,
        ) =>
            screen.index ==
            index,
      );
    } catch (
      e
    ) {
      return null;
    }
  }
}
