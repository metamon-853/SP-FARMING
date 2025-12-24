# Flutter SDKのPATH設定スクリプト

Write-Host "Flutter SDKのPATH設定スクリプト" -ForegroundColor Green
Write-Host ""

# Flutter SDKの一般的な場所を確認
$possiblePaths = @(
    "$env:LOCALAPPDATA\flutter\bin",
    "C:\flutter\bin",
    "C:\src\flutter\bin",
    "$env:USERPROFILE\flutter\bin",
    "$env:USERPROFILE\Downloads\flutter\bin"
)

Write-Host "Flutter SDKのインストール場所を検索中..." -ForegroundColor Yellow
$flutterPath = $null

foreach ($path in $possiblePaths) {
    if (Test-Path "$path\flutter.bat") {
        $flutterPath = $path
        Write-Host "✓ Flutter SDKが見つかりました: $path" -ForegroundColor Green
        break
    }
}

if ($null -eq $flutterPath) {
    Write-Host "× Flutter SDKが見つかりませんでした。" -ForegroundColor Red
    Write-Host ""
    Write-Host "Flutter SDKのインストール場所を手動で入力してください:" -ForegroundColor Yellow
    Write-Host "例: C:\flutter\bin" -ForegroundColor Gray
    $flutterPath = Read-Host "パスを入力"
    
    if (-not (Test-Path "$flutterPath\flutter.bat")) {
        Write-Host "× 指定されたパスにFlutter SDKが見つかりません: $flutterPath" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "現在のPATHを確認中..." -ForegroundColor Yellow
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($currentPath -like "*$flutterPath*") {
    Write-Host "✓ PATH環境変数に既に追加されています。" -ForegroundColor Green
    Write-Host ""
    Write-Host "新しいPowerShellウィンドウを開いて 'flutter --version' を実行してください。" -ForegroundColor Yellow
} else {
    Write-Host "PATH環境変数に追加しますか？ (Y/N)" -ForegroundColor Yellow
    $response = Read-Host
    
    if ($response -eq "Y" -or $response -eq "y") {
        try {
            $newPath = $currentPath + ";$flutterPath"
            [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
            Write-Host "✓ PATH環境変数に追加しました: $flutterPath" -ForegroundColor Green
            Write-Host ""
            Write-Host "重要: 新しいPowerShellウィンドウを開いて 'flutter --version' を実行してください。" -ForegroundColor Yellow
            Write-Host "現在のセッションには反映されません。" -ForegroundColor Yellow
        } catch {
            Write-Host "× エラーが発生しました: $_" -ForegroundColor Red
            Write-Host ""
            Write-Host "手動で設定する場合は、以下のパスを環境変数に追加してください:" -ForegroundColor Yellow
            Write-Host $flutterPath -ForegroundColor Cyan
        }
    } else {
        Write-Host "設定をスキップしました。" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "手動で設定する場合は、以下のパスを環境変数に追加してください:" -ForegroundColor Yellow
        Write-Host $flutterPath -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "現在のセッションで一時的に使用する場合は、以下を実行してください:" -ForegroundColor Yellow
Write-Host "`$env:PATH += `";$flutterPath`"" -ForegroundColor Cyan

