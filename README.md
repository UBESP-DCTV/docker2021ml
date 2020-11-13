# Docker image for the 2020/21 edition of the UniPD Master in Machine Learning for clinical research
 
This repository contains the source code materials to build and run the Docker image for the 2020/21 edition of the UniPD Master in Machine Learning for clinical research.
 
 
 
 
## HOWTO

To start working, type this on the command line

> We use the convention that `$` starts a line of code run by a standard user, while `#` start a line of code to run with high privilege (`sudo`, in Linux/mac, or `administrator`, in windows)


### Prerequisites

In order to setup the **RStudio Server** service and environment for the Master, you need **Docker** installed into your system. 

Depending on your OS, the procedure is different: you can follow the instruction [here](https://github.com/aaronpeikert/reproducible-research#resources) to install Docker (and **Chocolately**, for Windows only).


### Run and use the RStudio Server environment for the Master

Once you have Docker installed, you can execute the master's RStudio Server service/environment running the following commands. The first time everything required will be downloaded, hence you need an Internet connection and some patient (3.35 GB of data required at maximum)

> NOTE 1: On Windows OS you need first to start **Docker Desktop**, and allow the sharing of your drive.


1. go into your `<path/to/your/project/directory>` from the command line
  ```
  $ cd <path/to/your/project/folder>
  ```

2. run 
  ```
  # docker run --rm -v <path/to/your/project/directory>:/home/rstudio/persistent-folder -e PASSWORD=docker2021ml -p 8787:8787 corradolanera/docker2021ml
  ```

> NOTE 2: Docker on Windows requires an unusual path specification, ie, `C:\Users\<you>\Documents\<your_project>` becomes `/c/Users/<you>/Documents/<your_project>`, take that into consideration when running the above mentioned command to correctly type your `<path/to/your/project/directory>`!

> NOTE 3: You can create a bash script for all the long command above to save typing. Just create a file named `docker-run.sh` with the following content

  ```
  #! /bin/sh

  docker run --rm -v <path/to/your/project/directory>:/home/rstudio/persistent-folder -e PASSWORD=docker2021ml -p 8787:8787 corradolanera/docker2021ml
  ```
  
  And next simply copy that file in your `<path/to/your/project/directory>`, and run (from the command line, inside your `<path/to/your/project/directory>`)
  
  ```
  # bash docker-run.sh
  ```
  

3. go to `localhost:8787` using any browser (eg, Chrome, FireFox, or Edge), entering the following credentials:

  - usr: `rstudio`
  - psw: `docker2021ml`
  
> NOTE 4: The project's folder will be automatically synchronized with the `persistent-folder/` inside the RStudio main folder, everything else will be definitively destroyed and loosed once the container will be shut-down. So, pay attention to put everything you need to work into your main project folder (into your local system) and to copy everything you produce or create from RStudio Server (and you don't want to loose) into the `persistent-folder/` folder (and the content will appear and stored into your project's folder locally).

4. work into RStudio Server at your convenience

5. shut-down the container going back to the active running command line and press
  ```
  CTRL + c
  ```
  From that very moment RStudio Server will become unavailable and all the running environment is destroyed.
  
> NOTE 5: WARNING: at the exact moment you shut-down the container EVERYTHING not stored in the `persistent-folder` will gone FOREVER without ANY option for restore! Everytime a new container will run-up the system will be every exactly the same with the only exception of the content of the folder `persistent-folder` which will be always synchronized with the content of the current project's folder from which `# bash docker-run.sh` is executed.

> NOTE 6: Because of a technical artifact, an empty folder named `kitematic` is present, you can and should completely ignore it.




## Reproducible development

To recreate the Docker image by your own, you can follow the following instruction

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

Now, to ran this self created image, you can use the provided `docker-run.sh` script:

  
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
  
  
  
