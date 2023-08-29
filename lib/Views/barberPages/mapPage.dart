import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hair_and_more/controllers/authProv.dart';
import 'package:hair_and_more/widgets/appButton.dart';
import 'package:hair_and_more/widgets/submitDialog.dart';
import 'package:map_picker/map_picker.dart';

class MapPage extends StatelessWidget {
  double ?latitude;
  double ?longitude;

  MapPage({super.key, this.latitude, this.longitude});

  final _controller = Completer<GoogleMapController>();

  MapPickerController mapPickerController = MapPickerController();



  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(latitude!);
    print(longitude!);
    CameraPosition cameraPosition =  CameraPosition(
      target: LatLng(latitude!, longitude!),
      zoom: 14.4746,
    );
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            MapPicker(
              iconWidget: const Icon(
                Icons.location_on,
                size: 40,
                color: Colors.red,
              ),
              //add map picker controller
              mapPickerController: mapPickerController,
              child: GoogleMap(
                myLocationEnabled: true,

                zoomControlsEnabled: true,
                // hide location button
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                //  camera position
                initialCameraPosition: cameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                   controller.moveCamera(CameraUpdate.newLatLng(LatLng(latitude!, longitude!)));

                },
                onCameraMoveStarted: () {
                  // notify map is moving
                  // mapPickerController.mapMoving!();
                  textController.text = "checking ...";
                },
                onCameraMove: (Position) {
                  cameraPosition = Position;
                },
                onCameraIdle: () async {
                  textController.text = "";
                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 20,
              width: MediaQuery.of(context).size.width - 50,
              height: 50,
              child: TextFormField(
                maxLines: 3,
                textAlign: TextAlign.center,
                readOnly: true,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero, border: InputBorder.none),
                controller: textController,
              ),
            ),
            const Positioned(
                top: 20,
                left: 10,
                child: Text('Please add your location',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
            Positioned(
              bottom: 24,
              left: 24,
              right: 60,
              child: AppButton(text: 'Confirm',onPressed: () async {
                print(cameraPosition.target.latitude);
                print(cameraPosition.target.longitude);
                var ok = await alertDialogSubmit(context, 'are you sure to set this location');
                if(ok is bool && ok)
                  {
                     AuthProv.putBarberLocation(context,cameraPosition.target.latitude,cameraPosition.target.longitude);
                  }
              },
              )
            )
          ],
        ),
      ),
    );
  }
}
