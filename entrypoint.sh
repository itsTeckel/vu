#!/bin/bash
set -e
#Start a new screen to catch any windows Venice might show
Xvfb :1 -screen 5 1024x768x8 &

if [ -z "${LISTEN}" ]; then
	echo "LISTEN enviroment variable not set. Make it for example: 0.0.0.0:25200"
	sleep 2
	exit 1
fi
if [ -z "${HARMONYPORT}" ]; then
	echo "HARMONYPORT enviroment variable not set. Make it for example: 7948"
	sleep 2
	exit 1
fi
if [ -z "${RCONPORT}" ]; then
	echo "RCONPORT enviroment variable not set. Make it for example: 0.0.0.0:47200"
	sleep 2
	exit 1
fi

if [ -f "/vu/client/vu.com" ]; then
    echo "Skipping update as '/vu/client/vu.com' exists."
else 
	echo "Updating VU"
    cd /vu/client && wget https://veniceunleashed.net/files/vu.zip && unzip -o vu.zip && rm vu.zip
fi
#Update permissions so that Wine can access it.
chmod 777 -R /vu/client/
chmod 777 -R /vu/instance/
#chmod 777 -R /vu/bf3/

if [ -f "/vu/instance/server.key" ]; then
    echo "Found server.key"
else 
	echo "Could not read /vu/instance/server.key. Please go to: https://veniceunleashed.net/key-create"
	sleep 2
    exit 2
fi

if [ -f "/vu/bf3/bf3.exe" ]; then
    echo "Found Battlefield 3 client files"
else 
	echo "Could not read /vu/bf3/bf3.exe. Please mount your client files on /vu/bf3"
	sleep 2
    exit 2
fi

#Start the windows application with wine
if [ -z "${O_EMAIL}" ] &&  [ -z "${O_PASSWORD}" ]; then
  echo "O_EMAIL and or O_PASSWORD enviroment variables are not set. Please set them. Exiting...."
  sleep 2
  exit 1
else
  echo "Activating with ${O_EMAIL}"
  DISPLAY=:1 wine /vu/client/vu.com -gamepath /vu/bf3 -activate -o_mail $O_EMAIL -o_pass $O_PASSWORD
fi

#DISPLAY=:1 xwd -root -silent | convert xwd:- png:/vu/client/screenshot.png #Run this to catch any errors

echo "Starting $(winepath -w /vu/client/vu.com)"
DISPLAY=:1 wine /vu/client/vu.com -gamepath "$(winepath -w /vu/bf3)" -serverInstancePath "$(winepath -w /vu/instance)" -server -dedicated -headless -high120 -listen $LISTEN -mHarmonyPort $HARMONYPORT -RemoteAdminPort $RCONPORT
/wine/waitonprocess.sh wineserver