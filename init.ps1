python -m venv .venv
.venv\Scripts\Activate.ps1

git init

$gitignore = @"
.venv/
__pycache__/
*.pyc
*.pyo
*.pyd
.env
.idea/
.vscode/
*.log
"@
[System.IO.File]::WriteAllText("$PWD\.gitignore", $gitignore)

git add .
git status

git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    git commit -m "配置文件"
} else {
    Write-Host "没有需要提交的改动"
}