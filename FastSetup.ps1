#  New Setup (fast)

function Run-Step([string] $Description, [ScriptBlock]$script)
{
  Write-Host  -NoNewline "Loading " $Description.PadRight(20)
  & $script
  Write-Host "`u{2705}" # checkmark emoji
}

[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Write-Host "Loading PowerShell $($PSVersionTable.PSVersion)..." -ForegroundColor 3
Write-Host

# Takes about 760ms to load, setting up multithreaded job for this task(Importing Terminal Icons)
$vsshell1 = Start-ThreadJob {
  Import-Module -Name Terminal-Icons
}

# Importing Fuzzy Finder options
# $vsshell2 = Start-ThreadJob {
#   Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
# }

Run-Step "Importing z" {
  Import-Module z
}

Run-Step "Importing Prompt" {
  oh-my-posh init pwsh --config 'C:\Users\deepa\AppData\Local\Programs\oh-my-posh\themes\tokyonight_storm.omp.json' | Invoke-Expression
}

Run-Step "Choco Issues" {
  function clist { choco list }
}

Run-Step "PSReadLine setup" {
  Set-PSReadLineOption -PredictionSource History
  Set-PSReadLineOption -PredictionViewStyle ListView

  # Shows navigable menu of all options when hitting Tab
  Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

  # Autocompleteion for Arrow keys
  Set-PSReadLineOption -HistorySearchCursorMovesToEnd
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

  Set-PSReadLineOption -ShowToolTips
  Set-PSReadLineOption -PredictionSource History
}

Run-Step "Fuzzy Finder setup" {
 Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
}

Run-Step "Terminal Icons" {
  Receive-Job $vsshell1 -Wait -AutoRemoveJob
}
