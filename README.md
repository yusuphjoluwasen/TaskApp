## TaskApp 🚀

### Overview  
The app lets users fetch a unique response code from a backend API and keep track of how many times data has been retrieved. It saves data to UserDefaults, to ensure it remains available even after restarting the app.

### Tech Stack 
The application is built using
- SwiftUI
- Swift
- Combine
- UserDefaults  
- XCTest
- iOS 16+
- Xcode 16.2  

### Project Structure  
- 📂 **App**: Contains high-level app setup files: it act as entry point and where dependencies are being composed 
- 📂 **Components**: Stores reusable UI components 
- 📂 **CoreModule**: Contains business logic, models, and core functionalities
- 📂 **Infrastructure**: Contains low-level external system-related components such as networking and storagemanager  

## Running the Project  

### 📌 Steps  
Clone the repository:  
   ```sh
   git clone https://github.com/yusuphjoluwasen/TaskApp.git
   cd TaskApp

Note: Ensure server is running on http://localhost:8000

