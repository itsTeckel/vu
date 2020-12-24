<p align="center">
  <img src="https://github.com/itsTeckel/vu/blob/master/logo.png?raw=true" />
</p>

# Venice Unleashed Linux Dedicated Server

![https://hub.docker.com/repository/docker/itsteckel/vu](https://img.shields.io/docker/image-size/itsteckel/vu.svg)
![https://hub.docker.com/repository/docker/itsteckel/vu](https://img.shields.io/docker/pulls/itsteckel/vu.svg)

This project represents the code used in order to run the Venice unleashed inside Docker. It builds on top of the [wine](https://github.com/itsTeckel/wine) base image and adds Venice unleashed specific code in order to run it.

## How to run it

Here are the steps you should take in order to run this image.

### Getting Battlefield 3 and setting up the required volume mounts

In order to be able to run the VU dedicated server you'll need the BF3 client files on your machine. The easiest way is to download the game via Origin on a Windows machine and then transfer them over to your Linux machine (using something like rsync or SCP).

1. Create a ```bf3``` docker volume. Copy all the BF3 client files you previously downloaded from Origin into this docker volume.
2. Create a ```instance``` docker volume. This is a directory containing configuration files, mods, and other necessary files to run your server. This can be empty at initial boot.
3. Create a ```client``` docker volume. This is a directory containing the VU files like vu.exe, vu.com and entrypoint.sh. This can be empty at initial boot.

### Activating the game

In order to run the VU server you have to activate the game. This process requires an Origin account which owns BF3. Please make sure the following enviroment variables are set:

| Enviroment variable  | Description
|------------------|----------------|
| O_EMAIL| Origin account e-mail    | 
| O_PASSWORD| Origin account password |

### Add server.key

Please go to: [veniceunleashed.net/key-create](https://veniceunleashed.net/key-create) then generate and download the server.key. Make sure this is saved in the instance directory. (/vu/instance/server.key)


### Configuring ports

The docker image will listen to the default ports. In order to run several dedicated servers you'll have to change this. Do this by overriding the following enviroment variables:

| Enviroment variable  | Description | Default |
|------------------|----------------|----------------|
| LISTEN |  Sets the host and port the VU server should listen for connections on. | 0.0.0.0:25200
| HARMONYPORT | Sets the port the VU server should listen for MonitoredHarmony connections | 7948
| RCONPORT | Sets the host and port the VU server should listen for RCON connections. | 0.0.0.0:47200


### Run it

The final step is bringing it all together. Either use docker run, docker compose or another way or running this container. Please make sure though that:

- Battlefield files (volume bf3) is mounted at ```/vu/bf3```
- Instance directory (volume instance) is mounted at ```/vu/instance```
- Client directory (volume client) is mounted at ```/vu/client```
- Enviroment variables as described above are set
- Ports are exposed.

#### Docker run

Run the following command. As you can see we set the required enviroment variables and then map the game files, instance and client directory. We also bind the ports the game server is running on.

```bash
docker run --name vu -it \
	-d itsteckel/vu:latest \
	-e O_EMAIL='<email>' \
	-e O_PASSWORD='<password>' \
	-e LISTEN='0.0.0.0:25200' \
	-e LISTEN='7948' \
	-e LISTEN='0.0.0.0:47200' \
	-v /location/on/host/bf3Files/:/vu/bf3 \
	-v /location/on/host/instance/:/vu/instance \
	-v /location/on/host/client/:/vu/client \
	-p 47200:47200/tcp \
	-p 7948:7948/udp \
	-p 25200:25200/udp
```

#### Docker-compose

Or run it using docker-compose. As you can see we set the required enviroment variables and then map the game files, instance and client directory. We also bind the ports the game server is running on.

```yaml
---
version: 3
services:
  steam:
    image: itsteckel/vu:latest
    restart: unless-stopped
    ports:
      - 47200:47200/tcp
      - 7948:7948/udp
      - 25200:25200/udp
    environment:
      - O_EMAIL=replaceMe@origin.com
      - O_PASSWORD=replaceMeWithYourOriginPassword
      - LISTEN=0.0.0.0:25200
      - HARMONYPORT=7948
      - RCONPORT=0.0.0.0:47200
    volumes:
      - bf3:/vu/bf3
      - instance:/vu/instance
      - client:/vu/client
```


## Debugging

A normal output does show some Wine errors:
```
Skipping update as '/vu/client/vu.com' exists.
Found server.key
Activating with ******@****.com
0040:err:ole:start_rpcss Failed to open RpcSs service
Please wait while your game is being activated. This process can take up to one minute...Your game has been successfully activated!Starting VU
XIO:  fatal IO error 11 (Resource temporarily unavailable) on X server ":99"      after 185 requests (185 known processed) with 0 events remaining.XIO:  fatal IO error 11 (Resource temporarily unavailable) on X server ":99"0070:err:ole:start_rpcss Failed to open RpcSs service
wine: Unhandled page fault on read access to 000000B8 at address 1000653A (thread 0090), starting debugger...
[2020-12-24 00:24:19+00:00] [info] Server Instance directory: /vu/instance
[2020-12-24 00:24:19+00:00] [info] Initializing the VeniceEXT engine v1.0.8...
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] Loading VeniceEXT module 'vu-compass-1.0.2'.
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] [vu-compass-1.0.2] Compiling client module...
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] [vu-compass-1.0.2] Compiling client script 'config.lua'...
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] [vu-compass-1.0.2] Compiling client script 'ui.lua'...
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] [vu-compass-1.0.2] Compiling client script 'utils.lua'...
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] [vu-compass-1.0.2] Compiling client script '__init__.lua'...
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] Successfully loaded VeniceEXT module 'vu-compass-1.0.2'.
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] Loading VeniceEXT module 'tactical-freelook'.
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] [tactical-freelook] Compiling client module...
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] [tactical-freelook] Compiling client script 'freelook.lua'...
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] [tactical-freelook] Compiling client script '__init__.lua'...
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] Successfully loaded VeniceEXT module 'tactical-freelook'.
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] Loading VeniceEXT module 'balanced-reinforcements'.
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] [balanced-reinforcements] Loaded VeniceEXT server script: __init__.lua
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] [balanced-reinforcements] Compiling client module...
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] [balanced-reinforcements] Compiling shared script 'config.lua'...
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] [balanced-reinforcements] Compiling shared script 'timers.lua'...
[2020-12-24 00:24:19+00:00] [info] [VeniceEXT] Successfully loaded VeniceEXT module 'balanced-reinforcements'.
[2020-12-24 00:24:20+00:00] [info] Initializing Venice Unleashed Server (Build 17384)...
[2020-12-24 00:24:20+00:00] [info] Mounting the VU game data File System.
[2020-12-24 00:24:23+00:00] [info] Remote Administration interface is listening on port 0.0.0.0:47200
[2020-12-24 00:24:23+00:00] [info] Successfully read startup configuration data.
[2020-12-24 00:24:23+00:00] [info] Loaded 0 entries from the player banlist file.
[2020-12-24 00:24:23+00:00] [info] Establishing connection to the Zeus Backend...
[2020-12-24 00:24:23+00:00] [info] Venice Unleashed dedicated server initialization finished.
[2020-12-24 00:24:24+00:00] [info] Successfully established connection to the Zeus Backend!
[2020-12-24 00:24:24+00:00] [info] Authenticating server with the Zeus Backend...
[2020-12-24 00:24:24+00:00] [info] Successfully authenticated server with Zeus (Server GUID: 386de7222f5e41efba4ccc183*******).
[2020-12-24 00:24:24+00:00] [info] Checking for updates...
[2020-12-24 00:24:26+00:00] [info] Update check complete. No new updates available.
```

### Errors

Venice currently has the tendency to show errors in a window. If this happens your log will end like this:
```
0048:err:ole:StdMarshalImpl_MarshalInterface Failed to create ifstub, hr 0x80004002
0048:err:ole:CoMarshalInterface Failed to marshal the interface {6d5140c1-7436-11ce-8034-00aa006009fa}, hr 0x80004002
0048:err:ole:apartment_get_local_server_stream Failed: 0x80004002
0050:err:ole:StdMarshalImpl_MarshalInterface Failed to create ifstub, hr 0x80004002
0050:err:ole:CoMarshalInterface Failed to marshal the interface {6d5140c1-7436-11ce-8034-00aa006009fa}, hr 0x80004002
0050:err:ole:apartment_get_local_server_stream Failed: 0x80004002
0050:err:ole:start_rpcss Failed to open RpcSs service
```

Please make sure that the server works well on Windows first. Then try editing the entrypoint.sh and replacing the ```xvfb-run -e /dev/stdout wine``` with ```wine```, which might give you more hints as to what goes wrong. 