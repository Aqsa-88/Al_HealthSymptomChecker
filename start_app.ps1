$env:PUB_CACHE = "e:\Program Files\HealthSymptomChecker\Frontend\.pub-cache"
$host.ui.RawUI.WindowTitle = "Health Symptom Checker Launcher"

Write-Host "Starting Health Symptom Checker System..." -ForegroundColor Cyan

# 1. Start AI Engine (Python)
Write-Host "1. Launching AI Engine (Port 8000)..." -ForegroundColor Yellow
Start-Process -FilePath "python" -ArgumentList "app.py" -WorkingDirectory "e:\Program Files\HealthSymptomChecker\AI_Engine" -WindowStyle Minimized

# 2. Start Backend API (.NET)
Write-Host "2. Launching Backend API (Port varying, usually 5000/5001)..." -ForegroundColor Yellow
Start-Process -FilePath "dotnet" -ArgumentList "run" -WorkingDirectory "e:\Program Files\HealthSymptomChecker\Backend\HealthSymptomChecker.API" -WindowStyle Minimized

# Wait a moment for services to spin up
Write-Host "Waiting 5 seconds for services to initialize..." -ForegroundColor Gray
Start-Sleep -Seconds 5

# 3. Start Frontend (Flutter)
Write-Host "3. Launching Frontend (Windows Desktop)..." -ForegroundColor Green
Start-Process -FilePath "flutter" -ArgumentList "run -d windows" -WorkingDirectory "e:\Program Files\HealthSymptomChecker\Frontend"

Write-Host "System Running! All components launched in separate windows." -ForegroundColor Cyan
