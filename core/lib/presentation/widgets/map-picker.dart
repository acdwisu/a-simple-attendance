import 'package:core/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class MapPicker extends StatefulWidget {
  final LatLng? initialValue;
  final void Function(LatLng coordinate)? onPicked;
  final Stream<double>? radiusStream;

  const MapPicker({
    Key? key,
    this.initialValue,
    this.onPicked,
    this.radiusStream,
  }) : super(key: key);

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  LatLng? _coord;
  final _mapController = MapController();

  @override
  void initState() {
    super.initState();

    _coord = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 150,
          child: FlutterMap(
            options: MapOptions(
              center: _coord ??
                (positionStream.hasValue? LatLng(positionStream.value.latitude, positionStream.value.longitude)
                    : null),
              allowPanning: false,
              allowPanningOnScrollingParent: false,
              zoom: 16,
              controller: _mapController,
            ),
            mapController: _mapController,
            nonRotatedChildren: [
              if(widget.onPicked!=null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: TextButton(
                    onPressed: () {
                      showDialog<PickedData>(
                          context: context,
                          builder: (context) => Dialog(
                            child: FlutterLocationPicker(
                                initPosition: LatLong(23, 89),
                                initZoom: 16,
                                minZoomLevel: 10,
                                maxZoomLevel: 18,
                                trackMyPosition: true,
                                onPicked: (pickedData) {
                                  Navigator.of(context).pop(pickedData);
                                }),
                          )
                      ).then((value) {
                        if(value != null) {
                          _coord = LatLng(
                            value.latLong.latitude,
                            value.latLong.longitude,
                          );

                          widget.onPicked!(_coord!);

                          _mapController.move(_coord!, 17);

                          if(mounted) {
                            setState(() {});
                          }
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        primary: Colors.white
                    ),
                    child: const Text(
                      'Pick Location',
                    ),
                  ),
                ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Card(
                  child: Text(
                    _coord!=null? "${_coord!.latitude},"
                        "\n${_coord!.longitude}" : 'Location not setted'
                  ),
                ),
              ),
            ],
            children: [
              TileLayerWidget(
                options: TileLayerOptions(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
              ),
              if(_coord != null)
                ...[
                  MarkerLayerWidget(
                    options: MarkerLayerOptions(
                        markers: [
                          Marker(point: _coord!, builder: (context) {
                            return const Icon(
                              Icons.pin_drop,
                              size: 40,
                            );
                          })
                        ]
                    ),
                  ),
                  if(widget.radiusStream!=null)
                    StreamBuilder<double>(
                      stream: widget.radiusStream,
                      builder: (context, snapshot) {
                        if(!snapshot.hasData) {
                          return Container();
                        }

                        return CircleLayerWidget(
                          options: CircleLayerOptions(
                            circles: [
                              CircleMarker(
                                point: _coord!,
                                radius: snapshot.data!,
                                useRadiusInMeter: true,
                                color: Colors.green.withOpacity(0.3)
                              ),
                            ]
                          ),
                        );
                      }
                    )
                ]
            ],
          ),
        ),
      ],
    );
  }
}
