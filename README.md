# ConceptMappR

[![CICD](https://github.com/DeSciL/ConceptMappR/actions/workflows/docker-ci.yml/badge.svg)](https://github.com/DeSciL/ConceptMappR/actions/workflows/docker-ci.yml) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.14938859.svg)](https://doi.org/10.5281/zenodo.14218066)

## Project Description

**ConceptMappR** is a Shiny dashboard designed to help students and teachers draw, analyze, and compare concept maps. 
Currently, a running version of ConceptMappR is hosted at: https://conceptmappr.vlab.ethz.ch/.
The development of ConceptMappR was funded by [Innovedum](https://ethz.ch/en/the-eth-zurich/education/innovedum.html) to advance education at [ETH Zurich](https://ethz.ch).

**Project Team**: Christian Thurn (ETH Zurich), Simona Daguati (ETH Zurich), Bruno Ruetsche (PH Schwyz)

**Development**: Bruno Ruetsche (PH Schwyz)

**Project Duration**: 01.05.2023 - 31.05.2024

**Maintenance and Development Notice**: This project has reached the end of its funded development period. While the repository remains available for public use, active maintenance and further development cannot be guaranteed. We encourage users to fork the project for their own modifications and enhancements as needed. Contributions, issue reports, and discussions are still welcome, though they may not receive immediate attention.

## Features

### General
- Draw and edit concept maps with customizable nodes and edges
- Analyze concept maps using network analysis techniques
- Generate interactive plots and tables for deeper exploration
- Export visualizations and analysis results in various formats
- Support for multiple file formats for both import and export

### Drawing
- Add, reorder and delete nodes
- Draw edges and add explanations
- Customize node layout, color and size
- Modify edge color and thickness

### Analysis
- Explore central nodes and edges 
- Compare learner and expert maps to investigate differences
- Aggregate multiple concept maps to generate average or meta maps

### Import / export
- Import concept maps from various file formats (e.g., .csv, .tsv, .txt, .xlsx, .cxl)
- Export network structures in formats like .cxl and .xlsx
- Export images of the concept maps in .png and .svg formats
- Export analysis results in .xlsx format

## Installation

**Note**: These installation instructions have been tested on a Mac computer with Apple silicon. Users on other devices, operating systems, or architectures (e.g., Intel-based Macs, Windows, Linux) may need to make slight adjustments to the installation process, such as different Docker settings, platform compatibility tweaks, or different dependencies.

### Getting the App

To get the app, you can:

- **Use a CLI**:

  ```bash
  # Run this in a system or Docker CLI
  git clone https://github.com/DeSciL/ConceptMappR.git
  ```
  
- **Download as a ZIP file**: Download the app as a [ZIP file](https://github.com/DeSciL/ConceptMappR/archive/refs/heads/master.zip) and extract it to your desired directory.

### Option 1: Manual

1. **Install R and RStudio**: Ensure that you have R and RStudio installed on your machine. You can download them from [CRAN](https://cran.r-project.org/) and [RStudio](https://rstudio.com/products/rstudio/download/).

2. **Install Required Packages**: Open RStudio and run the following commands to install the necessary packages:

    ```r
    # Run this in the R console
    install.packages(c("shiny", "shinydashboard", "shinyWidgets", 
                       "shinyBS", "shinyjs", "readr", 
                       "readxl", "xml2", "writexl", 
                       "rjson", "stringr", "stringdist", 
                       "dplyr", "tidyr", "tibble", 
                       "igraph", "visNetwork", "DiagrammeR", 
                       "DiagrammeRsvg", "rsvg", "reactable", 
                       "htmltools", "tippy", "conflicted"))
    ```

3. **Run the App**: Open a R console and run the app:

    ```r
    # Run this in the R console
    library(shiny)
    runApp("path/to/app")
    ```

    Replace `"path/to/app"` with the actual path where the app files are located.

### Option 2: Docker

If you prefer to run ConceptMappR using Docker, follow these steps:

1. **Install Docker**: Ensure that Docker is installed on your system. You can download Docker from [Docker's official website](https://www.docker.com/get-started).

2. **Create a Dockerfile**: In the root directory of the project, create a file named `Dockerfile` with the following content:

    ```dockerfile
    # Use the latest rocker/shiny image
    FROM rocker/shiny:latest

    # Install system dependencies
    RUN apt-get update && apt-get install -y \
        libglpk40 \
        librsvg2-2
      
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
    ```

3. **Build**: Build the Docker image using the following command:

    ```bash
    # Run this in a system or Docker CLI
    # Specifying platform for compatibility with Apple silicon
    docker build --platform linux/amd64 -t conceptmappr .
    ```

4. **Run**: Once the image is built, run the  app in a Docker container:

    ```bash
    # Run this in a system or Docker CLI
    # Specifying platform for compatibility with Apple silicon
    docker run --platform linux/amd64 -p 3838:3838 conceptmappr
    ```

5. **Access the app**: Open a web browser and navigate to `http://localhost:3838/` to access the app.

---

### Option 3: Docker Compose

To quickly set up and run the Shiny app using Docker Compose, follow these steps:

1. **Create a Dockerfile**: Save the Dockerfile from Option 2 in the root directory of your project, as it will be used to build the Docker image.

2. **Create a `docker-compose.yml` file**: In the root directory of the project, create a file named `docker-compose.yml` with the following content:

    ```yaml
    services:
      shiny:
        container_name: conceptmappr
        image: rocker/shiny:latest
        platform: "linux/amd64" # Platform specification for Apple silicon
        build:
          context: .
          dockerfile: Dockerfile
        restart: unless-stopped
        ports:
          - '3838:3838'
        volumes:
          - './logs:/var/log/shiny-server'
    ```

3. **Build**: Build the services using Docker Compose.

    ```bash
    # Run this in a system or Docker CLI
    docker compose build
    ```

4. **Run**: Build and start the services using the following command:

    ```bash
    # Run this in a system or Docker CLI
    docker compose up -d
    ```

5. **Access the app**: Open a web browser and navigate to `http://localhost:3838/` to access the app.

---

## License

This project is licensed under the terms of the GNU General Public License v3.0. See the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.txt) file for details.

## References

- Daguati, S., Rütsche, B., & Thurn, C. M. (2024). Describing Conceptual Knowledge in Concept Maps by Network Analysis. 13th International Conference on Conceptual Change, Munich, Germany. http://hdl.handle.net/20.500.11850/711121

- Thurn, C. M., Daguati, S., & Rütsche, B. (2024). ConceptMappR: Ein digitales Tool zum Erstellen und zur Analyse von Concept Maps. 6. Tagung Fachdidaktiken, Kreuzlingen, Switzerland. http://hdl.handle.net/20.500.11850/711127

