import 'package:flutter/material.dart';

import 'package:my_mystery_city/views/cluster_view.dart';

import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/ui_view.dart';

final class ClusterListenerImpl implements ClusterListener {

  @override
  void onClusterAdded(Cluster cluster) {
    cluster.appearance.setView(ViewProvider(
      builder: () => ClusterView(count: cluster.placemarks.length, color: Color.fromRGBO(246, 135, 99, 1))));
  }
}