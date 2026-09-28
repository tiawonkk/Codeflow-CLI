# ⚡ CodeFlow CLI 1.0

> Streamlined CLI workflow and rapid development automation for C, C++, Java, and Python on Windows PowerShell & VS Code.

CodeFlow CLI automates workflow setups for competitive programming, daily problem solving, and software development. It eliminates boilerplate repetition, automates compilation and execution, and provides seamless workspace navigation in Windows PowerShell. **Please note that this toolkit currently only works on Windows; support for macOS and Linux is actively under development.**

---

## ✨ Features

- **Interactive Directory Jump (`proj` / `p`)**:
  - Jump directly to target language directories with shorthand aliases (`p c`, `p cpp`, `p java`, `p py`).
  - Interactive numbered selection menu when executed without arguments.
- **Automated Boilerplate Generator (`code make <lang|file>`)**:
  - Automatically initializes ready-to-run template files.
  - Opens the parent workspace and target file directly inside VS Code.
  - Bypasses workspace trust confirmations (`--disable-workspace-trust`) so language extensions run immediately.
- **Universal Code Runner (`run code`)**:
  - Auto-detects standard entry point files (`main.c`, `main.cpp`, `Main.java`, `main.py`) in the working directory.
  - Handles GCC/G++ compilation to native `.exe` binaries and executes them immediately.
  - Executes Java (via single-file execution) and Python scripts on the fly.
- **Smart Session Management (`code exit`)**:
  - Gracefully terminates active VS Code editor instances while preserving the host terminal's working directory.

---

## 🛠️ Toolchain Prerequisites

Ensure the following compilers and runtimes are installed on your Windows machine:

| Language / Tool | Distribution | Installation Command (PowerShell Admin) |
| :--- | :--- | :--- |
| **C / C++** | GCC & G++ (WinLibs MinGW-w64) | `winget install BrechtSanders.WinLibs.POSIX.UCRT -e` |
| **Java** | Microsoft OpenJDK 21 LTS | `winget install Microsoft.OpenJDK.21 -e` |
| **Python** | Python 3.12+ | `winget install Python.Python.3.12 -e` |
| **Editor** | Visual Studio Code | `winget install Microsoft.VisualStudioCode -e` |

---

## 🚀 Installation

1. **Clone the repository:**
   ```powershell
   git clone [https://github.com/](https://github.com/)<username>/codeflow-cli.git
   cd codeflow-cli
   ```

2. **Run the installation script:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\install.ps1
   ```

3. **Reload your PowerShell profile:**
   ```powershell
   . $PROFILE
   ```
## 📖 Command Reference

1. **Workspace Navigation**
   ```powershell
    proj           # Displays interactive menu to navigate within D:\Project
    p c            # Direct jump to D:\Project\C
    p cpp          # Direct jump to D:\Project\C++
    p java         # Direct jump to D:\Project\Java
    p py           # Direct jump to D:\Project\Python
   ```

2. **Template Generation & Editor Launch**
   ```powershell
    code make c          # Creates main.c and opens folder & file in VS Code
    code make cpp        # Creates main.cpp and opens folder & file in VS Code
    code make java       # Creates Main.java and opens folder & file in VS Code
    code make py         # Creates main.py and opens folder & file in VS Code
    code make task1.cpp  # Creates custom file 'task1.cpp' with C++ template
   ```

3. **Compilation & Execution**
   ```powershell
    run code             # Auto-detects and runs the code file in the current directory
    run code file.cpp    # Compiles and runs a specific file
   ```

4. **Session Controls**
   ```powershell
    code exit            # Closes VS Code instance and preserves terminal location
    code --help          # Displays built-in CLI help reference
   ```

---

### Rincian Isi Tiap Template Kode (Code Templates)

#### 1. C Template (`main.c` / `*.c`)
Standard boilerplate featuring C99/C11 structure and basic standard I/O:
```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

#### 2. C++ Template (`main.cpp` / `*.cpp`)
Clean modern C++ starter with standard streams and common namespace inclusion:
```c++
#include <iostream>

using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    return 0;
}
```

#### 3. Java Template (`Main.java` / `*.java`)
Dynamically binds the public class identifier to the file's basename ($basename):
```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

#### 4. Python Template (`main.py` / `*.py`)
Standard Python architecture utilizing an isolated main() function entry point:
```python
def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
```