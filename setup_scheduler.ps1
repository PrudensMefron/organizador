# PowerShell Script to Setup Scheduled Task for File Organization
# Run this script as Administrator to create the scheduled task

# Define task parameters
$TaskName = "OrganizeDownloads"
$TaskDescription = "Automatically organizes files in Downloads folder by type every 15 minutes"
$ScriptPath = "D:\Marcelo\organize_downloads.bat"
$WorkingDirectory = "D:\Marcelo"

# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "This script requires Administrator privileges. Please run as Administrator." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

try {
    # Remove existing task if it exists
    $existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($existingTask) {
        Write-Host "Removing existing task..." -ForegroundColor Yellow
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    }

    # Create the action (what the task will do)
    $Action = New-ScheduledTaskAction -Execute $ScriptPath -WorkingDirectory $WorkingDirectory

    # Create the trigger (when the task will run - every 15 minutes)
    $Trigger = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 15) -RepetitionDuration ([TimeSpan]::MaxValue) -At (Get-Date) -Once

    # Create additional trigger for system startup (optional)
    $StartupTrigger = New-ScheduledTaskTrigger -AtStartup

    # Combine triggers
    $AllTriggers = @($Trigger, $StartupTrigger)

    # Create the settings
    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable:$false

    # Create the principal (run as current user)
    $Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive

    # Register the scheduled task
    Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $AllTriggers -Settings $Settings -Principal $Principal -Description $TaskDescription

    Write-Host ""
    Write-Host "SUCCESS: Scheduled task '$TaskName' has been created!" -ForegroundColor Green
    Write-Host "The task will:" -ForegroundColor Cyan
    Write-Host "  - Run every 15 minutes" -ForegroundColor White
    Write-Host "  - Run at system startup" -ForegroundColor White
    Write-Host "  - Organize files in D:\Downloads\" -ForegroundColor White
    Write-Host "  - Log activities to D:\Marcelo\organize_downloads.log" -ForegroundColor White
    Write-Host ""
    Write-Host "You can manage this task in:" -ForegroundColor Cyan
    Write-Host "  Task Scheduler > Task Scheduler Library > $TaskName" -ForegroundColor White
    Write-Host ""
    
    # Test the task
    Write-Host "Testing the task..." -ForegroundColor Yellow
    Start-ScheduledTask -TaskName $TaskName
    Start-Sleep -Seconds 3
    
    $TaskInfo = Get-ScheduledTask -TaskName $TaskName
    Write-Host "Task Status: $($TaskInfo.State)" -ForegroundColor Green
    
} catch {
    Write-Host "ERROR: Failed to create scheduled task." -ForegroundColor Red
    Write-Host "Error details: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "Press Enter to exit..."
Read-Host
