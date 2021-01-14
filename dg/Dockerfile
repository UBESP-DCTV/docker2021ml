# This is the Dockerfile to create the image for the MLT master @UniPD

FROM rocker/verse:4.0.3

# Metadata
LABEL maintainer="Corrado Lanera <corrado.lanera@unipd.it>"


# set the working directory inside the RStudio Server
WORKDIR /home/rstudio

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 18702


# Set r package snapshot available as of Jan 5, 2021;
ENV pkgsnap=https://packagemanager.rstudio.com/all/__linux__/focal/642006

# Install Basic Utility R Packages
RUN installGithub.r \
  HenrikBengtsson/progressr

RUN install2.r \
  --error --skipinstalled \
  --repos $pkgsnap \
  # packages to install
  caret \
  bench \
  here \
  pryr \
  assertable \
  assertive \
  rms

# Install additional packages for hands-on
RUN install2.r \
  --error --skipinstalled \
  --repos $pkgsnap \
  # packages to install
  elasticnet \
  glmnet \
  h2o \
  speedglm \
#  ElemStatLearn \ # prostate.rds data manually uploaded
  MASS \
  tree \
  rpart \
  randomForest \
  gam \
  Boruta \
  ggcorrplot

  
# Setup global profile's option for fixed-snapshot package repository
RUN echo '\
  options(list(repos = "$pkgsnap")) \
  ' > /usr/local/lib/R/etc/Rprofile.site
  
# copy all the materials from the local directory to the docker wd
COPY rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
COPY ./content /home/rstudio

