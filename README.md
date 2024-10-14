# DinLipi: A Personal Organization App
## Overview
DinLipi is an iOS application designed to simplify personal organization by combining several key features such as calendar management, weather updates, to-do lists, note-taking, and memory storage into one unified app. It is an intuitive, easy-to-use application aimed at helping users manage events, tasks, and memories efficiently.

## Features
**Calendar Management:** Schedule events and manage priorities.
**Weather Updates:** Integrates real-time weather updates with a visually appealing UI.
**To-Do Lists:** Create and track tasks with daily progress updates.
**Note-Taking:** Add, save, and delete notes easily.
**Memory Storage:** Save memories with a scrapbook-like interface and view memories with the "on this day" feature.
## Project Objectives
1.Provide a user-friendly interface for organizing daily activities.
2.Prioritize events and tasks with visual cues.
3.Display weather conditions based on current location and time of day.
4.Track progress on to-do lists, allowing users to see completed tasks.
5.Store and showcase memories, with special emphasis on memories from past events occurring on the same day in previous years.
Technologies Used

**Programming Language:** Python for early prototypes; Swift for the iOS app.
**IDE:** Xcode for Swift and iOS development.
**Backend:** Firebase Database for storing user data.
**APIs:** Weather data is fetched using the WeatherAPI.
Methodology

## Major components
**CalendarManager:** Manages event creation, scheduling, and prioritization of events.
**WeatherAPI Integration:** Fetches real-time weather data and displays it dynamically within the app.
**NoteManager:** Allows users to create, save, edit, and delete notes.
**ToDoListManager:** Manages task creation and tracks the completion of tasks with progress indicators.
**MemoryManager:** Stores memories and retrieves them, along with an "on this day" feature for reminiscing past events.

## Project Flow
The app follows a structured approach, breaking down tasks into categories such as events, tasks, notes, and memories. Each section has its own class and structure, handling specific tasks to ensure smooth operations.

## Data Structures
The app uses multiple custom data structures. Below is a sample of the data format used:
```swift
struct CurrentData: Codable {
    let last_updated: String
    let temp_c: Float
    let wind_kph: Float
    let humidity: Int
    let is_day: Int
    let feelslike_c: Decimal
    let pressure_in: Decimal
    let precip_in: Decimal
    let cloud: Int
    let uv: Decimal
}
```
## Functionality Showcase
**Splash Screen and Login:** Basic functionality including splash screen, user registration, and login system.
**Calendar & Events:** Users can view the calendar, add events with different priority levels (high, medium, low), and view scheduled events.
**Weather Integration:** Fetches current weather conditions and adjusts the UI dynamically based on the weather.
**To-Do List:** Users can add tasks, mark them as complete or incomplete, and track their daily progress.
**Memories:** Users can add memories and view them in a scrapbook-like interface. The "on this day" feature brings up memories from the same day in previous years.
**Notes:** Users can add, edit, delete, and view notes.

## User Interface Highlights
**Calendar:** Displays the current day and lets users add events, using color codes for priority levels.
**Weather Page:** Fetches and displays weather information in real-time, changing icons and colors based on conditions like time of day and UV index.
**To-Do List:** Displays tasks with progress tracking and allows users to mark tasks as complete or incomplete.
**Memories:** Stores and displays memories with a scrollable interface.

## Challenges and Solutions
**JSON Parsing:** The app uses JSON to parse weather data fetched from the WeatherAPI and displays it in real-time.
**Dynamic UI Updates:** The app changes colors and icons based on real-time weather data, making the interface interactive and informative.
**Firebase Integration:** Each user's data, including tasks, notes, and memories, is securely stored in the Firebase database, allowing users to retrieve their data seamlessly.

## Future Work
1.Enhance user experience with more refined UI and additional weather information.
2.Implement push notifications for task reminders and weather updates.
3.Expand the app to other platforms like Android for broader accessibility.
