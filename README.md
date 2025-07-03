# Setting up and starting IRAF

Follow these steps to set up and start the Image Reduction and Analysis Facility ([IRAF](https://iraf.net/)). This guide has been tested with macOS 14.2.1 on a MacBook Pro (arm64) and an iMac Pro (x86_64). Although the instructions are designed for Mac, much of the process is applicable to Linux with some modifications (for example, the XQuartz equivalent may be pre-installed or the `DISPLAY` environment variable may need to be set differently).

## Prerequisites
1.	Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop).
2.	Download and install [XQuartz](https://www.xquartz.org/). Restart your computer after installation.
## Setup
1.	Start XQuartz. Navigate to `Settings -> Security`. Enable the `Allow connections from network clients` option. After making this change, restart XQuartz to ensure settings have been updated.
2.	Open your terminal and run the command `xhost + 127.0.0.1`. This allows the Docker container to connect to your X server. Note, this command needs to be run each time you begin a new shell session, unless you add it to your shell's startup file (e.g., `.zshrc` or `.bashrc`), which will automate its execution. This may not be recommended due to security implications, though.
## Deployment of the IRAF Docker Container
1.	To create and start the Docker container, run the following command:

    `docker run -v /path/to/data/:/data -it --name iraf smeingast/iraf:2.17.1`

    Remember to replace `/path/to/data/` with the path to your desired data directory on your local machine. This directory will be accessible within the Docker container at the `/data` path. The `-v` flag in the command mounts the local directory to the Docker container.
2.	After running this command, Docker will download the `smeingast/iraf:2.17.1` image (if it's not yet downloaded), and start the container. You will find yourself inside the terminal for the running container. If you exit this terminal, you can reattach the Docker container with the command `docker exec -it iraf /bin/bash` or `docker attach iraf`. If you need to start the container again, use the command `docker start iraf`, followed by the previous command to reattach the container.
## Working with IRAF
1.	Once in the container, navigate to a working directory of your choice and configure IRAF with the command `mkiraf -c`.
2.	You can now modify the IRAF `login.cl` file as per your requirement (for instance to set different frame buffers). To make these modifications, you might need to install a compatible text editor (e.g., nano).
3.  To launch ds9 and xgterm, use the following commands:

    ```
    ds9 &
    xgterm &
    ```
    
4.	Now switch to the xgterm and run `ecl` in the directory that contains the `login.cl` file to start IRAF.

Congrats! You are now up and running with IRAF in your Docker container. Enjoy IRAF in 2024!

## Notes
Since this container is based on Ubuntu 22.04, you also have the option to install any additional packages you may need using the `apt` command.