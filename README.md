# Docker image for the 2020/21 edition of the UniPD Master in Machine Learning for clinical research
 
This repository contains the source code materials to build and run the Docker image for the 2020/21 edition of the UniPD Master in Machine Learning and Big Data for Precision Medicine and Biomedical Research.
 
 
 
 
## Prerequisites

In order to setup the **RStudio Server** service and environment for the Master, you need **Docker** installed into your system. 

Depending on your OS, the procedure is different.

### Linux
If you have any recent distribution of Linux, everything should just ready out of the shell.

### Windows
1. Update Windows (settings/windows update) and, if present a brand-updater (eg, HP, Dell, ...), update your whole system. Check and do both those updates type in a loop until both return no updates anymore (sometimes update on system activate other updates on win, and vice-versa).

2. Install **WLS2** (instructions [here](https://docs.microsoft.com/en-us/windows/wsl/install-win10))

3. Install **Windows Terminal** (from within Windows Store)

4. Install **docker-desktop** (instruction [here](https://hub.docker.com/editions/community/docker-ce-desktop-windows))

And you are ready, just remember to use Windows Terminal with administrative privileges (to do that, go on its icon from the Win main button, left click on its icon, select _more_ and next select _Run as administrator_).

### Mac

1. Open the terminal (press `Command + Space` to open Spotlight, and then type "Terminal" and double click on the top search result), and from within it execute `brew cask install docker`.



## Run and use the RStudio Server environment for the Master

Once you have Docker (docker-desktop on Windows) installed, you can execute the Master's RStudio Server service and environment by running the following commands.

The very first time you run the `docker run` command, everything that is required will be automatically downloaded. Hence, you need an Internet connection and some patient (3.83 GB of data required at maximum). All the further execution do not require enithing else (neither an Internet connection).

1. From your termina run 
  ```
  # docker run -d --rm -v <path/to/your/project/directory>:/home/rstudio/persistent-folder -e PASSWORD=docker2021ml -p 8787:8787 corradolanera/docker2021ml
  ```
> NOTES:
>  - We use the convention that `$` starts a line of code you can run as a standard user, while `#` start a line of code to run with high privilege (ie, as `sudo`, on Linux/mac, or as `administrator`, on Windows).
>  - Docker on Windows requires an unusual path specification, ie, `C:\Users\<your_name>\Documents\<your_project>` becomes `/c/Users/<your_name>/Documents/<your_project>`, take that into consideration when running the above mentioned command to correctly type your `<path/to/your/project/directory>`. Eg, to link the service to the folder `C:\Users\cl\Documents\master_ml`, I would need to type `/c/Users/cl/Documents/master_ml`.
>  - If you do not need/want a persistent storage for the service (ie, you just want to explore the hands-on or R) you can exclude the `-v <path/to/your/project/directory>:/home/rstudio/persistent-folder` part of the call
>  - You can change the password as you prefer changing the argument after `-e PASSWORD=` (it does not matter at all), the user to use for the login it is always `rstudio`.

If you do not want to type all the command every time, you can create a bash script for all the long command above to save typing: just create a file named `docker-run.sh` inside your project directory with the following content (personalized if necessary)

  ```
  #! /bin/sh

  docker run -d --rm -v <path/to/your/project/directory>:/home/rstudio/persistent-folder -e PASSWORD=docker2021ml -p 8787:8787 corradolanera/docker2021ml
  ```
  
and simply run it from the terminal:
  
  ```
  # bash docker-run.sh
  ```
  

2. go to `localhost:8787` using any browser (eg, Chrome, FireFox, or Edge), entering the following credentials:

  - usr: `rstudio`
  - psw: `docker2021ml` (or the one you have chosen if you have changed it)
  
> NOTES:
>  - The project's folder `<path/to/your/project/directory>` will be automatically synchronized with the `persistent-folder/` inside the RStudio service's main folder, everything else will be **definitively destroyed** and loosed once the container will be shut-down. So, pay attention to put everything you need to work into your main project folder (into your local system) and to copy everything you produce or create from RStudio Server (and you don't want to loose) into the `persistent-folder/` folder, and the content will automatically and immediately appear and stored into your project's folder locally (structurally they will be the _same_ folder, no copy will happen).
>  - You can run as many container you like (if you would like more than one occurence), just change the left side number of the couple of numbers after `-p` in the running call, adding up numbers at the end (eg, `-p 8788:8787`, or `8789:8787`, ...). Next, to use the RStudio Server of "that" container visit the corresponding `localhost`'s port in a browser, eg, `localhost:8788`, `localhost:8789`, .... .
>  - If you run multiple containers it is strongly suggested to keep track of the corresponding `<name>`s running `# docker ps` just after the execution of the command to run it, to be able to correctly `stop` them (see the next section).

Now, you can enjoy working into RStudio Server at your convenience!




## Shut-down the service

Even if you close the command line session, or the browser page in which it serves RStudio you are using, the runned container will continue to run uneffected (unless you shut-down the system). In that case, to shut-down it, you need to return to a terminal command line, find the `<name>` Docker has attribute to that container running `# docker ps`(and looking for it in the column `NAMES`), and execute `# docker stop <name>`.

From that very moment RStudio Server will become unavailable and all the running environment is **completely destroyed**.
  
> NOTES:
>  - **WARNING**: at the exact moment you shut-down the container **EVERYTHING not stored in the `persistent-folder` is gone. FOREVER**. You will not have ANY option for restore!
>  - Every time a new container will run-up it will be exactly the same as always it has been the first time with the only exception of the content of the folder `persistent-folder` which will be always the content of the project's folder `<path/to/your/project/directory>` defined when you `docker run ...` the service.
>  - Because of a technical artifact, an empty folder named `kitematic` is present, you can (and you should) completely ignore it.




## Reproducible development (for developers of the system only)

To create the Docker image by your own, you can:

1. get the raw project data:

  ```
  git clone https://github.com/UBESP-DCTV/docker2021ml.git
  ```

2. enter the project directory

  ```
  cd docker2021ml
  ```

3. build the Docker image
  ```
  # bash docker-build.sh
  ```

Now, if you are on Linux, to run this self created image, you can use the provided `docker-run.sh` script, which link the folder in which the script is run to the `/home/rstudio/persistent-folder/` inside the container:

  
1. Copy the `docker-run.sh` script provided with the project in your personal project's folder
  ```
  $ cp docker-run.sh <path/to/your/project/folder>
  ```

2. enter in your project folder
  ```
  $ cd <path/to/your/project/folder>
  ```
  
3. execute the script to run the containered RStudio server service:
  ```
  # bash docker-run.sh
  ```
> NOTE:
>  - clearly, you can explicitly running the command `docker run -d --rm -v <path/to/your/project/directory>:/home/rstudio/persistent-folder -e PASSWORD=docker2021ml -p 8787:8787 docker2021ml`, this time **without the `corradolanera/` initial part** for the image's name (you are now running the local version of the image, not the one provided by dockerhub) into the `docker run` call (personalizing the left side of the `-p` argument, in case you need multiple instances).
  
  
