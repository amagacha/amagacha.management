@echo off
setlocal
cd /d "%~dp0"
set "URL=http://127.0.0.1:8080/"
where py >nul 2>nul
if %errorlevel%==0 (
  start "" "%URL%"
  echo 海士ガチャを %URL% で起動しました。
  echo 終了するにはこの黒い画面で Ctrl+C を押してください。
  py -m http.server 8080
  goto :eof
)
where python >nul 2>nul
if %errorlevel%==0 (
  start "" "%URL%"
  echo 海士ガチャを %URL% で起動しました。
  echo 終了するにはこの黒い画面で Ctrl+C を押してください。
  python -m http.server 8080
  goto :eof
)
echo Pythonが見つかりません。
echo Pythonをインストールするか、GitHub Pagesへアップロードして利用してください。
pause
