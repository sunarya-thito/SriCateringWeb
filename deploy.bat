echo off
color 09
echo Building Flutter Web
cmd /c "flutter build web"
echo Deploying to Firebase
firebase deploy