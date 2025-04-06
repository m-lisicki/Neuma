# Neuma

Neuma is a GUI tool built in SwiftUI for macOS that allows for efficient browsing and execution of Swift code. It offers a seamless, side-by-side experience between script editing and real-time output display.
<img width="1012" alt="Screenshot 2025-04-06 at 10 10 38 PM" src="https://github.com/user-attachments/assets/6453dd07-415d-410f-9fea-f0c2c118f28f" />

It supports the system's native handling of document selection with all the benefits associated with this along with support for multiple cards - each with a separate output view letting users to work on multiple scripts concurrently.

<img width="500" alt="Screenshot 2025-04-06 at 10 38 33 PM" src="https://github.com/user-attachments/assets/821941b8-d14c-4040-8fe5-57e4191a6a34" />
<img width="500" alt="Screenshot 2025-04-06 at 10 36 25 PM" src="https://github.com/user-attachments/assets/b3450e7d-c474-40e0-ab55-372d5573369c" />

The application supports highlighting of keywords in the system's accent colour, as well as an interactive error mode that takes you to the line where the error occurred. The set of highlighted keywords is configurable via the ```/Utilities/RegexKeywords.swift``` file, allowing for easy customization.

<img width="500" alt="Screenshot 2025-04-06 at 10 44 33 PM" src="https://github.com/user-attachments/assets/39a4e814-4f56-4e7c-89c3-1262f34ff6bc" />
<img width="500" alt="Screenshot 2025-04-06 at 10 45 34 PM" src="https://github.com/user-attachments/assets/ae774b56-2c00-48f0-88cb-61cdd702778b" />

The execution of the script can be stopped at any time, and a corresponding message to the user appears after execution with a non-zero error. The output is shown in real-time via pipe mechanism.

## Usage Instructions

Prerequisites: 
- Ensure you have Xcode installed on your macOS system.

Building the Project:
- Clone the repository or extract the Zip archive.
- Open the Neuma.xcodeproj file in Xcode.
- Build and run it!
