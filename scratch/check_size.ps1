
Add-Type -AssemblyName System.Drawing
$imgPath = "C:\Users\Mahmoud\.gemini\antigravity\brain\bbc7423e-d7a0-4931-803f-6ca578e053a3\media__1776973636366.png"
$img = [System.Drawing.Image]::FromFile($imgPath)
Write-Host "SIZE: $($img.Width) x $($img.Height)"
$img.Dispose()
