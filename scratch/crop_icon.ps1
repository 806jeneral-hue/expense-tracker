
Add-Type -AssemblyName System.Drawing
$imgPath = "C:\Users\Mahmoud\.gemini\antigravity\brain\bbc7423e-d7a0-4931-803f-6ca578e053a3\media__1776973636366.png"
$img = [System.Drawing.Image]::FromFile($imgPath)
$cropRect = New-Object System.Drawing.Rectangle(25, 125, 205, 205)
$target = New-Object System.Drawing.Bitmap($cropRect.Width, $cropRect.Height)
$g = [System.Drawing.Graphics]::FromImage($target)
$g.DrawImage($img, (New-Object System.Drawing.Rectangle(0, 0, $target.Width, $target.Height)), $cropRect, ([System.Drawing.GraphicsUnit]::Pixel))

$outDir = "assets/icon"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir }

$target.Save("$outDir/app_icon.png", ([System.Drawing.Imaging.ImageFormat]::Png))
$g.Dispose()
$img.Dispose()
$target.Dispose()
