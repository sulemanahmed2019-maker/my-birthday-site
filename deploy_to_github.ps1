<#
PowerShell helper to prepare and push this project to GitHub.
Usage (from the project folder):
    .\deploy_to_github.ps1 -RepoName "my-birthday-site"

Requires: Git and GitHub CLI (`gh`) installed and authenticated.
#>
param(
  [string]$RepoName = "my-birthday-site"
)

# Move to script folder
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location -Path $scriptDir
Write-Host "Working in: $scriptDir"

# Rename long favicon filename if present
$oldNames = @(
  'ChatGPT Image Jul 22, 2026, 10_06_44 PM.png',
  'ChatGPT%20Image%20Jul%2022%2C%202026%2C%2010_06_44%20PM.png'
)
foreach($old in $oldNames){
  if(Test-Path -Path $old){
    Write-Host "Renaming '$old' -> favicon.png"
    Rename-Item -Path $old -NewName 'favicon.png' -Force
  }
}

# Update HTML to point to favicon.png
$index = 'birthday-fun (4).html'
if(Test-Path $index){
  $text = Get-Content $index -Raw
  $text = $text.Replace('ChatGPT%20Image%20Jul%2022%2C%202026%2C%2010_06_44%20PM.png','favicon.png')
  $text = $text.Replace('ChatGPT Image Jul 22, 2026, 10_06_44 PM.png','favicon.png')
  Set-Content -Path $index -Value $text -Encoding UTF8
  Write-Host "Updated $index to reference favicon.png"
} else {
  Write-Warning "$index not found in $scriptDir"
}

# Check for git
if(-not (Get-Command git -ErrorAction SilentlyContinue)){
  Write-Error "Git not found. Install Git and re-run this script."
  exit 1
}

# Initialize git if needed
if(-not (Test-Path .git)){
  git init
  Write-Host "Initialized a new git repository."
}

# Add, commit
git add -A

# Verify git repository exists (use explicit check to avoid parsing redirection inside parentheses)
git rev-parse --git-dir > $null 2>&1
if($LASTEXITCODE -ne 0){
  Write-Host "No git repository detected after init. Aborting."
  exit 1
}

# Make initial commit (if none)
git rev-parse --verify HEAD > $null 2>&1
if($LASTEXITCODE -ne 0){
  git commit -m "Initial site"
  Write-Host "Created initial commit."
} else {
  Write-Host "Repository already has commits. Skipping initial commit."
}

# Check for GitHub CLI
if(-not (Get-Command gh -ErrorAction SilentlyContinue)){
  Write-Warning "GitHub CLI (gh) not found. You can push manually or install gh: https://cli.github.com/"
  Write-Host 'To push manually run: git remote add origin https://github.com/YOUR_USER/YOUR_REPO.git; git push -u origin main'
  exit 0
}

# Create repo and push via gh
try{
  gh repo create $RepoName --public --source=. --remote=origin --push --confirm
  Write-Host "Repository created and pushed as GitHub repo: $RepoName"
} catch {
  Write-Error "gh repo create failed: $_"
  Write-Host "If the repo already exists, add remote and push manually:"
  Write-Host "  git remote add origin https://github.com/YOUR_USER/$RepoName.git"
  Write-Host "  git branch -M main"
  Write-Host "  git push -u origin main"
}
