# 🌤️ Climate Alert – Responsive Flutter Application

## 📌 Project Overview

**Climate Alert** is a responsive Flutter application designed to display real-time weather and climate information for different cities.

The application automatically rearranges its user interface based on the device orientation. In **portrait mode**, the information is arranged vertically for easy mobile viewing, while in **landscape mode**, the same information is rearranged horizontally to make better use of the available screen width.

The application fetches real-time weather information using the **Open-Meteo API**.

---

## 🎯 Problem Statement

> **Design a climate alert screen that rearranges its layout in portrait vs landscape.**

---

## 🎯 Objectives

The main objectives of this project are:

- To design a responsive user interface using Flutter.
- To understand portrait and landscape orientations.
- To implement different layouts for different screen orientations.
- To fetch real-time weather information from a REST API.
- To allow users to search for different cities.
- To display useful climate information in a clear and attractive interface.
- To provide climate alerts and safety recommendations.

---

## 🛠️ Technologies Used

- **Flutter**
- **Dart**
- **FlutLab.io**
- **Open-Meteo Weather API**
- **HTTP package**
- **Material Design**

---

## ✨ Features

### 🌍 City Search

Users can enter a city name and search for its current weather information.

### 🌡️ Real-Time Temperature

The application displays the current temperature and feels-like temperature for the selected city.

### 💧 Humidity

The current relative humidity is displayed in the weather information section.

### 💨 Wind Information

The application displays the current wind speed.

### ⚠️ Climate Alerts

The application generates alerts based on current weather conditions, such as:

- Extreme heat
- High temperature
- Rain
- Thunderstorms
- Normal weather conditions

### 🛡️ Safety Recommendations

The application provides simple safety recommendations based on weather conditions, such as staying hydrated, avoiding prolonged sunlight, and following weather warnings.

### 📱 Responsive Portrait Layout

In portrait orientation, the application arranges the weather information vertically to fit a mobile screen.

### 🖥️ Responsive Landscape Layout

In landscape orientation, the application rearranges the weather information horizontally and uses the available screen width efficiently.

---

## 📐 Responsive Design

The main purpose of this project is to demonstrate responsive UI design.

Flutter's `OrientationBuilder` is used to detect whether the device is in:

- **Portrait orientation**
- **Landscape orientation**

### Portrait

The information is arranged vertically:

```text
Header
   ↓
City Search
   ↓
Weather Card
   ↓
Climate Alert
   ↓
Humidity + Wind
   ↓
Safety Tips
```

### Landscape

The information is rearranged horizontally:

```text
Weather Card | Climate Information | Safety Tips
```

This allows the application to provide a better user experience on different screen orientations.

---

## 🔌 API Integration

The application uses the **Open-Meteo API** to obtain real-time weather information.

The application performs two main operations:

### 1. City Search

The city name entered by the user is sent to the Open-Meteo Geocoding API.

The API returns the geographical coordinates of the selected city.

### 2. Weather Request

The latitude and longitude are then used to request current weather information.

The application retrieves:

- Temperature
- Apparent temperature
- Humidity
- Wind speed
- Weather condition code

The received JSON data is decoded in Dart and displayed in the Flutter interface.

---

## 🧩 Flutter Concepts Used

This project demonstrates the following Flutter concepts:

- `MaterialApp`
- `Scaffold`
- `StatelessWidget`
- `StatefulWidget`
- `setState`
- `Container`
- `Row`
- `Column`
- `Expanded`
- `SingleChildScrollView`
- `TextField`
- `Icon`
- `OrientationBuilder`
- `BoxDecoration`
- `LinearGradient`
- Responsive UI
- REST API integration
- JSON parsing
- Error handling
- Loading indicators

---

## 📂 Project Structure

```text
lib/
│
└── main.dart
```

The main application logic and UI are implemented in `main.dart`.

---

## 🚀 How the Application Works

```text
Start Application
       ↓
Enter City Name
       ↓
Search City
       ↓
Get Latitude & Longitude
       ↓
Request Weather Data
       ↓
Receive JSON Response
       ↓
Display Weather Information
       ↓
Detect Device Orientation
       ↓
┌─────────────────┐
│                 │
Portrait       Landscape
│                 │
Vertical       Horizontal
Layout           Layout
└─────────────────┘
```

---

## 📸 Screenshots

### Portrait Mode

Add your portrait screenshot here:

```text
screenshots/portrait.png
```

Example Markdown:

```markdown
![Portrait Mode](screenshots/portrait.png)
```

### Landscape Mode

Add your landscape screenshot here:

```text
screenshots/landscape.png
```

Example Markdown:

```markdown
![Landscape Mode](screenshots/landscape.png)
```

### City Search

Add a screenshot showing a different city being searched:

```markdown
![City Search](screenshots/city-search.png)
```

---

## ▶️ Running the Project

The project was developed and tested using **FlutLab.io**.

### Steps

1. Open the project in FlutLab.io.
2. Make sure the dependencies are installed.
3. Run the Flutter application.
4. Enter a city name in the search field.
5. View the real-time weather information.
6. Test the application in portrait orientation.
7. Rotate the application to landscape orientation.
8. Observe how the layout rearranges automatically.

---

## 📦 Dependency

The project uses the Flutter HTTP package for API communication.

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.5.0
```

---

## 🌐 Weather API

This project uses **Open-Meteo** for weather and geocoding data.

The application does not require the user to manually enter an API key for this project.

---

## ✅ Expected Output

The final application should:

- Display real-time weather information.
- Allow users to search for different cities.
- Display temperature, humidity and wind information.
- Display appropriate weather alerts.
- Provide safety recommendations.
- Rearrange its layout when changing between portrait and landscape orientations.

---

## 🎓 Learning Outcomes

After completing this project, the following concepts were understood:

1. Creating responsive Flutter interfaces.
2. Working with portrait and landscape orientations.
3. Using `OrientationBuilder`.
4. Creating layouts using `Row`, `Column`, and `Expanded`.
5. Working with REST APIs.
6. Sending HTTP requests from Flutter.
7. Processing JSON responses.
8. Managing loading and error states.
9. Creating reusable UI components.
10. Designing a user-friendly Flutter application.

---

## 🏁 Conclusion

The **Climate Alert** application successfully demonstrates responsive UI design in Flutter. The application fetches real-time weather information for different cities and presents it using a clean and user-friendly interface.

The layout automatically changes between portrait and landscape orientations, demonstrating how Flutter can be used to build applications that adapt to different screen sizes and orientations.

---

## 👩‍💻 Project Information

**Subject:** Flutter / Mobile Application Development

**Project:** Climate Alert – Responsive UI

**Problem Statement:** Design a climate alert screen that rearranges its layout in portrait vs landscape.

**Development Platform:** FlutLab.io

**Framework:** Flutter

**Programming Language:** Dart
