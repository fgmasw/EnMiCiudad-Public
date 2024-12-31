# Define variables
$ProjectDir = "D:\06MASW-A1\en_mi_ciudad"
$RemoteRepoUrl = "git@github.com:fgmasw/EnMiCiudad-Private.git"
$CommitMessage = "Update with changes $(Get-Date -Format 'yyyy-MM-dd HH:mm')"

# Prompt the user to save all changes in the IDE
$response = Read-Host "Have you saved all your changes in the IDE? (yes/no)"
if ($response -ne "yes") {
    Write-Host "Please save all your changes in the IDE before running the script."
    exit 1
}

# Navigate to the project directory
if (-Not (Test-Path -Path $ProjectDir)) {
    Write-Host "Project directory not found: $ProjectDir"
    exit 1
}
Set-Location -Path $ProjectDir

# Initialize Git repository if not already initialized
if (-Not (Test-Path -Path ".git")) {
    git init
}

# Create an initial README file if it doesn't exist
if (-Not (Test-Path -Path "README.md")) {
    "# MisPelis-Private" | Out-File -FilePath "README.md"
    git add README.md
    git commit -m "first commit"
}

# Create the main branch if not already on it
git branch -M main

# Add the remote repository if not already added
if (-Not (git remote | Select-String "origin")) {
    git remote add origin $RemoteRepoUrl
} else {
    git remote set-url origin $RemoteRepoUrl
}

# Check for unstaged changes and avoid pulling
$GitStatus = git status --porcelain
if ($GitStatus) {
    Write-Host "You have unstaged changes. Proceeding to commit and push without pulling."
}

# Add all files to the staging area
git add .

# Commit the changes with a message
git commit -m $CommitMessage

# Push changes to the remote repository
git push -u origin main

Write-Host "Backup completed successfully."