# Health Symptom Checker (AI-Assisted)

This project contains an ASP.NET Core Web API backend and a Python FastAPI AI Engine.

## Prerequisites
1.  **Likely already installed**: .NET SDK 8.0+, Python 3.9+, SQL Server (LocalDB or full instance).
2.  **Tools**: `dotnet-ef` global tool (attempted installation during setup).

## How to Run
We have provided a PowerShell script to launch both services easily.

1.  Open a terminal in `HealthSymptomChecker` directory.
2.  Run:
    ```powershell
    .\run.ps1
    ```
    *This will open two new command windows: one for the Backend and one for the AI Engine.*

## Manual Step-by-Step
If the script doesn't work, run them manually:

### 1. AI Engine (Python)
```bash
cd AI_Engine
# Create/Activate venv if needed
venv\Scripts\activate
pip install -r requirements.txt
python main.py
```
*Runs on `http://127.0.0.1:8000`*

### 2. Backend (ASP.NET Core)
```bash
cd Backend\HealthSymptomChecker.API
# Update database if needed
dotnet ef database update
dotnet run
```
*Runs on `https://localhost:7194` (or similar port)*

## Usage
1.  Go to the Backend Swagger UI: `https://localhost:7194/swagger`
2.  **Register** a new user via `POST /api/Auth/register`.
3.  **Login** via `POST /api/Auth/login` to get a JWT Token.
4.  **Authorize**: Click the "Authorize" button in Swagger and enter `Bearer <your_token>`.
5.  **Assess**: Use `POST /api/Assessment` with a list of symptoms (e.g., `["headache", "fever"]`).

## Project Structure
*   `Backend/`: ASP.NET Core Web API, SQL Server, Entity Framework Core.
*   `AI_Engine/`: Python FastAPI, Rule-Based Logic + Mock ML.
