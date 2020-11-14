# This is the Dockerfile to create the image for the MLT master @UniPD

# Last stable release of R before version 4.0.0
FROM rocker/verse:3.6.3

# Metadata
LABEL maintainer="Corrado Lanera <corrado.lanera@unipd.it>"


# set the working directory inside the RStudio Server
WORKDIR /home/rstudio

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 8787


ENV pkgsnap=https://packagemanager.rstudio.com/all/__linux__/bionic/274

# Install Basic Utility R Packages
RUN install2.r \
  --error --skipinstalled \
  # Snapshot available as of April 23, 2020; just before the release of r-4.0.0
  --repos $pkgsnap \
  # packages to install
  caret \
  here \
  rms \
  splines
 
# Install additionl R Packages for Analyses
RUN install2.r \
  --error --skipinstalled \
  # Snapshot available as of April 23, 2020; just before the release of r-4.0.0
  --repos $pkgsnap \
  # packages to install
  kknn \
  mice \
  tm \
  SnowballC \
  wordcloud

# Install required R Packages not directly library()ed from scripts
RUN install2.r \
  --error --skipinstalled \
  # Snapshot available as of April 23, 2020; just before the release of r-4.0.0
  --repos $pkgsnap \
  # packages to install
  VIM \
  pryr

# Setup global profile's option for fixed-snapshot package repository
RUN echo '\
  options(list( \
    repos = "https://packagemanager.rstudio.com/all/__linux__/bionic/274" \
  )) ' > /usr/local/lib/R/etc/Rprofile.site
  
# copy all the materials from the local directory to the docker wd
COPY . /home/rstudio


