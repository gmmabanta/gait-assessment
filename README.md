# Walk Assessment Application

This is an application to assess the walking abilities of Parkinson's Disease patients. It uses rhythmic auditory stimulation to guide PD patients to make big and loud steps. The application connects to a Bluetooth device to log training results.

Collaborators: Mae Mabanta and Stephen Destura

# Demo Preview

| Patient App Menu  | Therapist App Menu |
| ------------- | ------------- |
| <img src="/readme-images/Menu-Patient.jpg" width="200">  | <img src="/readme-images/Menu-Therapist.jpg" width="200">  |
| The Patient App is able to Start Training sessions with the use of Bluetooth and local audio files, View Schedules, and View Training Results.  | The Therapist App is able to Select Patients and View Schedule. By the Select Patient function, they can see all patients' training results and provide feedback per session.  |


# Table of Contents

- [Walk Assessment Application](#project-title)
- [Demo Preview](#demo-preview)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
- [Usage](#usage)
- [Development](#development)


# Installation

## File Installation
To use this project, first clone the repo on your device using the command below:

```git init```

```git clone https://github.com/gmmabanta/gait-assessment.git```

## App APK Installation
Install APK File to your phone ```/build/outputs/flutter-apk/app.apk```
### Android Limitations
Minimum requirement: ```Android v8.0 (Android Oreo)```

[(Back to top)](#table-of-contents)



# Usage

## Packages

Plugins are shown in pubspec.yaml file. A list of the plugins and their uses are summarized below:

| Plugin Name  | Description |
| ------------- | ------------- |
| [flutter_bluetooth_serial](https://pub.dev/packages/flutter_bluetooth_serial)  | Implementation of Bluetooth on the device  |
| [audioplayers](https://pub.dev/packages/audioplayers)  | Plays local audio files from the application  |
| [table_calendar](https://pub.dev/packages/table_calendar)  | Displays calendar widget with calendar-spcific buttons|
| [firebase_dynamic_links](https://pub.dev/packages?q=firebase_dynamic_links)  | Google Dynamic Links for Firebase, an app solution for creating and handling links across multiple platforms|
| [firebase_auth](https://pub.dev/packages/firebase_auth)  | Firebase authentication for signin and login with email and password |
| [firebase_core](https://pub.dev/packages/firebase_core)  | Utilizes Firebase Core API to use Firebase apps |
| [cloud_firestore](https://pub.dev/packages/cloud_firestore)  | Firestore for live synchronization and offline support on the app  |
| [date_time_format](https://pub.dev/packages/date_time_format) | Formatting date and time for uniform formatting|
| [syncfusion_flutter_gauges](https://pub.dev/packages/syncfusion_flutter_gauges) | Utilizes radial gauge for the progress bar of the training screen |
| [fl_chart](https://pub.dev/packages/fl_chart) | Displays bar chart and line chart to show results |
| [cupertino_icons](https://pub.dev/packages/cupertino_icons) | Fonts and icons assets for the app |


## Languages and Tools

<p align="left"> <a href="https://developer.android.com" target="_blank"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/android/android-original-wordmark.svg" alt="android" width="40" height="40"/> </a> <a href="https://firebase.google.com/" target="_blank"> <img src="https://www.vectorlogo.zone/logos/firebase/firebase-icon.svg" alt="firebase" width="40" height="40"/> </a> <a href="https://flutter.dev" target="_blank"> <img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" alt="flutter" width="40" height="40"/> </a> </p>

[(Back to top)](#table-of-contents)

<!-- This is optional and it is used to give the user info on how to use the project after installation. This could be added in the Installation section also. -->
