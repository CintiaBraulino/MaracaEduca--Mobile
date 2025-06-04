import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:school_map_app/providers/school_provider.dart';
import 'package:school_map_app/models/school.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map-screen';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};

  // Posição inicial do mapa (ex: centro do Brasil)
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(-14.2350, -51.9253), // Coordenadas aproximadas do centro do Brasil
    zoom: 4.0,
  );

  @override
  void initState() {
    super.initState();
    // Adiciona um listener para atualizar os marcadores quando as escolas mudam
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addSchoolMarkers();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addSchoolMarkers();
  }

  void _addSchoolMarkers() {
    final schoolProvider = Provider.of<SchoolProvider>(context, listen: false);
    setState(() {
      _markers.clear();
      for (var school in schoolProvider.schools) {
        _markers.add(
          Marker(
            markerId: MarkerId(school.id!),
            position: LatLng(school.latitude, school.longitude),
            infoWindow: InfoWindow(
              title: school.name,
              snippet: school.address,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escuta mudanças nas escolas para atualizar os marcadores
    Provider.of<SchoolProvider>(context).schools; // Apenas para rebuildar quando as escolas mudam
    _addSchoolMarkers(); // Chama para garantir que os marcadores são atualizados

    return Scaffold(
      appBar: AppBar(
        title: const Text('Localização das Escolas'),
        centerTitle: true,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _initialCameraPosition,
        markers: _markers,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: true,
      ),
    );
  }
}