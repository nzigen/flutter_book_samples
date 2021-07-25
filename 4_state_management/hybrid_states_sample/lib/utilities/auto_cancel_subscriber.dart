import 'dart:async';

import 'package:flutter/foundation.dart';

class AutoCancelSubscriber {
  final _subscriptions = <StreamSubscription>[];

  void addSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
  }
}

mixin AutoCancelSubscriberMixin on ChangeNotifier {
  final subscriber = AutoCancelSubscriber();

  @override
  void dispose() {
    subscriber.dispose();
    super.dispose();
  }
}
