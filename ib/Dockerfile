# This is the Dockerfile to create the image for the MLT master @UniPD

# Last stable release of R before version 4.0.0
FROM rocker/verse:3.6.3

# Metadata
LABEL maintainer="Corrado Lanera <corrado.lanera@unipd.it>"


# set the working directory inside the RStudio Server
WORKDIR /home/rstudio

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 18701


# Set r package snapshot available as of April 23, 2020; just before the release of r-4.0.0
ENV pkgsnap=https://packagemanager.rstudio.com/all/__linux__/bionic/274

# Install Basic Utility R Packages
RUN install2.r \
  --error --skipinstalled \
  --repos $pkgsnap \
  # packages to install
  BiocManager \
  caret \
  here \
  kknn \
  rms \
  SnowballC \
  splines \
  tm \
  wordcloud

# Install required Bioconductor R Packages not directly library()ed from scripts
# Note: version 3.10 of bioc is the latest available for R 3.6
RUN R -e "BiocManager::install('Rgraphviz', ask = FALSE, version='3.10')"

# Install required R Packages not directly library()ed from scripts (module 1)
RUN install2.r \
  --error --skipinstalled \
  --repos $pkgsnap \
  # packages to install
  mice \
  miceadds \
  VIM \
  pryr \
  assertable \
  assertive \
  ggridges

RUN installGithub.r \
  HenrikBengtsson/progressr
  
# Setup global profile's option for fixed-snapshot package repository
RUN echo '\
  options(list( \
    repos = "https://packagemanager.rstudio.com/all/__linux__/bionic/274" \
  )) ' > /usr/local/lib/R/etc/Rprofile.site
  
# copy all the materials from the local directory to the docker wd
COPY rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
COPY ./content /home/rstudio


