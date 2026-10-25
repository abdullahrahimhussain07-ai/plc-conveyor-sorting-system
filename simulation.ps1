<#
.SYNOPSIS
    Conveyor Sorting System FSM & Event Simulation
    Project 4: Industrial Automation (DecodeLabs)
#>

param(
    [int]$BatchPreset = 5
)

# Initialize System States
$global:CurrentState = "Idle"
$global:MotorActive = $false
$global:ItemCount = 0
$global:FaultDetected = $false

function Start-ConveyorSystem {
    param([bool]$StartPB, [bool]$StopPB, [bool]$EStopHealthy)
    
    # Transition Logic: Idle (S=1) to Running (S=2)
    if ($StartPB -and (-not $StopPB) -and $EStopHealthy -and (-not $global:FaultDetected)) {
        $global:CurrentState = "Running"
        $global:MotorActive = $true
        Write-Host "[STATE -> RUNNING] Motor energized (%Q1.0 = TRUE)." -ForegroundColor Green
    } else {
        Write-Host "[STATE -> IDLE] Waiting for valid start command..." -ForegroundColor DarkGray
    }
}

function Process-SortingZone {
    param([bool]$ProxSensor, [bool]$TallSensor)

    if ($global:CurrentState -eq "Running" -and $ProxSensor) {
        $global:CurrentState = "Sorting"
        Write-Host "[STATE -> SORTING] Box detected by proximity sensor (%I0.1)." -ForegroundColor Yellow
        
        # Simulate TON (On-Delay Timer) for 1.5s transit timing (d=0.75m, v=0.5m/s)
        Write-Host "[TIMER] Executing 1.5s transit delay (TON)..." -ForegroundColor Cyan
        Start-Sleep -Milliseconds 1500

        if ($TallSensor) {
            Write-Host "[ACTION] Tall box identified. Pneumatic pusher activated (%Q1.1 = TRUE)." -ForegroundColor Magenta
        } else {
            Write-Host "[ACTION] Standard box passed through." -ForegroundColor Blue
        }

        # Increment Batch Counter (CTU)
        $global:ItemCount++
        Write-Host "[COUNTER] Batch progress: $global:ItemCount / $BatchPreset items sorted." -ForegroundColor Green

        $global:CurrentState = "Running"
    }
}

function Trigger-EmergencyStop {
    $global:CurrentState = "Fault"
    $global:MotorActive = $false
    $global:FaultDetected = $true
    Write-Warning "[SAFETY FAULT] E-Stop triggered! Hardware safety relay cut power. Warning beacon active (%Q1.2 = TRUE)."
}

# --- Execution Simulation ---
Clear-Host
Write-Host "=== DECODELABS INDUSTRIAL AUTOMATION SIMULATION ===" -ForegroundColor Cyan

# 1. Start System
Start-ConveyorSystem -StartPB $true -StopPB $false -EStopHealthy $true

# 2. Simulate Box Detection & Sorting
Start-Sleep -Seconds 1
Process-SortingZone -ProxSensor $true -TallSensor $true

# 3. Simulate Emergency Stop Interlock
Start-Sleep -Seconds 1
Trigger-EmergencyStop
