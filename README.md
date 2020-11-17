# docker2021ml

This repository contains the source code materials to build the Docker _image_ and run _containers_' based on that image. It includes the RStudio Server service and files for the 2020/21 edition of the UniPD [**Master in Machine Learning and Big Data for Precision Medicine and Biomedical Research**](https://www.unipd.it/corsi-master/machine-learning-big-data).




# Index

- [What is that?](#what-is-that)
- [Prerequisites](#prerequisites)
- [Run and use the RStudio Server environment for the Master](#run-and-use-the-rstudio-server-environment-for-the-master-run-and-use)
- [Projects' Hands-on](#projects-hands-on)
- [Shut-down the service](#shut-dowm-the-service)
- [Updates](#updates)
- [Remove and Clean](#remove-and-clean)
- [Reproducible development](#reproducible-development)
- [Code of conduct](#code-of-conduct)
- [Warranty declaration](#warranty-declaration)



## What is that?

### Docker

Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure [...]

--- https://docs.docker.com/get-started/overview/

### Containers and Images

A **container** is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another.

A Docker **image** is a lightweight, standalone, executable package of software that includes everything needed to run an application: code, runtime, system tools, system libraries and settings.

Docker **containers** are isolated from one another and bundle their own software, libraries and configuration files.

--- https://www.docker.com/resources/what-container
 

### In _our words_ :-)

Thanks to Docker, we have created an image that bundles the software and files required to run smoothly the hands-on purposed during the Master, providing the corresponding scripts. Moreover, All that "software" will run precisely the same in every system on every OS you have (provided that you have Docker installed ;-)), without requiring any additional software or configuration nor conflicting with any existing software or configuration.

That will make you sure to have a fixed, stable, and isolated local working environment well configured for the Masters's exercises. That environment will always remain the same, forever. So, you will have the time to configure your local system properly (if you decide to do that, which is not required).

This way, we can respond and manage possible issues by standardly referring/fixing one environment for everyone.

Think of an image like a recipe to create a working box. You need to download that recipe only once (more precisely, "at most" once: an image is made up of layers, and if in the future you will need to update an image, or you will download other images that share layers with some images you already have, you will need to download the new/modified layers only).

Every time you will run a container (or more than one!) from an image, it provides you with a completely brand new environment, that starts always exactly with the same shape!

From your side, every time you will run a container, you will activate an instance of our "box" in your system. Next, you can visit a dedicated web page, from within any browser, that will serve as a "screen" into that box. Inside that web page (which looks into the box inside your computer, not somewhere over the Internet), you will find a complete RStudio working environment. The only difference from your "local" desktop version of RStudio (if you have installed it) is that "our" is entirely independent of your system, OS, and configurations, and vice-versa.

Please pay attention to the drawbacks: every time you will shut-down a container, it will completely disappear! Anything you changed/added/removed inside a running container won't be recorded/restored the next time you will run (another) container (regardless that you have run it from the same image). Every container run-up is new (you cannot change the recipe; you cannot change the new container's initial state). Every container shut-down is 100% destroyed (destroy a box will ultimately destroy its content too). We cannot stress it more: **everything inside a shut-down container is gone**!

Once you have hard-fixed this rule into your mind, we can start with the exceptions. You will see that we have set-up a linked folder (named `persistent-folder/`) from within (any) container to the folder in which you are when you run the container. If you run the container from one of your projects' folders, the `persistent-folder/` inside the container will be sharing the content (in both directions) with that project's folder! So, everything you have, add, or remove in your (local) project's folder is present, added, or removed from the `persistent-folder/` folder inside the container. Everything you add or remove in the `persistent-folder/` folder inside the container will be added or removed from your local project's folder (which won't be destroyed with the container when you will shut it down).


## Prerequisites

To set up the **RStudio Server** service and the environment for the Master, you need **Docker** installed into your system. 

Depending on your OS, the procedure is different.

You can check if you have (correctly installed) Docker running the following codes:

>  - Concerning the prompt in the code reported we will use the following convention: any user, including the `root` user, can run commands that are prefixed with the `$` prompt. In contrast, the `root` user (or an administrator, in Windows) must run commands that are prefixed with the `#` prompt. You can also prefix these commands with the `sudo` command, if available, to run them.


```
# docker --version
```

and 

```
# docker run hello-world
```



### Linux
If you have any recent distribution of Linux, everything should just ready out of the shell.

Otherwise, it should be sufficient that you run 
```
# apt update && apt -y install docker.io
```

You can find more information [here](https://docs.docker.com/engine/install/).



### Windows

1. Update Windows (settings/windows update). If a brand-updater (eg, HP, Dell, etc.) is present, update your whole system too. Check and do Windows and system updates in a loop until there aren't left to do for either type. (Sometimes, updates on the system activate other updates on Windows, and vice-versa.)

2. Install **WLS2** (instructions [here](https://docs.microsoft.com/en-us/windows/wsl/install-win10))

3. Install **Windows Terminal** (from within Windows Store)

4. Install **docker-desktop** (instruction [here](https://hub.docker.com/editions/community/docker-ce-desktop-windows))

And you are ready. Remember to use Windows Terminal with administrative privileges. To do that, go on its icon from the Win main button, left-click on its icon, select _more_, and next select _Run as administrator_.


### Mac

1. Open the terminal (`Command + Space` to open Spotlight, and then type "Terminal" and double click on the top search result), and from within it execute `brew cask install docker`.




## Run and use the RStudio Server environment for the Master

Once you have Docker (docker-desktop on Windows) installed, you can execute the Master's RStudio Server service and the environment by running the following commands.

The very first time you run the `docker run` command, Docker will automatically download the required (layers it uses to create the) image to run the RStudio Server service setup with all the Master's material and configurations. Hence, it would help if you had an Internet connection and some patients (3.83 GB of data required at maximum). All the further execution does not require to download anything (neither an Internet connection).

1. From your terminal run 
  ```
  # docker run -d --rm -v <path/to/your/project/directory>:/home/rstudio/persistent-folder -e PASSWORD=docker2021ml -p 8787:8787 corradolanera/docker2021ml
  ```
> NOTES:
>  - Docker on Windows requires an unusual path specification, ie, `C:\Users\<your_name>\Documents\<your_project>` becomes `/c/Users/<your_name>/Documents/<your_project>`, take that into consideration when running the above mentioned command to correctly type your `<path/to/your/project/directory>`. Eg, to link the service to the folder `C:\Users\cl\Documents\test`, I would need to type `/c/Users/cl/Documents/test`. Please note that in that example it is supposed that the folder `C:\Users\cl\Documents\test` exists.
>  - If you do not need/want persistent storage for the service (ie, you want to explore the hands-on or play with R), you can exclude the `-v <path/to/your/project/directory>:/home/rstudio/persistent-folder` part from the `# docker run` call.
>  - You can change the password as you prefer changing the argument after `-e PASSWORD=` (it does not matter what the password is, but you must set one). The user name to use for the log in is always `rstudio`.
>  - If you do not want to type all the command every time, you can create a bash script for all the long command above to save typing: create a file named `docker-run.sh` inside your project directory with the following content (personalized if necessary)
>
  ```
  #! /bin/sh

  docker run -d --rm -v <path/to/your/project/directory>:/home/rstudio/persistent-folder -e PASSWORD=docker2021ml -p 8787:8787 corradolanera/docker2021ml
  ```
> and simply run it from the terminal:
  
  ```
  # bash docker-run.sh
  ```
  

2. go to `localhost:8787` using any browser (eg, Chrome, Firefox, or Edge), entering the following credentials:

  - usr: `rstudio`
  - psw: `docker2021ml` (or the one you have chosen if you have changed it)
  
> NOTES:
>  - The project's folder `<path/to/your/project/directory>` will be automatically synchronized with the `persistent-folder/` inside the RStudio service's main folder. Everything else will be **definitively destroyed** and loosed once the container will be shut-down. So, first, pay attention to putting everything you need to work into your main project folder (into your local system). Next, copy everything you produce or create from RStudio Server (and you don't want to lose) into the `persistent-folder/` folder. The content will automatically and immediately appear and stored in your project's folder locally (structurally, they will be the _same_ folder; no copy will happen).
>  - You can run as many containers you like (if you would like more than one occurrence); change the left side number of the two after `-p` in the running call, adding up numbers at the end (eg, `-p 8788:8787`, or `8789:8787`, ...). Next, to use the RStudio Server of "that" container, visit the corresponding `localhost`'s port in a browser, eg, `localhost:8788`, `localhost:8789`, .....
>  - If you run multiple containers, keep track of the corresponding `<name>`s to correctly `stop` them (see the next section). To do that, run `# docker ps` after the execution of the `docker run [options] corradolanera/docker2021ml` command.

Now, you can enjoy working on RStudio Server (properly configured and prepared to work with the included Master's materials) at your convenience!




## Projects' hand-on

Once in RStudio Server, you can find a folder for each hands-on. To working with one of them, enter in the corresponding folder, and double-click on the corresponding `.Rproj` file. Say "yes" to the RStudio's prompt to open/switch to that project.




## Shut-down the service

Even if you close the terminal or the browser page which serves RStudio, the corresponding container still run unaffected. In that case, to shut it down, you need: to return to a terminal command line; find the `<name>` Docker has attributed to that container (running `# docker ps` and looking for it in the column `NAMES`); execute `# docker stop <name>`.

RStudio Server will become unavailable from that very moment, and all the running environment is **completely destroyed**.
  
> NOTES:
>  - **WARNING**: at the exact moment you shut-down, the container **EVERYTHING not stored in the `persistent-folder` is gone. FOREVER**. You will not have ANY option for restore!
>  - Every time a new container will run-up, it will be the same. Every time like the first time, except the content of the folder `persistent-folder`, which will always be the content of the project's folder `<path/to/your/project/directory>` defined when you `docker run [options] corradolanera\docker2021ml`.
>  - Because of a technical artifact, an empty folder named `kitematic` is present; you can (and you should) completely ignore it.




## Updates

In case there are updates for the main image, you can update that in your system by calling in a Terminal

```
# docker pull corradolanera/docker2021ml
```

Docker will download the changes made from the version you have in your system only (often, some few MBs only).




## Remove and Clean

To be sure all the containers are switched off (ie, no resources are in use), you can use the following commands from the Terminal

- look at **active** containers
  
  ```
  # docker ps
  ```

- look at **all** the containers (running or stopped)
  
  ```
  # docker ps -a
  ```

- **stop** a running container
  
  ```
  # docker stop <name>
  ```

- completely **remove** a (stopped) container
  
  ```
  # docker rm <name>
  ```

Other than that, if you want to completely **remove the image** template used to run the container (ie, the `corradolanera/docker2021ml`) to free its space in your system, you can run
  
  ```
  # docker rmi corradolanera/docker2021ml
  ```

That way, you will possibly free the ~ 4 GB it uses. "Possibly" because layers make up the image; if you have other images that use some of those layers, Docker won't delete the shared ones. Next, suppose you run again `# docker run [options] corradolanera/docker2021ml`. In that case, Docker will download the (layers you miss to make the) image again.




## Reproducible development

To create the Docker image on your own, you can:

1. get the raw project data:

  ```
  git clone https://github.com/UBESP-DCTV/docker2021ml.git
  ```

2. enter the project directory

  ```
  cd docker2021ml
  ```

3. build the Docker image using the `build` macro in the `Makefile`
  
  ```
  # make build
  ```

Now, if you are on Linux, to run this self-created image, you can use the provided `docker-run.sh` script. It links the folder in which the Terminal is when running the script to the `/home/rstudio/persistent-folder/` inside the container:

  
1. Copy the `Makefile` script provided with the project in your personal project's folder

  ```
  $ cp Makefile <path/to/your/project/folder>
  ```

2. Enter in your project folder

  ```
  $ cd <path/to/your/project/folder>
  ```
  
3. Execute the `run` macro to run the container for the RStudio Server service (listening on the standard port `localhost:8787`):

  ```
  # make run
  ```
  
> NOTE:
>  - clearly, you can explicitly running the command `docker run -d --rm -v <path/to/your/project/directory>:/home/rstudio/persistent-folder -e PASSWORD=docker2021ml -p 8787:8787 docker2021ml` instead, personalizing the left side of the `-p` argument, in case you need multiple instances. This time you will run the container from the image "without" the `corradolanera/` initial part because you are now running the local version of the image and not the one provided by the Docker-Hub.
  
## Code of Conduct
  
  Please note that the r-out-proj project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

## Warranty declaration

  THE OPEN SOURCE SOFTWARE IN THIS PRODUCT IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT WITHOUT ANY WARRANTY, WITHOUT EVEN THE IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE APPLICABLE LICENSES FOR MORE DETAILS.
  
<p xmlns:dct="http://purl.org/dc/terms/" xmlns:cc="http://creativecommons.org/ns#" class="license-text"><span rel="dct:title">docker2021ml</span> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/UBESP-DCTV/docker2021ml">UBESP-DCTV</a> is licensed under <a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/4.0">CC BY-NC-SA 4.0<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" /><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" /><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" /><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" /></a></p>

