# Use the latest rocker/shiny image
FROM rocker/shiny:latest

RUN apt-get update && apt-get install -y \
  build-essential \
  libglpk40 \
  librsvg2-2 \
  libjs-jquery-slimscroll

# Install required R packages
RUN install2.r --error --skipinstalled \
    shiny \
    shinydashboard \
    shinyWidgets \
    shinyBS \
    shinyjs \
    readr \
    readxl \
    xml2 \
    writexl \
    rjson \
    stringr \
    stringdist \
    dplyr \
    tidyr \
    tibble \
    igraph \
    visNetwork \
    DiagrammeR \
    DiagrammeRsvg \
    rsvg \
    reactable \ 
    htmltools \ 
    tippy \ 
    conflicted

# Remove existing files and directories in /srv/shiny-server
RUN rm -rf /srv/shiny-server/*

# Copy the app code directly into the shiny-server directory
COPY . /srv/shiny-server/

# Change ownership of the 'tmp' directory to the 'shiny' user
RUN chown -R shiny:shiny /srv/shiny-server/tmp

# Change permissions of the 'tmp' directory
RUN chmod -R 700 /srv/shiny-server/tmp

# Use shiny user
USER shiny

# Expose the port the app runs on
EXPOSE 3838

# Run the Shiny app
CMD ["/usr/bin/shiny-server"]