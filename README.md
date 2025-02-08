## TaskApp 🚀

### Overview  
The app allows users to retrieve a **unique response code** from a backend API while tracking the number of times data has been fetched. It also ensures persistence using **UserDefaults**, maintaining the data across app restarts. 

### Tech Stack  
- SwiftUI  
- Combine
- UserDefaults  
- XCTest  
- Dependency Injection

### Project Structure  
📂 **View** – SwiftUI Views (`TaskView`, `TaskItemView`, `TaskButtonView`)  
📂 **ViewModel** – Handles API calls and state updates (`TaskViewModel`)  
📂 **Model** – Defines data structures (`NextPathModel`, `ResponseCodeModel`)  
📂 **Repository** – Manages API interactions (`TaskRepository`)  
📂 **Networking** – Handles network requests (`Network`, `MockNetwork`)  
📂 **Storage** – Manages data persistence (`StorageManager`)  

## Running the Project  

### 📌 Prerequisites  
- **Xcode 15+**  
- **Swift 5.8+**
- **ioS 18+**  
- **macOS 13+**  

### 📌 Steps  
1. Clone the repository:  
   ```sh
   git clone https://github.com/yusuphjoluwasen/TaskApp.git
   cd TaskApp

