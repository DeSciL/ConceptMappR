# This file is part of ConceptMappR.
# 
# ConceptMappR is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# ConceptMappR is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ConceptMappR. If not, see <https://www.gnu.org/licenses/>.

# ConceptMappR is a Shiny dashboard designed to help students and teachers 
# draw, analyze and compare concept maps.
#
# Project Team: Christian Thurn (ETH Zurich), Simona Daguati (ETH Zurich), 
#               Bruno Ruetsche (PH Schwyz)
# Development: Bruno Ruetsche (PH Schwyz)
# Project Duration: 01.05.2023 - 31.05.2024
# Funding: Innovedum (ETH Zurich)

# ---- Setup Environment ----
source("setup.R")

# ----- Load Functions ----
source("functions.R")

# ---- ui ----
ui <- dashboardPage(
  title = lang$app$title,
  skin = "black",
  
  ## dashboardHeader ----
  dashboardHeader(title = lang$app$title,
                  tags$li(a(href = lang$app$href,
                            img(src = "logo.png",
                                title = lang$app$institution, 
                                height = "30px"),
                            style = "padding-top:10px; padding-bottom:10px; border: none"),
                          class = "dropdown")
  ),
  
  ## dashboardSidebar ----
  dashboardSidebar(
    # Set up shinyjs
    useShinyjs(),
    width = 268,

    # Hide wrapper scrollbar
    shiny::tags$style(
      shiny::HTML(".wrapper {scrollbar-width: none;}")
    ),
    
    # Add scrollbar to centrality box
    shiny::tags$style(
      shiny::HTML("#boxCentrality {overflow-y: scroll}")
    ),

    # Make download button font black
    # https://stackoverflow.com/questions/36314780/shinydashboard-grayed-out-downloadbutton
    tags$style(
      HTML(
        ".skin-black .sidebar .shiny-download-link { 
          color: #444; 
          }
        "
      )      
    ),
    
    # Set tooltip style to match that of tippy (which is used for reactable)
    tags$style(
      HTML(
        ".tooltip > .tooltip-inner {
            color: rgba(220, 220, 220, 1);
            background-color: rgba(20, 20, 20, 1);
          }"
      )
    ),
    
    # Set font size in info boxes
    tags$style(
      HTML(
        ".infoBox {
            font-size: 18px
        }"
      )
    ),
    
    # Style footer
    tags$style(
      HTML("
        .content {
          padding-bottom: 50px; /* Space for the footer */
        }

        .footer-row {
          position: fixed;
          bottom: 0;
          left: 0;
          right: 0;
          text-align: center;
          font-size: 10px;
          padding: 10px;
          background-color: rgb(236, 240, 245); /* Match footer background to page. Must be changed when changing themes. */
        }

        .footer-row p {
          margin: 0px;
        }
    ")),
    
    # Network plots fill the boxes
    tags$style(HTML("
      #tabDraw, #tabAnalyze {
        display: flex;
        flex-direction: column;
        height: 100vh;
      }
      
      #drawBox, #boxMap1, #boxMap2 {
        flex-grow: 1;
        display: flex;
        flex-direction: column;
      }
      
      #plotMapDraw, #plotMap1, #plotMap2 {
        flex-grow: 1;
        padding: 10px;
      }
    ")),
    
    # Remove focus outline around plots
    tags$style(HTML("
      .vis-network:focus {
          outline: none;
      }
    ")),
    
    # Style the popups in drawing
    tags$style(HTML("
      #drawBox {
          position: relative;
          padding: 0;
          margin: 0;
          width: 100%;
          height: 100%;
      }

      .network-popUp {
          padding: 20px;
          border-radius: 8px;
          background-color: #f9f9f9;
          box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
          width: 400px; 
          max-width: 400px;
          position: absolute;
          top: 50%;
          left: 50%;
          transform: translate(-50%, -50%);
          margin: 0;
      }
  
      .network-popUp table {
          margin: 20px 0;
          width: 100%;
          border-collapse: separate;
          border-spacing: 0 5px;
      }
    
      .network-popUp td {
          padding: 5px 10px;
          vertical-align: middle;
      }
    
      .network-popUp td:first-child {
          text-align: left;
          font-weight: bold;
          color: #333;
      }
    
      .network-popUp input[type=\"text\"],
      .network-popUp input[type=\"number\"],
      .network-popUp input[type=\"color\"],
      .network-popUp select {
          width: 100%;
          padding: 6px;
          border-radius: 4px;
          border: 1px solid #ccc;
          box-shadow: inset 0px 2px 4px rgba(0, 0, 0, 0.1);
          font-size: 14px;
      }
    
      .network-popUp input[type='color'] {
          padding: 0 20px 0 20px;  /* Remove padding */
      }
      
      .network-popUp input[type=\"button\"] {
          padding: 8px 16px;
          margin: 5px;
          border-radius: 4px;
          border: none;
          background-color: rgb(34, 45, 50);
          color: white;
          font-size: 14px;
          cursor: pointer;
          transition: background-color 0.3s ease;
      }
    
      .network-popUp input[type=\"button\"]:hover {
          background-color: rgb(50, 65, 72);
      }
    
      @media (max-width: 600px) {
          .network-popUp {
              max-width: 90%;
          }
    
          .network-popUp table {
              width: 100%;
          }
    
          .network-popUp td {
              display: block;
              width: 100%;
              text-align: left;
          }
    
          .network-popUp td:first-child {
              font-size: 14px;
              padding-bottom: 5px;
          }
    
          .network-popUp input[type=\"button\"] {
              width: 100%;
              margin: 10px 0;
          }
      }
    ")),
    
    # Center popups in drawing
    tags$script(HTML("
      function centerPopUp() {
        var popUp = document.querySelector('.network-popUp');
        var drawBox = document.getElementById('drawBox');
        if (popUp && drawBox) {
          var drawBoxRect = drawBox.getBoundingClientRect();
          var popUpRect = popUp.getBoundingClientRect();

          popUp.style.top = (drawBoxRect.height / 2 - popUpRect.height / 2) + 'px';
          popUp.style.left = (drawBoxRect.width / 2 - popUpRect.width / 2) + 'px';
        }
      }

      window.addEventListener('resize', centerPopUp);                           // Re-center on window resize
      document.addEventListener('DOMContentLoaded', centerPopUp);               // Center on load
    ")),
    
    # Set defaults, min, max and step values of inputs in drawing
    tags$script(HTML("
    // This function sets default values for inputs in the drawing popup.
    // It ensures that the name, size, and color are set to desired defaults if 
    // they are not already set.
    function setDefaultValuesForAddNode() {
        var nameInput = document.getElementById('addnode-name');
        console.log(nameInput.value);
        if (nameInput && (nameInput.value === 'undefined')) {
          nameInput.value = 'new node';
        }
        
        var sizeInput = document.getElementById('addnode-size');
        console.log(sizeInput.value);
        if (sizeInput && (sizeInput.value === '')) {
          sizeInput.value = 25;
        }
        
        var coloringInput = document.getElementById('addnode-coloring');
        if (coloringInput && (coloringInput.value === '#000000')) {
          coloringInput.value = '#97c2fc';
        }
      }
  
      // This function sets the min, max, and step attributes for various number inputs.
      // It ensures that the inputs have the correct attributes set for valid user input.
      function setMinMaxStepAttributes() {
        var addNodeSizeInput = document.getElementById('addnode-size');
        if (addNodeSizeInput) {
          addNodeSizeInput.setAttribute('min', 1);
          addNodeSizeInput.setAttribute('max', 100);
          addNodeSizeInput.setAttribute('step', 1);
        }
  
        var editNodeSizeInput = document.getElementById('editnode-size');
        if (editNodeSizeInput) {
          editNodeSizeInput.setAttribute('min', 1);
          editNodeSizeInput.setAttribute('max', 100);
          editNodeSizeInput.setAttribute('step', 1);
        }
        
        var arrowheadsInput = document.getElementById('editedge-arrowheads');
        if (arrowheadsInput) {
          // Store the current value before replacing the element
          var currentValue = arrowheadsInput.value;

          // Replace the numeric input with a select dropdown
          var selectElement = document.createElement('select');
          selectElement.id = 'editedge-arrowheads';
          selectElement.name = 'editedge-arrowheads';

          var options = [
            { value: 0, text: '0 (no arrowheads)' },
            { value: 1, text: '1 (arrow from source to target)' },
            { value: 2, text: '2 (bidirectional arrow)' }
          ];

          options.forEach(function(optionData) {
            var optionElement = document.createElement('option');
            optionElement.value = optionData.value; // Store numeric value
            optionElement.text = optionData.text;   // Display text

            // Set the 'selected' attribute if this option matches the current value
            if (parseInt(optionData.value) === parseInt(currentValue)) {
              optionElement.selected = true;
            }

            selectElement.appendChild(optionElement);
          });

          // Replace the existing input with the new select element
          arrowheadsInput.parentNode.replaceChild(selectElement, arrowheadsInput);
        }

        var widthInput = document.getElementById('editedge-width');
        if (widthInput) {
          widthInput.setAttribute('min', 1);
          widthInput.setAttribute('max', 10);
          widthInput.setAttribute('step', 1);
        }
      }
      
      // This function sets up MutationObservers on the popups to detect when 
      // they become visible. When a popup is displayed, it applies the 
      // necessary attributes and default values.
      function observePopUps() {
        var config = { attributes: true, attributeFilter: ['style'] };
        var callback = function(mutationsList, observer) {
          mutationsList.forEach(function(mutation) {
            if (mutation.type === 'attributes' && mutation.target.style.display === 'block') {
              setMinMaxStepAttributes();
              if (mutation.target.id === 'addnode-popUp') {
                setDefaultValuesForAddNode();
              }
            }
          });
        };
  
        // Apply the observer to each popup
        ['addnode-popUp', 'editnode-popUp', 'editedge-popUp'].forEach(function(id) {
          var popUp = document.getElementById(id);
          if (popUp) {
            var observer = new MutationObserver(callback);
            observer.observe(popUp, config);
          }
        });
      }
  
      // This interval checks if the plot is available and starts observing the
      // popups when it is.
      var checkPlotInterval = setInterval(function() {
        var plot = document.getElementById('graphplotMapDraw');
        if (plot) { 
          observePopUps();
        }
      }, 1000); 
   ")),
    
    # Add JavaScript to expand / collapse all readme boxes
    tags$head(
      tags$script(HTML("
        $(document).ready(function() {
          // Expand all boxes
          $('#expand_all').click(function() {
            $('.box.collapsed-box').each(function() {
              $(this).find('.box-header .fa-plus').click();
            });
          });

          // Collapse all boxes
          $('#collapse_all').click(function() {
            $('.box:not(.collapsed-box)').each(function() {
              $(this).find('.box-header .fa-minus').click();
            });
          });
        });
      "))
    ),
    
    # sidebarMenu
    sidebarMenu(
      id = "tabs",
      menuItem(lang$tabWelcome$name, icon = icon("hand"), tabName = "tabWelcome", selected = TRUE),
      menuItem(lang$tabReadme$name, icon = icon("readme"), tabName = "tabReadme"),
      menuItem(lang$tabDraw$name, icon = icon("pencil"), tabName = "tabDraw"),
      menuItem(lang$tabAnalyze$name, icon = icon("chart-simple"), tabName = "tabAnalyze")
    )
  ),
  
  ## dashboardBody ----
  dashboardBody(
    tabItems(
      ### tabWelcome ----
      tabItem(tabName = "tabWelcome",
              HTML(lang$tabWelcome$title),
              fluidRow(
                box(class = "infoBox", width = 12, height = "calc(100vh - 199px)", solidHeader = TRUE, 
                    HTML(lang$tabWelcome$text)
                )
              )
      ),
      
      ### tabReadme ----
      tabItem(tabName = "tabReadme",
              fluidRow(
                column(width = 12,
                       div(
                         style = "display: flex; justify-content: space-between; 
                                  align-items: flex-end; margin-bottom: 0px;",
                         HTML(lang$tabReadme$title),
                         div(
                           style = "display: flex; align-items: flex-end;",
                           actionButton("expand_all", 
                                        lang$tabReadme$expandButton, 
                                        style = "margin-left: 10px; margin-bottom: 10px"),
                           actionButton("collapse_all", 
                                        lang$tabReadme$collapseButton, 
                                        style = "margin-left: 10px; margin-bottom: 10px")
                         )
                       )
                )
              ),
              fluidRow(
                column(width = 6,
                       box(id = "box1", class = "infoBox", 
                           title = lang$tabReadme$box1$title, 
                           collapsible = TRUE, collapsed = FALSE, 
                           width = NULL, status = "warning",
                           HTML(lang$tabReadme$box1$text)
                       ),
                       box(id = "box2", class = "infoBox", 
                           title = lang$tabReadme$box2$title, 
                           collapsible = TRUE, collapsed = TRUE, 
                           width = NULL, status = "success",
                           HTML(lang$tabReadme$box2$text)
                       ),
                       box(id = "box3", class = "infoBox", 
                           title = lang$tabReadme$box3$title, 
                           collapsible = TRUE, collapsed = TRUE, 
                           width = NULL, status = "info",
                           HTML(lang$tabReadme$box3$text)
                       ),
                       box(id = "box4", class = "infoBox", 
                           title = lang$tabReadme$box4$title, 
                           collapsible = TRUE, collapsed = TRUE, 
                           width = NULL, status = "primary",
                           HTML(lang$tabReadme$box4$text)
                       ),
                       box(id = "box5", class = "infoBox", 
                           title = lang$tabReadme$box5$title, 
                           collapsible = TRUE, collapsed = TRUE, 
                           width = NULL, status = "warning",
                           HTML(lang$tabReadme$box5$text)
                       ), 
                       box(id = "box6", class = "infoBox", 
                           title = lang$tabReadme$box6$title, 
                           collapsible = TRUE, collapsed = TRUE, 
                           width = NULL, status = "success",
                           HTML(lang$tabReadme$box6$text)
                       )
                ),
                column(width = 6,
                       box(id = "box7", class = "infoBox", 
                           title = lang$tabReadme$box7$title, 
                           collapsible = TRUE, collapsed = TRUE, 
                           width = NULL, status = "info",
                           HTML(lang$tabReadme$box7$text)
                       ),
                       box(id = "box8", class = "infoBox", 
                           title = lang$tabReadme$box8$title, 
                           collapsible = TRUE, collapsed = TRUE, 
                           width = NULL, status = "primary",
                           HTML(lang$tabReadme$box8$text)
                       ),
                       box(id = "box9", class = "infoBox", 
                           title = lang$tabReadme$box9$title, 
                           collapsible = TRUE, collapsed = TRUE, 
                           width = NULL, status = "warning",
                           HTML(lang$tabReadme$box9$text)
                       ),
                       box(id = "box10", class = "infoBox", 
                           title = lang$tabReadme$box10$title, 
                           collapsible = TRUE, collapsed = TRUE, 
                           width = NULL, status = "success",
                           HTML(lang$tabReadme$box10$text)
                       ),
                       box(id = "box11", class = "infoBox", 
                           title = lang$tabReadme$box11$title, 
                           collapsible = TRUE, collapsed = TRUE, 
                           width = NULL, status = "info",
                           HTML(lang$tabReadme$box11$text)
                       ),
                       box(id = "box12", class = "infoBox", 
                           title = lang$tabReadme$box12$title, 
                           collapsible = TRUE, collapsed = TRUE, 
                           width = NULL, status = "primary",
                           HTML(lang$tabReadme$box12$text)
                       ),
                       box(id = "box13", class = "infoBox", 
                           title = lang$tabReadme$box13$title, 
                           collapsible = TRUE, collapsed = TRUE, 
                           width = NULL, status = "warning",
                           HTML(lang$tabReadme$box13$text)
                       )
                )
              )
      ),
      
      ### tabDraw ----
      tabItem(tabName = "tabDraw",
              fluidRow(
                style = "margin-left: 0px;",
                HTML(lang$tabDraw$title),
                HTML(lang$tabDraw$info)
              ),
              fluidRow(
                box(id = "drawBox", title = NULL, width = 12, height = "calc(100vh - 290px)", solidHeader = TRUE,
                    visNetworkOutput("plotMapDraw")
                ),
              )
      ),
      
      ### tabAnalyze ----
      tabItem(tabName = "tabAnalyze")
    )
  )
)


# ---- server ----
server <- function(input, output, session) {

  # Initialize reactive values (rv) ----
  rv <- reactiveValues(multipleFiles = NULL,                                    # Will be set to FALSE when a single primary file is uploaded, TRUE if multiple files are uploaded
                       comparisonData = NULL,                                   # Will be set to FALSE when no comparison file is uploaded, TRUE if a comparison file is uploaded
                       initPlotMapDraw = 0,                                     # Counter that is increased to trigger reading the uploaded files
                       startAnalysis = 0,                                       # Counter that is increased to trigger the analysis
                       dataMatchedAvailable = 0,                                # Counter that is increased to trigger the the next step
                       
                       # Data of the drawing
                       dataDraw = NULL,                                         
                       
                       # Data of the primary file(s)
                       dataRaw1 = NULL,                                         # Raw data
                       dataMatched1 = NULL,                                     # Matched data with the comparison data
                       dataAgg1 = NULL,                                         # Aggregated (matched) data
                       dataMatchedSel1 = NULL,                                  # Selection of the matched data
                       dataAggSel1 = NULL,                                      # Selection of the aggregated (matched) data
                       dataMap1 = NULL,                                         # Data for the network plot
                       dataMapSel1 = NULL,                                      # Selection of the data for the network plot
                       
                       # Data of the comparison file
                       dataRaw2 = NULL,                                         # Raw data
                       dataMatched2 = NULL,                                     # Matched data with the primary data
                       dataAgg2 = NULL,                                         # Aggregated (matched) data
                       dataMap2 = NULL,                                         # Data for the network plot
                       dataMapSel2 = NULL,                                      # Selection of the data for the network plot

                       centrality1 = NULL,                                      # Centrality values (primary data)
                       centrality2 = NULL,                                      # Centrality values (comparison data)
                       
                       posMapDrawCurrent = NULL,                                # Current positions (drawing)
                       posMapDrawManual = NULL,                                 # Stored positions in the "manual" layout (drawing)
                       posMap1Current = NULL,                                   # Current positions (drawing)
                       posMap1Manual = NULL,                                    # Stored positions in the "manual" layout (primary data)
                       posMap2Current = NULL,                                   # Current positions (drawing)                      
                       posMap2Manual = NULL,                                    # Stored positions in the "manual" layout (comparison data)
                       
                       reset = 0                                                # Counter that is increased to trigger resetting the app
                       )

  # Save path of session-specific temporary directory ----
  tmpDir <- file.path("tmp", session$token)

  # Footer ----
  # The footer is added with insertUI to position it within the content area.
  insertUI(
    selector = "#shiny-tab-tabAnalyze",
    where = "afterEnd",
    ui = tags$div(
      class = "footer-row",
      HTML(lang$footer$text)
    )
  )
    
  # Sidebar ----
  ## Insert UI ----
  insertUI(
    selector = "#tabs",
    where = "afterEnd",
    immediate = TRUE,
    ui = div(id = "tabBreak", 
             hr()
    )
  )
  insertSidebarUI(session = session, lang = lang)
  
  ## Update UI ----
  observeEvent(c(input$tabs, 
                 input$matchingType, 
                 input$sourcePrimary, 
                 input$layoutDraw,
                 input$layoutAnalyze), {
    visibilitySidebarUI(input = input, rv = rv)
  }, priority = 1000)
  
  # tabWelcome ----
  
  ## linkToTabReadme ----
  observeEvent(input$linkToTabReadme, {
    updateTabItems(session, "tabs", "tabReadme")
  })
  
  ## linkToTabDraw1 ----
  observeEvent(input$linkToTabDraw1, {
    req(input$linkToTabDraw1)
    updateTabItems(session, "tabs", "tabDraw")
  })

  ## linkToTabDraw2 ----
  observeEvent(input$linkToTabDraw2, {
    req(input$linkToTabDraw2)
    updateTabItems(session, "tabs", "tabDraw")
  })
  
  ## linkToTabAnalyze1 ----
  observeEvent(input$linkToTabAnalyze1, {
    req(input$linkToTabAnalyze1)
    updateTabItems(session, "tabs", "tabAnalyze")
  })
  
  ## linkToTabAnalyze2 ----
  observeEvent(input$linkToTabAnalyze2, {
    req(input$linkToTabAnalyze2)
    updateTabItems(session, "tabs", "tabAnalyze")
  })
  
  # tabReadme ----
  
  # tabDraw ----
  
  ## Set dataDraw ----
  observeEvent(input$fileDraw, {
    req(input$fileDraw)
    
    # Read file
    data <- readFiles(input$fileDraw)
    
    # Check if the returned value is a filename (character)
    if (is.character(data)) {
      showNotification(paste0(lang$sidebar$upload$errorMessage, " ", data), type = "error")        # Show popup
      req(FALSE)                                                                                   # Do not continue
    }
 
    # (Re)set stored manual positions
    rv$posMapDrawManual <- NULL
    
    # When positions are present in the data, store them and switch to 
    # manual layout
    if (("x" %in% names(data$nodes)) & ("y" %in% names(data$nodes))) {
      updateSelectInput(session, "layoutDraw", selected = "manual")
      rv$posMapDrawManual <- data$nodes %>%
        select(id, x, y)
    }

    
    # Delay centering the plot to ensure it is fully rendered before applying visFit
    delay(50, {
      visNetworkProxy("plotMapDraw") %>% 
        visFit(animation = list(duration = 200, easingFunction = "easeInOutQuad"))
    })
    
    rv$dataDraw <- data
    rv$initPlotMapDraw <- rv$initPlotMapDraw + 1
  })
  
  ## Draw plotMapDraw ----
  output$plotMapDraw <- renderVisNetwork({
    req(input$layoutDraw, input$randomSeedDraw)
    
    tryCatch({
      if (is.null(rv$dataDraw)) {
        # Set up data for initial plot
        rv$dataDraw <- data.frame(fromLabel = c("A","B", "A"), 
                                  label = c("E1", "E2", "E3"),
                                  toLabel = c("B","C", "C"),
                                  arrowheads = c(0, 1, 2),
                                  check.names = FALSE
                                  ) %>%
          restructureAndFillData()
        
        rv$dataDraw$nodes <- rv$dataDraw$nodes %>%
          mutate(x = c(-60, 60, 0),
                 y = c(0, 0, -100))
      } else {
        # Remove node positions (e.g., in case layout was changed)
        rv$dataDraw$nodes$y <- NULL
        rv$dataDraw$nodes$x <- NULL
      }
      
      # Add node positions for manual layout
      if ((input$layoutDraw == "manual") & 
          (!is.null(rv$posMapDrawManual))) {
        rv$dataDraw$nodes <- addPositions(data = rv$dataDraw$nodes, pos = rv$posMapDrawManual)
      }
      
      # Create plot
      networkPlot(nodes = rv$dataDraw$nodes, edges = rv$dataDraw$edges, layout = input$layoutDraw, manipulation = TRUE, randomSeed = input$randomSeedDraw, lang = lang)
    },
    error = function(e) {
      showNotification(lang$tabDraw$errorMessage, type = "error")               # Show popup
      req(FALSE)                                                                # Do not continue
    })

  }) %>%
    bindEvent(rv$initPlotMapDraw, input$layoutDraw, input$randomSeedDraw)

  
  ## Update dataDraw / plotMapDraw ----
  observeEvent(input$plotMapDraw_graphChange, {
    req(input$plotMapDraw_initialized)
    
    tryCatch({
      graphChange <- input$plotMapDraw_graphChange
  
      # Add / reset 'hasChanged' variable that is used to keep track of what 
      # has been modified during drawing
      addLogCol <- function(df, column_name) {
        if (nrow(df) == 0) {
          # Add an empty column of logical type
          df[[column_name]] <- logical()
        } else {
          # Add a column filled with FALSE
          df[[column_name]] <- FALSE
        }
        
        return(df)
      }
      rv$dataDraw$nodes <- addLogCol(rv$dataDraw$nodes, "hasChanged")
      rv$dataDraw$edges <- addLogCol(rv$dataDraw$edges, "hasChanged")
  
      # Add unique index
      thisLabel = graphChange$name
      if (graphChange$cmd %in% c("addNode", "editNode")) {
        thisLabel <- checkLabel(newLabel = thisLabel, 
                                currentLabels = rv$dataDraw$nodes[ ! rv$dataDraw$nodes$id == graphChange$id, "label"])
      }
      
      # Set min / max values
      thisSize <- pmin(pmax(graphChange$size, 1), 100)
      thisWidth <- pmin(pmax(graphChange$width, 1), 10)
      thisArrowheads <- pmin(pmax(graphChange$arrowheads, 0), 2)
      thisColoring <- graphChange$coloring
      
      # If a node was added
      if (graphChange$cmd == "addNode") {
        rv$dataDraw$nodes <- rv$dataDraw$nodes %>%
          bind_rows(data.frame(id = graphChange$id,
                               label = thisLabel,
                               size = thisSize,
                               color.background = graphChange$coloring,
                               hasChanged = TRUE))
        
      # If an edge was added
      } else if (graphChange$cmd == "addEdge") {
        rv$dataDraw$edges <- rv$dataDraw$edges %>%
          bind_rows(data.frame(id = graphChange$id,
                               fromLabel = rv$dataDraw$nodes[rv$dataDraw$nodes$id == graphChange$from, "label"][[1]],
                               label = "",
                               toLabel = rv$dataDraw$nodes[rv$dataDraw$nodes$id == graphChange$to, "label"][[1]],
                               hasChanged = TRUE))
      # If a node was edited
      } else if (graphChange$cmd == "editNode") {
        rv$dataDraw$nodes <- rv$dataDraw$nodes %>%
          mutate(label = ifelse(id == graphChange$id, thisLabel, label),
                 color.background = ifelse(id == graphChange$id,  graphChange$coloring, color.background),
                 size = ifelse(id == graphChange$id,  thisSize, size),
                 hasChanged = ifelse(id == graphChange$id,  TRUE, FALSE))
        
        rv$dataDraw$edges <- rv$dataDraw$edges %>%
          mutate(fromLabel = as.character(ifelse(from == graphChange$id, thisLabel, fromLabel)),
                 toLabel = as.character(ifelse(to == graphChange$id, thisLabel, toLabel)))
        
      # If an edge was edited
      } else if (graphChange$cmd == "editEdge") {
        rv$dataDraw$edges <- rv$dataDraw$edges %>%
          mutate(label = ifelse(id == graphChange$id, thisLabel, label),
                 arrowheads = ifelse(id == graphChange$id, thisArrowheads, arrowheads),
                 width =  ifelse(id == graphChange$id, thisWidth, width),
                 color.color = ifelse(id == graphChange$id, graphChange$coloring, color.color),
                 hasChanged = ifelse(id == graphChange$id,  TRUE, FALSE)) 
        
      # If a node or an edge was deleted
      } else if (graphChange$cmd == "deleteElements") {
        if (length(graphChange$nodes) > 0) {
          # Remove node
          rv$dataDraw$nodes <- rv$dataDraw$nodes %>% 
            filter(id != graphChange$nodes)
          
          # Remove edges of this node
          rv$dataDraw$edges <- rv$dataDraw$edges %>% 
            filter(from != graphChange$nodes,
                   to != graphChange$nodes)
          
        } else if (length(graphChange$edges) > 0) {
          rv$dataDraw$edges <- rv$dataDraw$edges %>% 
            filter(id != graphChange$edges)
        }
        
      }
  
      # Add defaults
      rv$dataDraw <- rv$dataDraw %>%
        restructureAndFillData()
  
      # Update plot
      visNetworkProxy("plotMapDraw") %>%
        visUpdateNodes(rv$dataDraw$nodes %>%
                         select(-matches("x"), -matches("y")) %>%
                         filter(hasChanged)
        ) %>%
        visUpdateEdges(rv$dataDraw$edges %>% 
                         filter(hasChanged)
        )
      },
      error = function(e) {
        showNotification(lang$tabDraw$errorMessage, type = "error")             # Show popup
        req(FALSE)                                                              # Do not continue
      }
    )
  })

  ## Get posMapDrawCurrent / posMapDrawManual ----
  observe({
    tryCatch({
      # Positions are continuously retrieved
      invalidateLater(1000, session) 
      visNetworkProxy("plotMapDraw") %>%
        visGetPositions()
    },
    error = function(e) {
      showNotification(lang$tabDraw$errorMessage, type = "error")               # Show popup
      req(FALSE)                                                                # Do not continue
    })
  })
  
  observeEvent(c(input$plotMapDraw_positions), {
    tryCatch({
      pos <- as.data.frame(t(sapply(input$plotMapDraw_positions,unlist)))
      
      if (ncol(pos) > 0) {
        pos <- pos %>%
          rownames_to_column(var = "id") %>%
          mutate(x = ifelse(is.na(x), min(x, na.rm = TRUE), x),
                 y = ifelse(is.na(y), min(y, na.rm = TRUE), y))
      } else {
        pos <- data.frame(id = character(), x = integer(), y = integer())  
      }
      
      # Save node positions
      rv$posMapDrawCurrent <- pos
      if (input$layoutDraw == "manual") {
        rv$posMapDrawManual <- pos
      }
    },
    error = function(e) {
      showNotification(lang$tabDraw$errorMessage, type = "error")               # Show popup
      req(FALSE)                                                                # Do not continue
    })
  })

  ## Download (downloadButtonDraw) ----
  output$downloadButtonDraw <- downloadHandler(
    filename = function() { rv$files <- prepareFilenames(selection = input$downloadListDraw, comparison = FALSE, basepath = tmpDir, lang = lang)
                            basename(rv$files$returned)                         # Remove path
                          },
    content = function(file) {
      tryCatch({
        # Create temporary directory
        dir.create(tmpDir, showWarnings = FALSE, recursive = TRUE)
        
        # Prepare data
        nodes <- rv$dataDraw$nodes %>%
          mutate(x = rv$posMapDrawCurrent$x,
                 y = rv$posMapDrawCurrent$y,
                 isUnique = "no")                                               # required by saveNetworkPlot()
        edges <- rv$dataDraw$edges %>%
          mutate(isUnique = "no")                                               # required by saveNetworkPlot()
        
        # cxl
        if ("cxl" %in% names(rv$files)) {
          writeCXL(nodes = nodes, edges = edges, file = rv$files$cxl)
        }
        
        # xlsxEdgeList
        if ("xlsxEdgeList" %in% names(rv$files)) {
          writeXlsxEdgeList(nodes = nodes, edges = edges, file = rv$files$xlsxEdgeList)
        }
        
        # png
        if ("png" %in% names(rv$files)) {
          graphPlot <- saveNetworkPlot(nodes = nodes, edges = edges, file = rv$files$png)
        }
    
        # svg
        if ("svg" %in% names(rv$files)) {
          graphPlot <- saveNetworkPlot(nodes = nodes, edges = edges, file = rv$files$svg)
        }
  
        # zip
        if (length(input$downloadListDraw) > 1) {
          zip(rv$files$returned, files = unlist( rv$files[ names(rv$files)[ names(rv$files) != "returned"]] ), extras = '-j')
        }

        # Copy created file to the expected 'file' location
        file.copy(rv$files$returned, file)
      },
      error = function(e) {
        write("", file = file)                                                  # Write empty file
        showNotification(lang$download$errorMessage, type = "error")            # Show popup
        try(unlink(tmpDir, recursive = TRUE, force = TRUE), silent = TRUE)      # Remove temporary directory incl. all files.
      },
      finally = {
        try(unlink(tmpDir, recursive = TRUE, force = TRUE), silent = TRUE)      # Remove temporary directory incl. all files.
      })
    },
    contentType = NULL
  )
  
  ## Reset ----
  # Show confirmation popup
  observeEvent(c(input$resetButtonDraw), {
    req(input$resetButtonDraw)
    
    showModal(modalDialog(
      title = lang$sidebar$resetDrawing$popUpTitle,
      lang$sidebar$resetDrawing$popUpMessage,
      easyClose = FALSE,
      footer =  tagList(
        modalButton(lang$sidebar$resetDrawing$popUpButtonLabelCancel),
        actionButton("resetDrawingContinue", lang$sidebar$resetDrawing$popUpButtonLabelDelete))
    )) 

  })
  
  # "Continue" was selected in the popup
  observeEvent(c(input$resetDrawingContinue), {
    req(input$resetDrawingContinue)
    removeModal()                                                               # Close modal
    rv$dataDraw <- NULL
    rv$posMapDrawManual <- NULL
    rv$initPlotMapDraw <- rv$initPlotMapDraw + 1
  })
  
  # tabAnalyze ----
  ## Set dataRaw ----
  observeEvent(input$file1, {
    req(input$file1)

    # Show popup if multiple files are processed
    if (nrow(input$file1) > 1) {
      id <- showNotification(HTML(lang$sidebar$upload$processingMessage), type = "message", duration = 5)
    }
    
    # Read file1
    data <- readFiles(input$file1)
    
    # Check if the returned value is a filename (character)
    if (is.character(data)) {
      showNotification(paste0(lang$sidebar$upload$errorMessage, " ", data), type = "error")    # Show popup
      rv$reset <- rv$reset + 1                                                                 # Reset app
      req(FALSE)                                                                               # Do not continue
    }
    rv$dataRaw1 <- data

    # Enable button
    enable("analyzeButton")
  })

  # Upload file2
  observeEvent(input$file2, {
    # Read file2
    data <- readFiles(input$file2)
    
    # Check if the returned value is a filename (character)
    if (is.character(data)) {
      showNotification(paste0(lang$sidebar$upload$errorMessage, " ", data), type = "error")    # Show popup
      rv$reset <- rv$reset + 1                                                                 # Reset app
      req(FALSE)                                                                               # Do not continue
    }
    rv$dataRaw2 <- data
  })
  
  # Drawing as input
  observeEvent(input$sourcePrimary, {
    req(input$sourcePrimary)
    
    if (input$sourcePrimary == "file") {
      # Disable button if no file1 has been uploaded
      if (is.null(input$file1)) {
        disable("analyzeButton")
      }
    } else if (input$sourcePrimary == "drawing") {
      # Show popup if drawing has not been initialized
      if (is.null(rv$dataDraw) || ( !is.null(rv$dataDraw) && nrow(rv$dataDraw$nodes) == 0)) {
        showNotification(lang$sidebar$upload$noDrawingMessage, type = "warning")    # Show popup
        updateSelectInput(session, "sourcePrimary", selected = "file")                   # Change dropdown back to "file"
        req(FALSE)                                                                       # Do not continue    
      } 
      
      # Prepare data
      tryCatch({
        rv$dataRaw1 <- rv$dataDraw
        
        # Enforce a consistent filename. Mixing uploaded and drawn parts can lead to
        # incorrect averaging of centrality measures.
        if (nrow(rv$dataRaw1$nodes) > 0) {
          rv$dataRaw1$nodes$filename <- "Draw"
        }
        if (nrow(rv$dataRaw1$edges) > 0) {
          rv$dataRaw1$edges$filename <- "Draw"
        }
        
        # Keep manual positions
        rv$posMap1Manual <- rv$posMapDrawManual
      },
      error = function(e) {
        showNotification(paste0(lang$tabAnalyze$errorMessage, " (1)"), type = "error")          # Show popup
        rv$reset <- rv$reset + 1                                                # Reset app
        req(FALSE)                                                              # Do not continue
      })

      # Enable button
      enable("analyzeButton")
    }
  })
  
  ## Start analysis (analyzeButton) ----
  observeEvent(input$analyzeButton, {
    req(input$analyzeButton)
    req(rv$dataRaw1)

    ## Determine if Comparison Data is available
    if (!is.null(rv$dataRaw2)) {
      rv$comparisonData  <- TRUE
    } else {
      rv$comparisonData  <- FALSE
    }
    
    ## Determine if multiple Primary Files are available
    rv$multipleFiles <- ifelse(length(unique(rv$dataRaw1$nodes$filename)) > 1, TRUE, FALSE)
    if (rv$multipleFiles) {
      updateSelectInput(session, "checkEdgeLabels", selected = "no")            # Change checkEdgeLabels to "no" when multiple files were uploaded
      updateSelectInput(session, "checkEdgeDirection", selected = "no")         # Change checkEdgeDirection to "no" when multiple files were uploaded
    }
    
    ## Prepare UI 
    # Insert Sidebar UI
    visibilitySidebarUI(input = input, rv = rv)
    
    # Remove divTextNoData
    removeUI("#divTextNoData",
             immediate = TRUE)
    
    # Insert Body UI
    insertBodyUI(rv = rv, lang = lang)
    
    # Continue with analysis
    rv$startAnalysis <- rv$startAnalysis + 1
  })
  
  ## Set dataMatched ----
  observeEvent(c(rv$startAnalysis,
                 input$matchingType, input$nodesOrEdges, input$matchDistance,
                 input$checkEdgeLabels,
                 input$checkEdgeDirection), { 
    req(rv$startAnalysis > 0,
        input$matchingType, input$nodesOrEdges, input$matchDistance,
        input$checkEdgeLabels,
        input$checkEdgeDirection)       
    
    tryCatch({
     # Run in console for debugging: data1 = rv$dataRaw1; data2 = rv$dataRaw2; matchingType = input$matchingType; nodesOrEdges = input$nodesOrEdges; matchDistance = input$matchDistance; checkEdgeLabels = input$checkEdgeLabels; checkEdgeDirection = input$checkEdgeDirection
     data <- prepareDataMatched(data1 = rv$dataRaw1, data2 = rv$dataRaw2, 
                                matchingType = input$matchingType, nodesOrEdges = input$nodesOrEdges, matchDistance = input$matchDistance,
                                checkEdgeLabels = input$checkEdgeLabels,
                                checkEdgeDirection = input$checkEdgeDirection)
     
     rv$dataMatched1 <- data$data1
     rv$dataMatched2 <- data$data2
     
     # Continue with aggregation
     rv$dataMatchedAvailable <- rv$dataMatchedAvailable + 1
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (2)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  })
  
  ## Set dataAgg ----
  observeEvent(c(rv$dataMatchedAvailable), { 
    req(rv$dataMatchedAvailable != 0)
    req(rv$dataMatched1)       
  
    tryCatch({
      data <- rv$dataMatched1 %>%
        prepareDataAgg() %>%
        restructureAndFillData()
      
      # Update id's in dataMatched1
      rv$dataMatched1$nodes <- rv$dataMatched1$nodes %>%
        mutate(id = data$nodes[match(label, data$nodes$label), "id"])
      
      rv$dataMatched1$edges <- rv$dataMatched1$edges %>%
        mutate(id = data$edges[match(paste0(fromLabel, label, toLabel, arrowheads), 
                                     paste0(data$edges$fromLabel, data$edges$label, data$edges$toLabel, data$edges$arrowheads)), 
                               "id"],
               from = data$nodes[match(fromLabel, data$nodes$label), "id"],
               to = data$nodes[match(toLabel, data$nodes$label), "id"])
      
      rv$dataAgg1 <- data
      
      if (rv$comparisonData) {
        data <- rv$dataMatched2 %>%
          prepareDataAgg() %>%
          restructureAndFillData()
        
        # Update id's in dataMatched2
        rv$dataMatched2$nodes <- rv$dataMatched2$nodes %>%
          mutate(id = data$nodes[match(label, data$nodes$label), "id"])
        
        rv$dataMatched2$edges <- rv$dataMatched2$edges %>%
          mutate(id = data$edges[match(paste0(fromLabel, label, toLabel, arrowheads), 
                                       paste0(data$edges$fromLabel, data$edges$label, data$edges$toLabel, data$edges$arrowheads)), 
                                 "id"],
                 from = data$nodes[match(fromLabel, data$nodes$label), "id"],
                 to = data$nodes[match(toLabel, data$nodes$label), "id"])
        
        rv$dataAgg2 <- data
      }
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (3)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  })
  
  ## Update sliderSelectEdges ----
  observeEvent(c(rv$dataAgg1), {
    req(rv$dataAgg1)
    
    tryCatch({
      data <- rv$dataAgg1
      
      # Determine selected range in slider
      choices <- sort(unique(data$edges$n))
      nEdges <- nrow(data$edges)                                                # Number of edges
      nFiles <- length(unique(rv$dataMatched1$edges$filename))                  # Number of files
      if (nEdges > 30) {
        # If more than 30 edges are present, find the slider range that keeps the
        # average number of edges across files
        selected <- data$edges %>%
          arrange(desc(n)) %>%
          slice(1:round(nEdges / nFiles, 0)) %>% 
          summarize(min = min(n),
                    max = max(n)) %>%
          as.numeric()
      } else {
        # If 30 or less edges are present, select all arrows
        selected <- choices
      }
      
      # Update slider
      updateSliderTextInput(session = session, inputId = "sliderSelectEdges", 
                            selected = c(selected[1], selected[length(selected)]), 
                            choices = choices)
      
      # Show slider if there are common edges
      if (length(choices) > 1) {
        show("divSliderSelectEdges")
      }
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (4)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  })
  
  ## Set dataAggSel / dataMatchedSel ----
  observeEvent(c(rv$dataAgg1,
                 input$sliderSelectEdges), {
    req(rv$dataAgg1, input$sliderSelectEdges)
     
    tryCatch({
      # Find nodes / edges to keep
      data <- rv$dataAgg1
      keepEdges <- data$edges %>%
        filter((n >= input$sliderSelectEdges[1]) & (n <= input$sliderSelectEdges[2])) %>%
        select(id, from, to)
      keepNodes <- unique(c(keepEdges$from, 
                            keepEdges$to, 
                            data$nodes[data$nodes$isIsolate == "TRUE", "id"]))    # Readd isolates
      
      # Prepare dataMatchedSel
      data <- rv$dataMatched1
      data$nodes <- data$nodes %>%
        filter(id %in% keepNodes)
      
      data$edges <- data$edges %>%
        filter(id %in% keepEdges$id)
      rv$dataMatchedSel1 <- data
      
      # Prepare dataAggSel
      data <- rv$dataAgg1
      data$nodes <- data$nodes %>%
        filter(id %in% keepNodes)
      
      data$edges <- data$edges %>%
        filter(id %in% keepEdges$id)
      rv$dataAggSel1 <- data
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (5"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  })

  ## Compute centrality ----
  observeEvent(rv$dataMatchedSel1, {
    req(rv$dataAggSel1)
    
    tryCatch({
      rv$centrality1 <- computeNetworkMeasures(data = rv$dataMatchedSel1)
      if (rv$comparisonData) {
        rv$centrality2 <- computeNetworkMeasures(data = rv$dataMatched2)
      }
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (6)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  })
  
  ## Update sliderCentrality / sliderEdges ----
  observeEvent(c(rv$centrality1, input$centralityMeasure), {
    req(rv$centrality1, input$centralityMeasure)

    tryCatch({
      choices <- sort(unique(rv$centrality1[[input$centralityMeasure]]$val))
      updateSliderTextInput(session = session, inputId = "sliderCentrality1", 
                            selected = c(choices[1], choices[length(choices)]), 
                            choices = choices)
      if (length(choices) > 1) {
        show("divSliderCentrality1")
      }
      
      choices <- sort(unique(rv$dataAggSel1$edges$n))
      updateSliderTextInput(session = session, inputId = "sliderEdges1", 
                            selected = c(choices[1], choices[length(choices)]), 
                            choices = choices)
      if (length(choices) > 1) {
        show("divSliderEdges1")
      }
      
      if (rv$comparisonData) {
        choices <- sort(unique(rv$centrality2[[input$centralityMeasure]]$val))
        updateSliderTextInput(session = session, inputId = "sliderCentrality2", 
                              selected = c(choices[1], choices[length(choices)]), 
                              choices = choices)
        if (length(choices) > 1) {
          show("divSliderCentrality2")
        }
        
        choices <- sort(unique(rv$dataAgg2$edges$n))
        updateSliderTextInput(session = session, inputId = "sliderEdges2", 
                              selected = c(choices[1], choices[length(choices)]), 
                              choices = choices)
        if (length(choices) > 1) {
          show("divSliderEdges2")
        }
      }
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (7)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  }, priority = 9999)                                                           # Update sliders before plot
  
  ## Set dataMap ----
  observeEvent(c(rv$dataAggSel1), {
    req(rv$dataAggSel1)
    
    tryCatch({
      data <- rv$dataAggSel1 %>%
        restructureAndFillData() %>%
        prepareDataMap(data2 = rv$dataAgg2, 
                       centrality = rv$centrality1[[input$centralityMeasure]])
      rv$dataMap1 <- data
      
      if (rv$comparisonData) {
        data <- rv$dataAgg2 %>%
          restructureAndFillData() %>%
          prepareDataMap(data2 = rv$dataAggSel1, 
                         centrality = rv$centrality2[[input$centralityMeasure]])
        rv$dataMap2 <- data
      }
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (8)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  }) 
  
  ## Draw plotMap1 ----
  output$plotMap1 <- renderVisNetwork({
    req(rv$dataMap1)
    
    tryCatch({
      data <- rv$dataMap1
      
      # Add node positions for manual layout
      if (input$layoutAnalyze == "manual") {
        if (is.null(rv$posMap1Manual)) {
          data$nodes <- addPositions(data = data$nodes, pos = rv$posMap1Current)
        } else {
          data$nodes <- addPositions(data = data$nodes, pos = rv$posMap1Manual)
        }
      }
      
      # Plot
      networkPlot(nodes = data$nodes, edges = data$edges, 
                  layout = input$layoutAnalyze, randomSeed = input$randomSeedAnalyze, lang = lang)
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (9)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })

  }) %>%
    bindEvent(rv$dataMap1, input$layoutAnalyze, input$randomSeedAnalyze)
  
  ## Draw plotMap2 ----
  output$plotMap2 <- renderVisNetwork({
    req(rv$dataMap2)
    
    tryCatch({
      data <- rv$dataMap2
      
      # Add node positions for manual layout
      if (input$layoutAnalyze == "manual") {
        if (is.null(rv$posMap2Manual)) {
          data$nodes <- addPositions(data = data$nodes, pos = rv$posMap2Current)
        } else {
          data$nodes <- addPositions(data = data$nodes, pos = rv$posMap2Manual)
        }
      }
      
      # Plot
      networkPlot(nodes = data$nodes, edges = data$edges, 
                  layout = input$layoutAnalyze, randomSeed = input$randomSeedAnalyze, lang = lang)
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (10)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })

  }) %>%
    bindEvent(rv$dataMap2, input$layoutAnalyze, input$randomSeedAnalyze)
  
  
  ## Update plotMap1 ----
  observeEvent(c(input$sliderCentrality1,
                 input$sliderEdges1), { 
    req(rv$dataMap1,
        input$centralityMeasure,
        input$sliderCentrality1,
        input$sliderEdges1)

    tryCatch({
      data <- rv$dataMap1 
      
      # Update centrality (size)
      data <- prepareDataMap(data1 = data, data2 = rv$dataMap2, 
                             centrality = rv$centrality1[[input$centralityMeasure]]) 
      
      # Update displayed nodes / edges
      data <- prepareDataMapSel(data = data, 
                                sliderCentrality = input$sliderCentrality1,
                                sliderEdges = input$sliderEdges1) 
      
      # Update plot
      visNetworkProxy("plotMap1") %>%
        visUpdateNodes(data$nodes) %>%
        visUpdateEdges(data$edges)
      
      rv$dataMapSel1 <- data                                                    # Stored for easier export
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (11)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })

  }, priority = 8888)

  ## Update plotMap2 ----
  observeEvent(c(input$sliderCentrality2,
                 input$sliderEdges2), { 
    req(rv$dataMap2,
       input$centralityMeasure,
       input$sliderCentrality2,
       input$sliderEdges2)
                   
    tryCatch({
     
     data <- rv$dataMap2 
     
     # Update centrality (size)
     data <- prepareDataMap(data1 = data, data2 = rv$dataMap1, 
                            centrality = rv$centrality2[[input$centralityMeasure]]) 
     
     # Update displayed nodes / edges
     data <- prepareDataMapSel(data = data, 
                               sliderCentrality = input$sliderCentrality2, 
                               sliderEdges = input$sliderEdges2)
     
     # Update plot
     visNetworkProxy("plotMap2") %>%
       visUpdateNodes(data$nodes) %>%
       visUpdateEdges(data$edges)
     
     rv$dataMapSel2 <- data                                                     # Stored for easier export
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (12)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })

  })
  
  ## Get posMap1Current / posMap1Manual ----
  observe({
    tryCatch({
      # Positions are continuously retrieved
      invalidateLater(1000, session)
      visNetworkProxy("plotMap1") %>%
        visGetPositions()
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (13)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  })
  
  observeEvent(c(input$plotMap1_positions), {
    tryCatch({
      pos <- as.data.frame(t(sapply(input$plotMap1_positions,unlist))) %>%
        rownames_to_column(var = "id") %>%
        mutate(x = ifelse(is.na(x), min(x, na.rm = TRUE), x),
               y = ifelse(is.na(y), min(y, na.rm = TRUE), y))
      
      # Save node positions
      rv$posMap1Current <- pos
      if (input$layoutAnalyze == "manual") {
        rv$posMap1Manual <- pos
      }
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (14)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  })

  ## Get posMap2Current / posMap2Manual ----
  observe({
    tryCatch({
      # Positions are continuously retrieved
      invalidateLater(1000, session)
      visNetworkProxy("plotMap2") %>%
        visGetPositions()
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (15)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  })

  observeEvent(c(input$plotMap2_positions), {
    tryCatch({
      pos <- as.data.frame(t(sapply(input$plotMap2_positions,unlist))) %>%
        rownames_to_column(var = "id") %>%
        mutate(x = ifelse(is.na(x), min(x, na.rm = TRUE), x),
               y = ifelse(is.na(y), min(y, na.rm = TRUE), y))
      
      # Save node positions
      rv$posMap2Current <- pos
      if (input$layoutAnalyze == "manual") {
        rv$posMap2Manual <- pos
      }
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (16)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  })

  
  ## Show boxes ----
  observeEvent(c(rv$centrality1, rv$centrality2), {
    req(rv$centrality1)
    
    tryCatch({
      # Prepare strings for boxes
      if (is.null(rv$centrality2)) {
        nodes <- rv$centrality1$nodes
        isolates <- rv$centrality1$isolates
        edges <- rv$centrality1$edges
        density <- rv$centrality1$density
      } else {
        nodes <- paste0(rv$centrality1$nodes, " / ", rv$centrality2$nodes)
        isolates <- paste0(rv$centrality1$isolates, " / ", rv$centrality2$isolates)
        edges <- paste0(rv$centrality1$edges, " / ", rv$centrality2$edges)
        density <- paste0(rv$centrality1$density, " / ", rv$centrality2$density)
      }
      
      # Remove old boxes
      removeUI("#rowBoxes", immediate = TRUE)
      removeUI("#boxNodes", immediate = TRUE)
      removeUI("#boxIsolates", immediate = TRUE)
      removeUI("#boxEdges", immediate = TRUE)
      removeUI("#boxDensity", immediate = TRUE)
      
      # Insert new boxes
      insertUI(
        selector = "#shiny-tab-tabAnalyze",
        where = "afterBegin",
        immediate = TRUE,
        ui = fluidRow(id = "rowBoxes",
                      div(id = "boxNodes", 
                          tipify(
                            valueBox(nodes, 
                                     lang$tabAnalyze$boxNodes$title,
                                     color = "aqua", width = 3),
                            title = lang$tabAnalyze$boxNodes$tooltip, 
                            placement = "bottom"
                          )
                      ),
                      div(id = "boxIsolates", 
                          tipify(
                            valueBox(isolates, 
                                     lang$tabAnalyze$boxIsolates$title,
                                     color = "purple", width = 3),
                            title = lang$tabAnalyze$boxIsolates$tooltip, 
                            placement = "bottom"
                          )
                      ),
                      div(id = "boxEdges", 
                          tipify(
                            valueBox(edges, 
                                     lang$tabAnalyze$boxEdges$title,
                                     color = "yellow", width = 3),
                            title = lang$tabAnalyze$boxEdges$tooltip,
                            placement = "bottom"
                          )
                      ),
                      div(id = "boxDensity", 
                          tipify(
                            valueBox(density, 
                                     lang$tabAnalyze$boxDensity$title,
                                     color = "olive", width = 3),
                            title = lang$tabAnalyze$boxDensity$tooltip, 
                            placement = "bottom"
                          )
                      )
        )
      )
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (17)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })

  })
  
  ## Show tblCentrality ----
  output$tblCentrality = renderReactable({
    req(rv$dataMap1, input$centralityMeasure)
    if (rv$comparisonData) {
      req(rv$centrality2)
    }
    
    tryCatch({
      tblCentrality <- prepareTblCentrality(centrality1 = rv$centrality1, centrality2 = rv$centrality2, 
                                            centralityMeasure = input$centralityMeasure, 
                                            lang = lang, comparisonData = rv$comparisonData)
      tblCentrality$reactable
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (18)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  }) %>%
    bindEvent(rv$dataMap1)
  
  ## Show tblFile ----
  output$tblFile = renderReactable({
    req(rv$dataMap1)
    if (rv$comparisonData) {
      req(rv$dataMatched2)
    }
    
    tryCatch({
      tblFile <- prepareTblFile(data1 = rv$dataMatchedSel1, data2 = rv$dataMatched2, 
                                lang = lang, comparisonData = rv$comparisonData)
      tblFile$reactable
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (19)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  }) %>%
    bindEvent(rv$dataMap1)
  
  ## Show tblNode ----
  output$tblNode = renderReactable({
    req(rv$dataMap1)
    
    tryCatch({
      tblNode <- prepareTblNode(data = rv$dataMap1, 
                                lang = lang, comparisonData = rv$comparisonData)
      tblNode$reactable
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (20)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  }) %>%
    bindEvent(rv$dataMap1)
  
  ## Show tblEdge ----
  output$tblEdge = renderReactable({
    req(rv$dataMap1)
    
    tryCatch({
      tblEdge <- prepareTblEdge(data = rv$dataMap1, 
                                lang = lang, comparisonData = rv$comparisonData)
      tblEdge$reactable
    },
    error = function(e) {
      showNotification(paste0(lang$tabAnalyze$errorMessage, " (21)"), type = "error")            # Show popup
      rv$reset <- rv$reset + 1                                                  # Reset app
      req(FALSE)                                                                # Do not continue
    })
  }) %>%
    bindEvent(rv$dataMap1)
  
  ## Download (downloadButtonAnalyze) ----
  output$downloadButtonAnalyze <- downloadHandler(
      filename = function() { rv$files <- prepareFilenames(selection = input$downloadListAnalyze, comparison = rv$comparisonData, basepath = tmpDir, lang = lang)
                              basename(rv$files$returned)                       # Remove path
    },
    content = function(file) {   
      tryCatch({
        # Create temporary directory
        dir.create(tmpDir, showWarnings = FALSE, recursive = TRUE)
        
        # Prepare data
        nodes1 <- rv$dataMapSel1$nodes %>%
          mutate(x = rv$posMap1Current$x,
                 y = rv$posMap1Current$y)
        edges1 <- rv$dataMapSel1$edges
        
        if (rv$comparisonData) {
          nodes2 <- rv$dataMap2$nodes %>%
            mutate(x = rv$posMap2Current$x,
                   y = rv$posMap2Current$y)
          edges2 <- rv$dataMap2$edges
        }
        
        # cxl
        if ("cxl" %in% names(rv$files)) {
          writeCXL(nodes = nodes1, edges = edges1, file = rv$files$cxl)
        }
        
        if ("cxlPrimary" %in% names(rv$files)) {
          writeCXL(nodes = nodes1, edges = edges1, file = rv$files$cxlPrimary)
        }
        
        if ("cxlComparison" %in% names(rv$files)) {
          writeCXL(nodes = nodes2, edges = edges2, file = rv$files$cxlComparison)
        }
        
        # xlsx
        if ("xlsxEdgeList" %in% names(rv$files)) {
          writeXlsxEdgeList(nodes = nodes1, edges = edges1, file = rv$files$xlsxEdgeList)
        }
        
        if ("xlsxEdgeListPrimary" %in% names(rv$files)) {
          writeXlsxEdgeList(nodes = nodes1, edges = edges1, file = rv$files$xlsxEdgeListPrimary)
        }
        
        if ("xlsxEdgeListComparison" %in% names(rv$files)) {
          writeXlsxEdgeList(nodes = nodes2, edges = edges2, file = rv$files$xlsxEdgeListComparison)
        }
        
        # png
        if ("png" %in% names(rv$files)) {
          graphPlot <- saveNetworkPlot(nodes = nodes1, edges = edges1, file = rv$files$png)
        }
        
        if ("pngPrimary" %in% names(rv$files)) {
          graphPlot <- saveNetworkPlot(nodes = nodes1, edges = edges1, file = rv$files$pngPrimary)
        }
        
        if ("pngComparison" %in% names(rv$files)) {
          graphPlot <- saveNetworkPlot(nodes = nodes2, edges = edges2, file = rv$files$pngComparison)
        }
        
        # svg
        if ("svg" %in% names(rv$files)) {
          graphPlot <- saveNetworkPlot(nodes = nodes1, edges = edges1, file = rv$files$svg)
        }
        
        if ("svgPrimary" %in% names(rv$files)) {
          graphPlot <- saveNetworkPlot(nodes = nodes1, edges = edges1, file = rv$files$svgPrimary)
        }
        
        if ("svgComparison" %in% names(rv$files)) {
          graphPlot <- saveNetworkPlot(nodes = nodes2, edges = edges2, file = rv$files$svgComparison)
        }
        
        # Analyses
        if ("xlsxAnalyses" %in% names(rv$files)) {
          # Prepare tblMatched
          tblMatched1 <- prepareTblMatched(data = rv$dataMatchedSel1, lang = lang)
          
          tblMatched2 <- NULL
          if (rv$comparisonData) {
            tblMatched2 <- prepareTblMatched(data = rv$dataMatched2, lang = lang)
          }
          
          # Prepare tblBoxes
          tblBoxes <- prepareTblBoxes(centrality1 = rv$centrality1, centrality2 = rv$centrality2, 
                                      lang = lang, comparisonData = rv$comparisonData)
          
          # Prepare tblCentrality
          tblCentrality <- prepareTblCentrality(centrality1 = rv$centrality1, centrality2 = rv$centrality2, 
                                                centralityMeasure = input$centralityMeasure, lang = lang, comparisonData = rv$comparisonData)
          
          # Prepare tblFile
          tblFile <- prepareTblFile(data1 = rv$dataMatchedSel1, data2 = rv$dataMatched2, 
                                    lang = lang, comparisonData = rv$comparisonData)
          
          # Prepare tblNode
          tblNode <- prepareTblNode(data = rv$dataMap1, 
                                    lang = lang, comparisonData = rv$comparisonData)
          
          # Prepare tblEdge
          tblEdge <- prepareTblEdge(data = rv$dataMap1, 
                                    lang = lang, comparisonData = rv$comparisonData)
          
          # Prepare sheets
          x <- list("A" = tblMatched1,
                    "B" = tblMatched2,
                    "C" = tblBoxes,
                    "D" = tblCentrality$excel,
                    "E" = tblFile$excel,
                    "F" = tblNode$excel,
                    "G" = tblFile$excel)
          x <- setNames(x, c(lang$download$files$sheetPrimary,
                             lang$download$files$sheetComparison,
                             lang$download$files$sheetBoxValues,
                             lang$download$files$sheetCentrality,
                             lang$download$files$sheetFiles,
                             lang$download$files$sheetNodes,
                             lang$download$files$sheetEdges
          )
          ) 
          if ((rv$multipleFiles == FALSE) & (rv$comparisonData == FALSE)) {
            x <- x[c(1, 3, 4)]
          } else if ((rv$multipleFiles == FALSE) & (rv$comparisonData == TRUE)) {
            x <- x[c(1, 2, 3, 4)]
          } else if ((rv$multipleFiles == TRUE) & (rv$comparisonData == FALSE)) {
            x <- x[c(1, 3, 4, 5, 6, 7)]
          } else if ((rv$multipleFiles == TRUE) & (rv$comparisonData == TRUE)) {
            x <- x[c(1, 2, 3, 4, 5, 6, 7)]
          }
          
          # Write file
          write_xlsx(x, 
                     path = rv$files$xlsxAnalyses,
                     format_headers = FALSE)
        }
        
        # --- zip ---
        if (length(input$downloadListAnalyze) > 1) {
          zip(rv$files$returned, files = unlist( rv$files[ names(rv$files)[ names(rv$files) != "returned"]] ), extras = '-j')
        }
        
        
        # --- Copy created file to the expected 'file' location ---
        file.copy(rv$files$returned, file)
      },
      error = function(e) {
        write("", file = file)                                                  # Write empty file
        showNotification(lang$download$errorMessage, type = "error")            # Show popup
        try(unlink(tmpDir, recursive = TRUE, force = TRUE), silent = TRUE)      # Remove temporary directory incl. all files.
      },
      finally = {
        try(unlink(tmpDir, recursive = TRUE, force = TRUE), silent = TRUE)      # Remove temporary directory incl. all files.
      })
    },
    contentType = NULL
  )
  
  ## Change data (changeDataButton) ----
  observeEvent(input$changeDataButton, {
    req(input$changeDataButton)
    rv$reset <- rv$reset + 1
  })
  
  ## Reset ----
  observeEvent(rv$reset, {
    req(rv$reset != 0)
    
    # Reset Reactive Values
    rv$multipleFiles = NULL
    rv$comparisonData = NULL
    
    rv$initPlotMapDraw = 0
    rv$startAnalysis = 0
    rv$dataMatchedAvailable = 0
    
    rv$dataRaw1 = NULL
    rv$dataMatched1 = NULL
    rv$dataAgg1 = NULL
    rv$dataMatchedSel1 = NULL
    rv$dataAggSel1 = NULL
    rv$dataMap1 = NULL
    rv$dataMapSel1 = NULL
    
    rv$dataRaw2 = NULL
    rv$dataMatched2 = NULL
    rv$dataAgg2 = NULL
    rv$dataMap2 = NULL
    rv$dataMapSel2 = NULL
    
    rv$centrality1 = NULL
    rv$centrality2 = NULL
    
    rv$posMap1Current = NULL
    rv$posMap1Manual = NULL
    rv$posMap2Current = NULL    
    rv$posMap2Manual = NULL
    
    # Remove Sidebar UI
    removeUI("#divTitleUpload", immediate = TRUE)
    removeUI("#divFileDraw", immediate = TRUE)
    removeUI("#divSourcePrimary", immediate = TRUE)
    removeUI("#divFile1", immediate = TRUE)
    remove_shiny_inputs("file1", input)
    removeUI("#divFile2", immediate = TRUE)
    remove_shiny_inputs("file2", input)
    removeUI("#divAnalyzeFiles", immediate = TRUE)
    
    removeUI("#divTitleDisplayOptions", immediate = TRUE)
    removeUI("#divCentralityMeasure", immediate = TRUE)
    removeUI("#divCheckEdgeLabels", immediate = TRUE)
    removeUI("#divCheckEdgeDirection", immediate = TRUE)
    removeUI("#divLayoutDraw", immediate = TRUE)
    removeUI("#divLayoutAnalyze", immediate = TRUE)
    removeUI("#divRandomSeedDraw", immediate = TRUE)
    removeUI("#divRandomSeedAnalyze", immediate = TRUE)
    removeUI("#divSliderSelectEdges", immediate = TRUE)

    removeUI("#divTitleMatchingOptions", immediate = TRUE)
    removeUI("#divMatchingType", immediate = TRUE)
    removeUI("#divNodesOrEdges", immediate = TRUE)
    removeUI("#divMatchDistance", immediate = TRUE)
    removeUI("#divAnalyzeFiles", immediate = TRUE)
    removeUI("#divTitleDownload", immediate = TRUE)
    
    removeUI("#divDownloadListDraw", immediate = TRUE)
    removeUI("#divDownloadButtonDraw", immediate = TRUE)
    removeUI("#divDownloadListAnalyze", immediate = TRUE)
    removeUI("#divDownloadButtonAnalyze", immediate = TRUE)
    
    removeUI("#divTitleChangeData", immediate = TRUE)
    removeUI("#divChangeData", immediate = TRUE)
    removeUI("#divTitleResetDraw", immediate = TRUE)
    removeUI("#divResetDraw", immediate = TRUE)
    removeUI("#divChangeData", immediate = TRUE)
    
    # Remove Body UI
    removeUI("#divSliderCentrality1", immediate = TRUE)
    removeUI("#divSliderEdges1", immediate = TRUE)
    removeUI("#plotMap1", immediate = TRUE)
    
    removeUI("#divSliderCentrality2", immediate = TRUE)
    removeUI("#divSliderEdges2", immediate = TRUE)
    removeUI("#plotMap2", immediate = TRUE)
    
    removeUI("#tblCentrality", immediate = TRUE)
    removeUI("#tblFile", immediate = TRUE)
    removeUI("#tblNode", immediate = TRUE)
    removeUI("#tblEdge", immediate = TRUE)
    removeUI("#rowBoxes", immediate = TRUE)
    removeUI("#row1", immediate = TRUE)
    removeUI("#row2", immediate = TRUE)
    removeUI("#divTextNoData", immediate = TRUE)
    
    # Reinitialize UI
    insertSidebarUI(session = session, lang = lang)
    visibilitySidebarUI(input = input, rv = rv)
  }, priority = 1000)
}


# ---- shinyApp ----
shinyApp(ui, server)
