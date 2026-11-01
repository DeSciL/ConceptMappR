# rocker/shiny pinned to the R version, so a rebuild doesn't change R unannounced
FROM rocker/shiny:4.6.1

# System libraries: glpk/rsvg for the app, the rest to build or run otelsdk (OpenTelemetry exporter)
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  libglpk40 \
  librsvg2-2 \
  libjs-jquery-slimscroll \
  libuv1 cmake protobuf-compiler libprotobuf-dev libcurl4-openssl-dev zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

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
    conflicted \
    otelsdk

# Fail the build, not the pod, if a shared library is missing
RUN Rscript -e 'library(otelsdk); library(rsvg); library(igraph); cat("ok\n")'

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

# Run the app directly with R (no shiny-server): one app per pod, Kubernetes restarts it,
# env vars (OTEL_*) reach R, and R's output goes to stdout/stderr.
# Shiny (>= 1.12) traces itself through otelsdk when OTEL_* env vars are set.
WORKDIR /srv/shiny-server
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server', host='0.0.0.0', port=3838)"]
