# TaskApp - SwiftUI & Combine-Based API Fetching App 🚀

## Overview  
TaskApp is a lightweight SwiftUI application that demonstrates fetching and displaying data using **Combine** and **SwiftUI**. The app allows users to retrieve a **unique response code** from a backend API while tracking the number of times data has been fetched. It also ensures persistence using **UserDefaults**, maintaining the data across app restarts.

## Key Features  
✅ Fetches a **response code** dynamically from an API  
✅ Displays the **number of times data has been fetched**  
✅ Uses **Combine** for reactive API handling  
✅ Implements **Dependency Injection** for better testability  
✅ Stores fetched data using **UserDefaults** for persistence  
✅ Includes **unit tests** with **mock network responses**  

## Tech Stack  
- **SwiftUI** – For a declarative UI experience  
- **Combine** – For reactive programming and state management  
- **UserDefaults** – For lightweight data persistence  
- **XCTest** – For unit testing with **mock network calls**  
- **Dependency Injection** – For modular and testable code  

## Project Structure  
📂 **View** – SwiftUI Views (`TaskView`, `TaskItemView`, `TaskButtonView`)  
📂 **ViewModel** – Handles API calls and state updates (`TaskViewModel`)  
📂 **Model** – Defines data structures (`NextPathModel`, `ResponseCodeModel`)  
📂 **Repository** – Manages API interactions (`TaskRepository`)  
📂 **Networking** – Handles network requests (`Network`, `MockNetwork`)  
📂 **Storage** – Manages data persistence (`StorageManager`)  

## How It Works  
1. Tap the **"Fetch"** button to request a **new response code** from the server.  
2. The app retrieves the correct API endpoint and fetches the **response code**.  
3. The **fetch count** increments, and data is **persisted locally**.  
4. The UI updates **automatically** using **SwiftUI & Combine**.  

## Running the Project  

### 📌 Prerequisites  
- **Xcode 15+**  
- **Swift 5.8+**  
- **macOS 13+**  

### 📌 Steps  
1. Clone the repository:  
   ```sh
   git clone https://github.com/your-username/TaskApp.git
   cd TaskApp

