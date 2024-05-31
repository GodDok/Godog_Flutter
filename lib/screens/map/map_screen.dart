import 'package:flutter/material.dart';
import 'package:godog/widgets/home_widget/dragablebottomsheet.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late KakaoMapController mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    markers = <Marker>{};
  }

  @override
  Widget build(BuildContext context) {
    Clusterer? clusterer;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '주변 시세 확인',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          KakaoMap(
            onMapCreated: (controller) async {
              mapController = controller;

              addMarker(LatLng(35.16061854913234, 128.10958719332706));
              addMarker(LatLng(35.15679589403829, 128.10971087332288));
              addMarker(LatLng(35.15685563618948, 128.1071216769007));

              clusterer = Clusterer(
                markers: markers.toList(),
                minLevel: 6,
                gridSize: 45,
                calculator: [30, 60],
                texts: ['적음', '보통', '많음'],
                styles: [
                  ClustererStyle(
                    width: 50,
                    height: 50,
                    background: const Color.fromARGB(255, 212, 109, 210)
                        .withOpacity(0.8),
                    borderRadius: 25,
                    color: Colors.white,
                    textAlign: 'center',
                    lineHeight: 60,
                  ),
                ],
              );

              setState(() {});
            },
            markers: markers.toList(),
            clusterer: clusterer,
            center: LatLng(35.15963371161017, 128.10689592197392),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child:
                DraggableBottomSheet(), // 여기서는 DraggableBottomSheet 위젯이 정의되었어야 합니다.
          ),
        ],
      ),
    );
  }

  void addMarker(LatLng position) {
    Marker marker = Marker(
      markerId: UniqueKey().toString(), // Unique key for marker ID
      latLng: position,
    );
    markers.add(marker);
    setState(() {}); // 마커 추가 시 상태 갱신
  }
}
