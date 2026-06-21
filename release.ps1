  $ErrorActionPreference = "Stop"

  $projectRoot = $PSScriptRoot
  $sourceFile = Join-Path $projectRoot "main-cv.tex"
  $workingPdf = Join-Path $projectRoot "main-cv.pdf"
  $releaseDirectory = Join-Path $projectRoot "releases"

  $date = Get-Date -Format "yyyy-MM-dd"
  $releasePdf = Join-Path $releaseDirectory "snair_cv_$date.pdf"

  Push-Location $projectRoot

  try {
      & lualatex -interaction=nonstopmode -halt-on-error $sourceFile

      if ($LASTEXITCODE -ne 0) {
          throw "LuaLaTeX compilation failed with exit code $LASTEXITCODE."
      }

      New-Item -ItemType Directory -Path $releaseDirectory -Force |
          Out-Null

      Get-ChildItem -LiteralPath $releaseDirectory `
          -Filter "snair_cv_*.pdf" -File |
          Remove-Item -Force

      Copy-Item -LiteralPath $workingPdf `
          -Destination $releasePdf -Force

      Write-Host "Release CV created: $releasePdf"
  }
  finally {
      Pop-Location
  }