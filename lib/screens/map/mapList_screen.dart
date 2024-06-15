import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:godog/models/map_model.dart';
import 'package:godog/screens/map/services/map_service.dart';
import 'package:godog/screens/map/storedetail_screen.dart';

class MapListScreen extends StatefulWidget {
  const MapListScreen({super.key});

  @override
  _MapListScreenState createState() => _MapListScreenState();
}

class _MapListScreenState extends State<MapListScreen> {
  final Dio dio = Dio(BaseOptions(
    baseUrl: "http://52.78.101.153:8080", // 여기서 기본 URL을 설정합니다.
  ));
  late MapService mapService;
  List<StoreModel>? stores;
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    mapService = MapService(dio);
    _loadStoreData();
  }

  Future<void> _loadStoreData() async {
    try {
      List<StoreModel>? fetchedStores = await mapService.getMap();
      if (fetchedStores != null) {
        setState(() {
          stores = fetchedStores;
        });
      }
    } catch (e) {
      // 에러 처리
      print('Error: $e');
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 35,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const Text(
                '필터',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('권리금 낮은순'),
                onTap: () {
                  _applyFilter('deposit');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('월세 낮은순'),
                onTap: () {
                  _applyFilter('monthly');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('층수 낮은순'),
                onTap: () {
                  _applyFilter('floor');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20), // 하단에 흰 공간 추가
            ],
          ),
        );
      },
    );
  }

  void _applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'deposit') {
        stores!.sort((a, b) => int.parse(a.deposit.replaceAll(',', ''))
            .compareTo(int.parse(b.deposit.replaceAll(',', ''))));
      } else if (filter == 'monthly') {
        stores!.sort((a, b) => int.parse(a.monthly.replaceAll(',', ''))
            .compareTo(int.parse(b.monthly.replaceAll(',', ''))));
      } else if (filter == 'floor') {
        stores!.sort((a, b) {
          int aFloor = int.parse(a.floor.split('/')[0].replaceAll('층', ''));
          int bFloor = int.parse(b.floor.split('/')[0].replaceAll('층', ''));
          return aFloor.compareTo(bFloor);
        });
      }
    });
  }

  void _clearFilter() {
    setState(() {
      selectedFilter = null;
      _loadStoreData(); // 원래 데이터 순서로 복원
    });
  }

  void _navigateToStoreDetail(StoreModel store) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoreDetailScreen(store: store),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼을 없앱니다.
        title: const Text(
          "상가정보 목록",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: _showFilterBottomSheet,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.transparent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "필터",
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down,
                          color: Colors.black, size: 20),
                    ],
                  ),
                ),
                if (selectedFilter != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _clearFilter,
                    child: Chip(
                      label: Text(
                        "${_getFilterText(selectedFilter!)} x",
                        style: const TextStyle(color: Colors.red),
                      ),
                      backgroundColor: Colors.transparent,
                      shape: const StadiumBorder(
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: stores == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: stores!.length,
                    separatorBuilder: (context, index) =>
                        const Divider(thickness: 1),
                    itemBuilder: (context, index) {
                      final store = stores![index];
                      return InkWell(
                        onTap: () => _navigateToStoreDetail(store),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      store.storeName,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      store.contents,
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
                                            "${store.deposit}/${store.monthly}"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              store.pictureUrl != 'none' &&
                                      store.pictureUrl.isNotEmpty
                                  ? Image.network(
                                      store.pictureUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey,
                                      child:
                                          const Icon(Icons.image_not_supported),
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getFilterText(String filter) {
    switch (filter) {
      case 'deposit':
        return '권리금 낮은순';
      case 'monthly':
        return '월세 낮은순';
      case 'floor':
        return '층수 낮은순';
      default:
        return '';
    }
  }
}
