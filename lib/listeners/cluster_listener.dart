import 'package:yandex_maps_mapkit/mapkit.dart';
// import 'package:yandex_maps_mapkit/ui_view.dart';

final class ClusterListenerImpl implements ClusterListener {

  @override
  void onClusterAdded(Cluster cluster) {
    // cluster.appearance.setView(
    //   ViewProvider(builder: () => ClusterView()..setText("${cluster.placemarks.length}"))
    // );
  }
}