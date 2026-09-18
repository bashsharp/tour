# bashy rebuilds itself on Windows with no git, no Go, no C compiler on the host.
$ErrorActionPreference = "Continue"
$env:BASHY_TELEMETRY_QUIET = "1"; $env:BASHY_HINTS = "off"
function Say($s) { Write-Host "PS> $s" -ForegroundColor Green; Start-Sleep -Milliseconds 1200 }
$w = "C:\demo"
if (Test-Path $w) { Remove-Item -Recurse -Force $w }
New-Item -ItemType Directory -Force -Path $w | Out-Null
Set-Location $w
Say 'where.exe git; where.exe go; where.exe cl    # a stock Windows box: none'
cmd /c "where git 2>&1"; cmd /c "where go 2>&1"; cmd /c "where cl 2>&1"; Start-Sleep 2
Say 'curl.exe -fsSLO https://github.com/qiangli/bashy/releases/latest/download/bashy-windows-amd64.zip'
curl.exe -fsSLO https://github.com/qiangli/bashy/releases/latest/download/bashy-windows-amd64.zip
Say 'tar.exe -xf bashy-windows-amd64.zip; $env:PATH = "$PWD;$env:PATH"'
tar.exe -xf bashy-windows-amd64.zip; $env:PATH = "$PWD;$env:PATH"
Say 'bashy --version'
cmd /c "bashy --version 2>&1"; Start-Sleep 2
Say 'bashy git clone https://github.com/qiangli/bashy   # via a pinned MinGit'
cmd /c "bashy git clone https://github.com/qiangli/bashy 2>&1" | Select-Object -Last 6
Say 'cd bashy; bashy scripts/bootstrap-siblings.sh   # siblings at pinned SHAs'
Set-Location bashy
cmd /c "bashy scripts/bootstrap-siblings.sh 2>&1" | Select-Object -Last 10
Say 'bashy dag build          # bashy go provisions its own Go toolchain'
cmd /c "bashy dag build 2>&1" | Select-Object -Last 12
Say 'bin\bashy.exe --version  # the bashy this bashy just built'
cmd /c ".\bin\bashy.exe --version 2>&1"
Start-Sleep 4
