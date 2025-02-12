[![Docker Pulls](https://img.shields.io/docker/pulls/silentmecha/7dtd.svg)](https://hub.docker.com/r/silentmecha/7dtd)
[![Image Size](https://img.shields.io/docker/image-size/silentmecha/7dtd/latest.svg)](https://hub.docker.com/r/silentmecha/7dtd)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-donate-success?logo=buy-me-a-coffee&logoColor=white)](https://www.buymeacoffee.com/silent001)

# silentmecha/7dtd

This repository contains the files needed to build and run a Docker image for a 7 Days to Die dedicated server. This image is built on Ubuntu and is specifically designed for quickly setting up a 7 Days to Die server. It uses a customized version of `steamcmd/steamcmd:ubuntu-24`, which includes additional programs, environment variables, and a dedicated USER account to ensure easy server creation and consistent configuration across instances. The image is optimized for streamlined deployment and management of **7 Days to Die** servers with all necessary dependencies and settings pre-configured.

> **Warning:** The latest version on Docker Hub may be out of date. Please check the GitHub repository for the most recent updates.

> **Note:** This image does not yet set all the settings for the server according to the ENV values. This is still a work in progress.

## Usage

This stack uses an image from [atmoz](https://github.com/atmoz). To see more on the image used visit their GitHub [https://github.com/atmoz/sftp](https://github.com/atmoz/sftp).

For more info on environment variables and what they do see [Environment Variables](#environment-variables)

### Available Tags

- `base`: Contains only the environment setup, excluding the game files.
- `latest`: Includes the game files needed for the server.

### Simplest Method

The simplest usage for this is using the `docker-compose` method to pull the `latest` image and run it.

```console
git clone https://github.com/silentmecha/7dtd.git 7DaysToDie
cd 7DaysToDie
cp .env.example .env
nano .env
docker-compose pull
docker-compose up -d
```

### Using the `base` tag

If you don't want to pull the entire image and don't need to keep multiple instances up to date, you can use the `base` tag.

```console
git clone https://github.com/silentmecha/7dtd.git 7DaysToDie
cd 7DaysToDie
cp .env.example .env
nano .env
docker-compose -f docker-compose.base.yml up -d
```

### Building Locally

If you prefer to build everything locally, you can start by building the `base` image and then the `latest` image.

```console
git clone https://github.com/silentmecha/7dtd.git 7DaysToDie
cd 7DaysToDie
cp .env.example .env
nano .env
docker build -f base.Dockerfile -t silentmecha/7dtd:base -t silentmecha/7dtd:latest .
docker build -f Dockerfile -t silentmecha/7dtd:latest .
docker-compose up -d
```

### Updating

Updating is now as simple as running a build on the `Dockerfile` or using `docker-compose build`. This will update the image without downloading all the game files again.

```console
docker-compose build
docker-compose up -d
```

### Environment Variables

| Variable Name        | Default Value                                     | Description                                                                                                                                                                                                                                                                                                                                                                                                         |
| -------------------- | ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| SERVERNAME           | ServerName                                        | Whatever you want the name of the server to be.                                                                                                                                                                                                                                                                                                                                                                     |
| SERVERPORT           | 26900                                             | Port used to connect to the server                                                                                                                                                                                                                                                                                                                                                                                  |
| SERVERPORT_1         | 26901                                             | Server port + 1 ( Confirmation for the port usage to follow )                                                                                                                                                                                                                                                                                                                                                       |
| SERVERPORT_2         | 26902                                             | Server port + 2 ( Confirmation for the port usage to follow )                                                                                                                                                                                                                                                                                                                                                       |
| SERVERVISIBILITY     | 2                                                 | Visibility of this server: 2 = public, 1 = only shown to friends, 0 = not listed. As you are never friend of a dedicated server setting this to "1" will only work when the first player connects manually by IP.                                                                                                                                                                                                   |
| SERVERPASSWORD       |                                                   | Password to gain entry to the server                                                                                                                                                                                                                                                                                                                                                                                |
| SERVERMAXPLAYERCOUNT | 8                                                 | Maximum Concurrent Players (8 is the maximum supported player count. Anything over 30 will cause corrupted save data.)                                                                                                                                                                                                                                                                                              |
| SERVERRESERVEDSLOTS  | 0                                                 | Out of the MaxPlayerCount this many slots can only be used by players with a specific permission level.                                                                                                                                                                                                                                                                                                             |
| SERVERADMINSLOTS     | 0                                                 | This many admins can still join even if the server has reached MaxPlayerCount                                                                                                                                                                                                                                                                                                                                       |
| SERVERDESCRIPTION    | "A 7 Days to Die server running inside of docker" | Whatever you want the server description to be, will be shown in the server browser.                                                                                                                                                                                                                                                                                                                                |
| SERVERWEBSITEURL     |                                                   | Website URL for the server, will be shown in the serverbrowser as a clickable link                                                                                                                                                                                                                                                                                                                                  |
| EACENABLED           | true                                              | Enables/Disables EasyAntiCheat                                                                                                                                                                                                                                                                                                                                                                                      |
| GAMEWORLD            | Navezgane                                         | "RWG" (see WorldGenSeed and WorldGenSize options below) or any already existing world name in the Worlds folder (currently shipping with e.g. "Navezgane", "PREGEN01", ...)                                                                                                                                                                                                                                         |
| GAMENAME             | "My Game"                                         | Whatever you want the game name to be. This affects the save game name as well as the seed used when placing decoration (trees etc) in the world. It does not control the generic layout of the world if creating an RWG world                                                                                                                                                                                      |
| WORLDGENSEED         | "asdf"                                            | If RWG this is the seed for the generation of the new world. If a world with the resulting name already exists it will simply load it                                                                                                                                                                                                                                                                               |
| WORLDGENSIZE         | 4096                                              | If RWG this controls the width and height of the created world. It is also used in combination with WorldGenSeed to create the internal RWG seed thus also creating a unique map name even if using the same WorldGenSeed. Has to be between 2048 and 16384, though large map sizes will take long to generate / download / load. Must be a value of 1024, and later than 12k maps do not function for multiplayer. |
| PLAYERKILLINGMODE    | 3                                                 | Player Killing Settings (0 = No Killing, 1 = Kill Allies Only, 2 = Kill Strangers Only, 3 = Kill Everyone)                                                                                                                                                                                                                                                                                                          |
| CONTROLPANELPORT     | 8080                                              | Port of the control panel webpage                                                                                                                                                                                                                                                                                                                                                                                   |
| CONTROLPANELENABLED  | true                                              | Enable/Disable the web control panel                                                                                                                                                                                                                                                                                                                                                                                |
| CONTROLPANELPASSWORD | CHANGEME                                          | Password to gain entry to the control panel                                                                                                                                                                                                                                                                                                                                                                         |
| TELNETENABLED        | true                                              | Enable/Disable the telnet                                                                                                                                                                                                                                                                                                                                                                                           |
| TELNETPORT           | 8081                                              | Port of the telnet server                                                                                                                                                                                                                                                                                                                                                                                           |
| TELNETPASSWORD       |                                                   | Password to gain entry to telnet interface. If no password is set the server will only listen on the local loopback interface                                                                                                                                                                                                                                                                                       |
| ADDITIONAL_ARGS      |                                                   | Currently not used                                                                                                                                                                                                                                                                                                                                                                                                  |
| SFT_USER             | foo                                               | Username for SFTP access to edit save data                                                                                                                                                                                                                                                                                                                                                                          |
| SFT_PASS             | pass                                              | Password for SFTP access to edit save data                                                                                                                                                                                                                                                                                                                                                                          |
| SFT_PORT             | 2222                                              | Port for SFTP access (should not be 22 )                                                                                                                                                                                                                                                                                                                                                                            |

For more info on the usage of SFTP see [here](https://github.com/atmoz/sftp). If you do not want to use a plane text password see [encrypted-password](https://github.com/atmoz/sftp#encrypted-password)

### Ports
Currently the following ports are used.

| Port             | Type | Default |
| ---------------- | ---- | ------- |
| TELNETPORT       | TCP  | 8081    |
| CONTROLPANELPORT | TCP  | 8080    |
| SERVERPORT       | TCP  | 26900   |
| SERVERPORT       | UDP  | 26900   |
| SERVERPORT_1     | UDP  | 26901   |
| SERVERPORT_2     | UDP  | 26902   |
| SFT_PORT         | TCP  | 2222    |

All these ports must be forwarded through your router, except for `TELNETPORT`, `CONTROLPANELPORT`, and `SFT_PORT`, unless you want to access the server via Telnet, use the web control panel externally, or remotely edit the save data, respectively.

## License

This project is licensed under the [MIT License](LICENSE).

If you enjoy this project and would like to support my work, consider [buying me a coffee](https://www.buymeacoffee.com/silent001). Your support is greatly appreciated!