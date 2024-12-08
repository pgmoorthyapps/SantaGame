# Secret Santa Game in Dart

## Overview

The program automates the process of
assigning secret children to employees based on the provided employee information.

## Requirements

- Dart SDK Or Please try in https://dartpad.dev/
- CSV files for employee data and previous year’s assignments

## How to Use

1.  Place `Employee-List.xlsx` and `Secret-Santa-Game-Result-2023.xlsx` in the root directory.
2.  Set Up VS Code to Run the Program
    Add the following configuration to .vscode/launch.json (create the file if it doesn’t exist):
    ```json
    {
        "version": "0.2.0",
        "configurations": [
            {
                "name": "Dart & Flutter",
                "request": "launch",
                "type": "dart",
                "program": "main.dart"

            }
        ]
    }

3.  Run the program:
        Press F5 in VS Code to run the program.
        Alternatively, in the terminal, use:
            dart run lib/main.dart
4.  Test the program:
        In Terminial copy & paste the command dart test test/test_main.dart
