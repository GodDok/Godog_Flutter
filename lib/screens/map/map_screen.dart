import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:godog/models/map_model.dart';
import 'package:godog/screens/map/mapList_screen.dart';
import 'package:godog/screens/map/services/map_service.dart';
import 'package:godog/screens/map/storedetail_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final CameraPosition position = const CameraPosition(
      target: LatLng(35.15317903835004, 128.1059292602539), zoom: 17);

  late GoogleMapController mapController;
  final Dio dio = Dio(BaseOptions(
    baseUrl: "http://52.78.101.153:8080", // 여기서 기본 URL을 설정합니다.
  ));
  late MapService mapService;
  Set<Marker> markers = {};
  StoreModel? selectedStore;

  @override
  void initState() {
    super.initState();
    mapService = MapService(dio);
    _loadStoreData();
  }

  Future<void> _loadStoreData() async {
    try {
      List<StoreModel>? stores = await mapService.getMap();
      if (stores != null) {
        setState(() {
          markers = stores.map((store) {
            return Marker(
              markerId:
                  MarkerId(store.id?.toString() ?? UniqueKey().toString()),
              position: LatLng(
                  double.parse(store.latitude), double.parse(store.longitude)),
              infoWindow: InfoWindow(
                title: store.storeName,
                snippet: store.contents,
              ),
              onTap: () => _onMarkerTapped(store),
            );
          }).toSet();
        });
      }
    } catch (e) {
      // 에러 처리
      print('Error: $e');
    }
  }

  void _onMarkerTapped(StoreModel store) {
    setState(() {
      selectedStore = store;
    });
  }

  void _showFullScreenDetail() {
    if (selectedStore != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoreDetailScreen(store: selectedStore!),
        ),
      );
    }
  }

  void _hideBottomSheet() {
    setState(() {
      selectedStore = null;
    });
  }

  void _navigateToAnotherScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          "주변상가 찾기",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _navigateToAnotherScreen,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: position,
            markers: markers,
            onMapCreated: (controller) {
              mapController = controller;
            },
            onTap: (LatLng position) {
              _hideBottomSheet();
            },
          ),
          if (selectedStore != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    _showFullScreenDetail();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedStore!.storeName,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  selectedStore!.contents,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      "권리금/월세 : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        "${selectedStore!.deposit}/${selectedStore!.monthly}"),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      "입주가능일 : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(selectedStore!.joinDate),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          selectedStore!.pictureUrl != 'none' &&
                                  selectedStore!.pictureUrl.isNotEmpty
                              ? Image.network(
                                  selectedStore!.pictureUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.white,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
