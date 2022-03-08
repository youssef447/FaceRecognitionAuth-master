import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class CameraService {
  //uses the actual camera u want to use from the list
  CameraController _cameraController;
  CameraController get cameraController => this._cameraController;

  InputImageRotation _cameraRotation;
  InputImageRotation get cameraRotation => this._cameraRotation;

  String _imagePath;
  String get imagePath => this._imagePath;
  

  Future<void> initialize() async {
    if (this._cameraController != null) return;
    CameraDescription description = await _getCameraDescription();
    await _setupCameraController(description: description);
    this._cameraRotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );
  }
//##############first
  Future<CameraDescription> _getCameraDescription() async {
    List<CameraDescription> cameras = await availableCameras();
    return cameras.firstWhere((CameraDescription camera) =>
        camera.lensDirection == CameraLensDirection.front);
  }
//##############second
  Future _setupCameraController({
    @required CameraDescription description,
  }) async {
    this._cameraController = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await this._cameraController.initialize();
  }

  InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.Rotation_90deg;
      case 180:
        return InputImageRotation.Rotation_180deg;
      case 270:
        return InputImageRotation.Rotation_270deg;
      default:
        return InputImageRotation.Rotation_0deg;
    }
  }

  Future<XFile> takePicture() async {
    await _cameraController.stopImageStream();
    XFile file = await _cameraController.takePicture();
    this._imagePath = file.path;
    return file;
  }

  Size getImageSize() {
    assert(_cameraController != null, 'Camera controller not initialized');
    return Size(
      _cameraController.value.previewSize.height,
      _cameraController.value.previewSize.width,
    );
  }

  dispose() async {
    await this._cameraController.dispose();
    this._cameraController = null;
  
  }
}
