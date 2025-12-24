# FaceRecognition-Flutter
## Overview

This repository demonstrates both `face liveness detectio`n and `face recognition` technology for `Flutter` on `Android` and `iOS` platforms.

> In this repository, we integrated `face liveness detection` and `face recognition` technology into this `Flutter` project for both `Android` and `iOS`.</br>

## SDK License

This repo integrated `face recognition SDK`, which requires a license for each `application ID`.</br>
- The code below shows how to use the license: /lib/main.dart

## How To Run
### 1. Flutter Setup
  Make sure you have `Flutter` installed. </br>
  We have tested the project with `Flutter` version `3.29.2`.</br> 
  If you don't have `Flutter` installed, please follow the instructions provided in the official `Flutter` documentation [here](https://docs.flutter.dev/get-started/install).</br>
### 2. Running the App
  Run the following commands:
  
  ```bash
  flutter clean
  flutter pub get
  flutter run
  ```  
  If you plan to run the `iOS` app, please refer to the following [link](https://docs.flutter.dev/deployment/ios) for detailed instructions.</br>
### 3. Building the APK for Release
  To create a release `APK`, configure `ProGuard` as described in this file: /android/app/proguard-rules.pro 
  
## About SDK
### 1. Setup
### 1.1 Setting Up Face SDK library
  > Android

  - Copy the `Face SDK` library(folder `libfacesdk`) to the folder `android` in your project.</br>
  - Add `Face SDK` library to the project in `settings.gradle` in the folder `android` in your project.
  ```dart
  include ':libfacesdk'
  ```
### 1.2 Setting Up Fotoapparat library
  > Android

  - Copy `Fotoapparat` library (folder `libfotoapparat`) to the folder `android` in your project.</br>
  - Add  `Fotoapparat` library to the project in `settings.gradle` in the folder `android` in your project.
  ```dart
  include ':libfotoapparat'
  ```
#### 1.3 Setting Up Face SDK Plugin
  - Copy the folder `facesdk_plugin` to the root folder of your project.</br>
  - Add the dependency in your `pubspec.yaml` file.
  ```dart
    facesdk_plugin:
      path: ./facesdk_plugin
  ```
  - Import the `facesdk_plugin` package.
  ```dart
    import 'package:facesdk_plugin/facesdk_plugin.dart';
    import 'package:facesdk_plugin/facedetection_interface.dart';
  ```
### 2 API Usages
#### 2.1 Facesdk Plugin
  - Activate the `FacesdkPlugin` by calling the `setActivation` method:
  ```dart
    final _facesdkPlugin = FacesdkPlugin();
    ...
    await _facesdkPlugin
            .setActivation(
                "Os8QQO1k4+7MpzJ00bVHLv3UENK8YEB04ohoJsU29wwW1u4fBzrpF6MYoqxpxXw9m5LGd0fKsuiK"
                "fETuwulmSR/gzdSndn8M/XrEMXnOtUs1W+XmB1SfKlNUkjUApax82KztTASiMsRyJ635xj8C6oE1"
                "gzCe9fN0CT1ysqCQuD3fA66HPZ/Dhpae2GdKIZtZVOK8mXzuWvhnNOPb1lRLg4K1IL95djy0PKTh"
                "BNPKNpI6nfDMnzcbpw0612xwHO3YKKvR7B9iqRbalL0jLblDsmnOqV7u1glLvAfSCL7F5G1grwxL"
                "Yo1VrNPVGDWA/Qj6Z2tPC0ENQaB4u/vXAS0ipg==")
            .then((value) => facepluginState = value ?? -1);  
  ```
  - Initialize the `FacesdkPlugin`:
  ```dart
  await _facesdkPlugin
            .init()
            .then((value) => facepluginState = value ?? -1)
  ```
  - Set parameters using the `setParam` method:
  ```dart
  await _facesdkPlugin
          .setParam({'check_liveness_level': livenessLevel ?? 0})
  ```
  - Extract faces using the `extractFaces` method:
  ```dart
  final faces = await _facesdkPlugin.extractFaces(image.path)
  ```
  - Calculate the similarity between faces using the `similarityCalculation` method:
  ```dart
  double similarity = await _facesdkPlugin.similarityCalculation(
                face['templates'], person.templates) ??
            -1;
  ```
#### 2.2 FaceDetectionInterface
  To build the native camera screen and process face detection, please refer to the [lib/facedetectionview.dart] file in the repository. 
  
  This file contains the necessary code for implementing the camera screen and performing face detection.
  
