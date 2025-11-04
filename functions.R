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

#' @description This function dynamically inserts UI elements into the sidebar.
#'
#' @param session shiny session object. Represents the current session, used to
#' handle server-side operations.
#' @param lang list. A language object containing text and labels.
#'
#' @return None. This function is used for its side effect of dynamically
#' modifying the sidebar UI.
#'
#' @export
insertSidebarUI <- function(session = NULL, lang = NULL) {
  #' @description This function formats a title for the sidebar.
  #'
  #' @param title character. A text string to be formatted.
  #'
  #' @return character. The formatted text.
  #'
  #' @export
  formatTitle <- function(title) {
    HTML(
      paste0(
        "<div class='form-group shiny-input-container' style='margin-bottom: 0px;'>
          <h4 style='margin-bottom: 0px;'>",
            title,
          "</h4>",
        "</div>")
    )
  }

  # divTitleUpload ----
  insertUI(
    selector = "#tabBreak",
    where = "afterEnd",
    immediate = TRUE,
    # This tipify is required at this position to make all following tooltips work
    ui = tipify(
      hidden(
        div(id ="divTitleUpload",
            formatTitle(lang$sidebar$upload$title)
        )
      ),
      title = ""
    )
  )
  
  # divFileDraw ----
  insertUI(
    selector = "#divTitleUpload",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divFileDraw", title = "",
          fileInput("fileDraw", 
                    lang$sidebar$upload$fileDraw$title, 
                    accept = c(".csv", ".txt", ".tsv", ".xlsx", ".cxl"),
                    multiple = FALSE, 
                    buttonLabel = lang$sidebar$upload$buttonLabel, 
                    placeholder = lang$sidebar$upload$placeholder))
    )
  )
  hide("fileDraw_progress")                                                     # Hide progress bar
  addTooltip(session, "divFileDraw", 
             title = lang$sidebar$upload$fileDraw$tooltip, 
             options = list(delay = list(show = 2000)))
  
  # divSourcePrimary ----
  choices <- list(A = "file", B = "drawing")
  choices <- setNames(choices, c(lang$sidebar$sourcePrimary$file,
                                 lang$sidebar$sourcePrimary$drawing))
  insertUI(
    selector = "#divFileDraw",
    where = "afterEnd",
    immediate = TRUE,
    ui = 
      hidden(
        div(id = "divSourcePrimary", 
            selectInput("sourcePrimary", 
                        lang$sidebar$sourcePrimary$title, 
                        choices = choices, 
                        selected = "file")
        )
      )
  )
  addTooltip(session, "divSourcePrimary", 
             title = lang$sidebar$sourcePrimary$tooltip, 
             placement = "right",             
             trigger = "focus",
             options = list(container = "body",
                            delay = list(show = 2000, hide = 100)))
  
  
  # divFile1 ----
  insertUI(
    selector = "#divSourcePrimary",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divFile1", title = "",
          fileInput("file1", 
                    lang$sidebar$upload$filePrimary$title, 
                    accept = c(".csv", ".txt", ".tsv", ".xlsx", ".cxl"),
                    multiple = TRUE, 
                    buttonLabel = lang$sidebar$upload$buttonLabel, 
                    placeholder = lang$sidebar$upload$placeholder))
    )
  )
  hide("file1_progress")                                                        # Hide progress bar
  addTooltip(session, "divFile1", 
             title = lang$sidebar$upload$filePrimary$tooltip, 
             options = list(delay = list(show = 2000)))
  
  # divFile2 ----
  insertUI(
    selector = "#divFile1",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divFile2", title = "",
          fileInput("file2", 
                    lang$sidebar$upload$fileComparison$title, 
                    accept = c(".csv", ".txt", ".tsv", ".xlsx", ".cxl"),
                    multiple = FALSE, 
                    buttonLabel = lang$sidebar$upload$buttonLabel, 
                    placeholder = lang$sidebar$upload$placeholder))
    )
  )
  hide("file2_progress")                                                        # Hide progress bar
  addTooltip(session, "divFile2", 
             title = lang$sidebar$upload$filePrimary$tooltip, 
             options = list(delay = list(show = 2000)))
  
  # divAnalyzeFiles ----
  insertUI(
    selector = "#divFile2",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divAnalyzeFiles", 
          style = 'margin-top:35px',
          actionButton('analyzeButton', 
                       lang$sidebar$upload$analyzeFiles$title),
      )
    )
  )
  addTooltip(session, "analyzeButton", 
             title = lang$sidebar$upload$analyzeFiles$tooltip, 
             options = list(delay = list(show = 2000)))
  disable("analyzeButton")                                                 # Disable button
  
  # divTitleDisplayOptions ----
  insertUI(
    selector = "#divAnalyzeFiles",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id ="divTitleDisplayOptions",
          formatTitle(lang$sidebar$displayOptions$title)
      )
    )
  )
  
  # divCentralityMeasure ----
  choices <- list(A = "degree", B = "betweenness", C = "closeness")
  choices <- setNames(choices, c(lang$sidebar$displayOptions$centrality$degree,
                                 lang$sidebar$displayOptions$centrality$betweenness,
                                 lang$sidebar$displayOptions$centrality$closeness))
  insertUI(
    selector = "#divTitleDisplayOptions",
    where = "afterEnd",
    immediate = TRUE,
    ui = 
      hidden(
        div(id = "divCentralityMeasure", 
            selectInput("centralityMeasure", 
                        lang$sidebar$displayOptions$centrality$title, 
                        choices = choices, 
                        selected = "degree")
        )
      )
  )
  addTooltip(session, "divCentralityMeasure", 
             title = lang$sidebar$displayOptions$centrality$tooltip, 
             placement = "right",             
             trigger = "focus",
             options = list(container = "body",
                            delay = list(show = 2000, hide = 100)))

  
  # divCheckEdgeLabels ----
  choices <- list(A = "yes", B = "no")
  choices <- setNames(choices, c(lang$sidebar$displayOptions$checkEdgeLabels$yes,
                                 lang$sidebar$displayOptions$checkEdgeLabels$no))
  
  insertUI(
    selector = "#divCentralityMeasure",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divCheckEdgeLabels",
          selectInput("checkEdgeLabels", 
                      lang$sidebar$displayOptions$checkEdgeLabels$title, 
                      choices = choices, 
                      selected = "yes")
      )
    )
  )
  addTooltip(session, "divCheckEdgeLabels", 
             title = lang$sidebar$displayOptions$checkEdgeLabels$tooltip, 
             placement = "right",             
             trigger = "focus",
             options = list(container = "body",
                            delay = list(show = 2000, hide = 100)))

  # divCheckEdgeDirection ----
  choices <- list(A = "yes", B = "no")
  choices <- setNames(choices, c(lang$sidebar$displayOptions$checkEdgeDirection$yes,
                                 lang$sidebar$displayOptions$checkEdgeDirection$no))
  
  insertUI(
    selector = "#divCheckEdgeLabels",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divCheckEdgeDirection",
          selectInput("checkEdgeDirection", 
                      lang$sidebar$displayOptions$checkEdgeDirection$title, 
                      choices = choices, 
                      selected = "yes")
      )
    )
  )
  addTooltip(session, "divCheckEdgeDirection", 
             title = lang$sidebar$displayOptions$checkEdgeDirection$tooltip, 
             placement = "right",             
             trigger = "focus",
             options = list(container = "body",
                            delay = list(show = 2000, hide = 100)))
  
  # divLayoutDraw ----
  choices <- list(A = "forceAtlas2Based", B = "layout_nicely", C = "layout_in_circle", D = "manual")
  choices <- setNames(choices, c(lang$sidebar$displayOptions$layout$forceAtlas2Based,
                                 lang$sidebar$displayOptions$layout$layout_nicely,
                                 lang$sidebar$displayOptions$layout$layout_in_circle,
                                 lang$sidebar$displayOptions$layout$manual))
  insertUI(
    selector = "#divCheckEdgeDirection",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divLayoutDraw",
          selectInput("layoutDraw",
                      lang$sidebar$displayOptions$layout$title, 
                      choices = choices,
                      selected = "manual")
          
      )
    )
  )
  addTooltip(session, "divLayoutDraw", 
             title = lang$sidebar$displayOptions$layout$tooltip, 
             placement = "right",             
             trigger = "focus",
             options = list(container = "body",
                            delay = list(show = 2000, hide = 100)))
  
  # divLayoutAnalyze----
  insertUI(
    selector = "#divLayoutDraw",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divLayoutAnalyze",
          selectInput("layoutAnalyze",
                      lang$sidebar$displayOptions$layout$title, 
                      choices = choices,
                      selected = "forceAtlas2Based")
          
      )
    )
  )
  addTooltip(session, "divLayoutAnalyze", 
             title = lang$sidebar$displayOptions$layout$tooltip, 
             placement = "right",             
             trigger = "focus",
             options = list(container = "body",
                            delay = list(show = 2000, hide = 100)))
  
  # divRandomSeedDraw ----
  insertUI(
    selector = "#divLayoutAnalyze",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divRandomSeedDraw", 
          numericInput("randomSeedDraw", 
                       lang$sidebar$displayOptions$randomSeed$title, 
                       42, min = 1, max = 100, step = 1)
      )
    )
  )
  addTooltip(session, "randomSeedDraw", 
             title = lang$sidebar$displayOptions$randomSeed$tooltip, 
             options = list(delay = list(show = 2000)))
  
  # divRandomSeedAnalyze ----
  insertUI(
    selector = "#divRandomSeedDraw",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divRandomSeedAnalyze", 
          numericInput("randomSeedAnalyze", 
                       lang$sidebar$displayOptions$randomSeed$title, 
                       42, min = 1, max = 100, step = 1)
      )
    )
  )
  addTooltip(session, "divRandomSeedAnalyze", 
             title = lang$sidebar$displayOptions$randomSeed$tooltip, 
             options = list(delay = list(show = 2000)))
  
  # divSliderSelectEdges ----
  insertUI(
    selector = "#divRandomSeedAnalyze",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divSliderSelectEdges", 
          sliderTextInput("sliderSelectEdges", 
                          label =  lang$sidebar$displayOptions$sliderSelectEdges$title,
                          choices = 1:2, 
                          selected =  1:2, 
                          width = "90%"))
    )
  )
  addTooltip(session, "divSliderSelectEdges", 
             title = lang$sidebar$displayOptions$sliderSelectEdges$tooltip,
             options = list(delay = list(show = 2000)))
  
  # divTitleMatchingOptions ----
  insertUI(
    selector = "#divSliderSelectEdges",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id ="divTitleMatchingOptions",
          formatTitle(lang$sidebar$matchingOptions$title)
      )
    )
  )
  
  # divMatchingType ----
  choices <- list(A = "exact", B = "caseInsensitive", C = "approximate")
  choices <- setNames(choices, c(lang$sidebar$matchingOptions$matchingType$exact,
                                 lang$sidebar$matchingOptions$matchingType$caseInsensitive,
                                 lang$sidebar$matchingOptions$matchingType$approximate))
  insertUI(
    selector = "#divTitleMatchingOptions",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divMatchingType",
          selectInput("matchingType", 
                      lang$sidebar$matchingOptions$matchingType$title,
                      choices = choices,
                      selected = "exact")
          
      )
    )
  )
  addTooltip(session, "divMatchingType", 
             title = lang$sidebar$matchingOptions$matchingType$tooltip, 
             placement = "right",             
             trigger = "focus",
             options = list(container = "body",
                            delay = list(show = 2000, hide = 100)))
  
  # divNodesOrEdges ----
  choices <- list(A = "nodes", B = "edges")
  choices <- setNames(choices, c(lang$sidebar$matchingOptions$nodesOrEdges$nodes,
                                 lang$sidebar$matchingOptions$nodesOrEdges$edges))
  insertUI(
    selector = "#divMatchingType",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divNodesOrEdges",
          selectInput("nodesOrEdges", "Matching Content",
                      choices = choices,
                      selected = "nodes")
      )
    )
  )
  addTooltip(session, "divNodesOrEdges", 
             title = lang$sidebar$matchingOptions$nodesOrEdges$tooltip, 
             placement = "right",             
             trigger = "focus",
             options = list(container = "body",
                            delay = list(show = 2000, hide = 100)))
  
  # divMatchDistance ----
  insertUI(
    selector = "#divNodesOrEdges",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divMatchDistance", 
          numericInput("matchDistance", 
                       lang$sidebar$matchingOptions$matchDistance$title, 
                       1, min = 1, max = 3, step = 1)
      )
    )
  )
  addTooltip(session, "divMatchDistance", 
             title = lang$sidebar$matchingOptions$matchDistance$tooltip, 
             options = list(delay = list(show = 2000)))
  
  # divTitleDownload ----
  insertUI(
    selector = "#divMatchDistance",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id ="divTitleDownload",
          formatTitle(lang$download$title)
      )
    )
  )
  
  # divDownloadListDraw ----
  choices <- list(A = "cxl", B = "xlsxEdgeList", C = "png", D = "svg")
  choices <- setNames(choices, c(lang$download$list$cxl,
                                 lang$download$list$xlsxEdgeList,
                                 lang$download$list$png,
                                 lang$download$list$svg))
  insertUI(
    selector = "#divTitleDownload",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divDownloadListDraw",
          selectInput("downloadListDraw", lang$download$list$title, multiple = TRUE,
                      choices = choices,
                      selected = "cxl")
      )
    )
  )
  addTooltip(session, "divDownloadListDraw",
             title = lang$download$list$tooltip,
             placement = "right",             
             trigger = "focus",
             options = list(container = "body",
                            delay = list(show = 2000, hide = 100)))
  
  # divDownloadButtonDraw ----
  insertUI(
    selector = "#divDownloadListDraw",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divDownloadButtonDraw",
          style="margin-left:15px;",
          downloadButton('downloadButtonDraw', 
                         lang$download$button$buttonLabel)
      )
    )
  )
  addTooltip(session, "divDownloadButtonDraw",
             title = lang$download$button$tooltip,
             options = list(delay = list(show = 2000)))
  
  # divDownloadListAnalyze ----
  choices <- list(A = "cxl", B = "xlsxEdgeList", C = "xlsxAnalyses", D = "png", E = "svg")
  choices <- setNames(choices, c(lang$download$list$cxl,
                                 lang$download$list$xlsxEdgeList,
                                 lang$download$list$xlsxAnalyses,
                                 lang$download$list$png,
                                 lang$download$list$svg))
  insertUI(
    selector = "#divDownloadButtonDraw",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divDownloadListAnalyze",
          selectInput("downloadListAnalyze", lang$download$list$title, multiple = TRUE,
                      choices = choices,
                      selected = "xlsxAnalyses")
      )
    )
  )
  addTooltip(session, "divDownloadListAnalyze",
             title = lang$download$list$tooltip,
             placement = "right",             
             trigger = "focus",
             options = list(container = "body",
                            delay = list(show = 2000, hide = 100)))
  
  # divDownloadButtonAnalyze ----
  insertUI(
    selector = "#divDownloadListAnalyze",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divDownloadButtonAnalyze",
          style="margin-left:15px;",
          downloadButton('downloadButtonAnalyze', 
                         lang$download$button$buttonLabel)
      )
    )
  )
  addTooltip(session, "divDownloadButtonAnalyze",
             title = lang$download$button$tooltip,
             options = list(delay = list(show = 2000)))
  
  
  # divTitleChangeData----
  insertUI(
    selector = "#divDownloadButtonAnalyze",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id ="divTitleChangeData",
          formatTitle(lang$sidebar$changeData$title)
      )
    )
  )
  
  # divChangeData ----
  insertUI(
    selector = "#divTitleChangeData",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divChangeData",
          actionButton('changeDataButton', 
                       lang$sidebar$changeData$buttonLabel)
      )
    )
  )
  addTooltip(session, "divChangeData", 
             title = lang$sidebar$changeData$tooltip, 
             options = list(delay = list(show = 2000)))
  
  
  # divTitleResetDraw ----
  insertUI(
    selector = "#divChangeData",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id ="divTitleResetDraw",
          style="margin-top:10px;",
          formatTitle(lang$sidebar$resetDrawing$title)
      )
    )
  )
  
  # divResetDraw ----
  insertUI(
    selector = "#divTitleResetDraw",
    where = "afterEnd",
    immediate = TRUE,
    ui = hidden(
      div(id = "divResetDraw", 
          actionButton('resetButtonDraw', 
                       lang$sidebar$resetDrawing$buttonLabel),
      )
    )
  )
  addTooltip(session, "resetButtonDraw", 
             title = lang$sidebar$resetDrawing$tooltip, 
             options = list(delay = list(show = 2000)))
  
  # divTextNoData ----
  insertUI(
    selector = "#shiny-tab-tabAnalyze",
    where = "afterBegin",
    immediate = TRUE,
    ui = 
      fluidRow(
        div(id = "divTextNoData", style = "margin-left: 20px",
            HTML(lang$tabAnalyze$noData)
        )
      )
  )
}

#' @description This function controls the visibility of various UI elements in 
#' the sidebar based on reactive inputs and session state. It hides or shows 
#' elements depending on the user's current actions / selections.
#'
#' @param session shiny session object. Represents the current session, used to
#' handle server-side operations.
#' @param input reactive input object. Contains the current values of all input
#' fields in the Shiny application.
#'
#' @return None. This function is used for its side effect of dynamically modifying
#' the visibility of sidebar UI elements.
#'
#' @export
visibilitySidebarUI <- function(input = NULL, rv = NULL) {
  # --- Ensure required inputs are available ---
  req(input$matchingType)
  req(input$sourcePrimary)
  
  # --- Hide all UI elements initially ---
  # Initially hide all the relevant UI components to ensure a clean state before 
  # selectively showing elements based on the user's current tab and inputs.
  hide("divTitleUpload")
  hide("divFileDraw")
  hide("divSourcePrimary")
  hide("divFile1")
  hide("divFile2")
  hide("divAnalyzeFiles")
  
  hide("divTitleDisplayOptions")
  hide("divCentralityMeasure")
  hide("divCheckEdgeLabels")
  hide("divCheckEdgeDirection")
  hide("divLayoutDraw")
  hide("divLayoutAnalyze")
  hide("divRandomSeedDraw")
  hide("divRandomSeedAnalyze")
  hide("divSliderSelectEdges")
  
  hide("divTitleMatchingOptions")
  hide("divMatchingType")
  hide("divNodesOrEdges")
  hide("divMatchDistance")
  
  hide("divTitleDownload")
  hide("divDownloadListDraw")
  hide("divDownloadButtonDraw")
  hide("divDownloadListAnalyze")
  hide("divDownloadButtonAnalyze")
  
  hide("divTitleResetDraw")
  hide("divResetDraw")
  hide("divTitleChangeData")
  hide("divChangeData")    
  
  # --- Show elements for the drawing tab ---
  if (input$tabs == "tabDraw") {
    show("divTitleUpload")
    show("divFileDraw")
    show("divTitleDisplayOptions")
    show("divLayoutDraw")
    
    # Show random seed control for specific layouts that require it.
    if (input$layoutDraw %in% c("forceAtlas2Based", "layout_nicely")) {
      show("divRandomSeedDraw")
    }
    
    show("divTitleDownload")
    show("divDownloadListDraw")
    show("divDownloadButtonDraw")
    show("divTitleResetDraw")
    show("divResetDraw")
  }
  
  # --- Show elements for the analysis tab ---
  if (input$tabs == "tabAnalyze") {
    # If no data has been uploaded
    if (is.null(rv$multipleFiles)) {
      show("divTitleUpload")
      show("divSourcePrimary")
      if (input$sourcePrimary == "file") {
        show("divFile1")
      }
      show("divFile2")
      show("divAnalyzeFiles")
    } 
    # If data has been uploaded
    else {
      show("divTitleDisplayOptions")
      show("divCentralityMeasure")
      show("divCheckEdgeLabels")
      show("divCheckEdgeDirection")
      show("divLayoutAnalyze")
      
      # Show random seed control for specific layouts that require it.
      if (input$layoutAnalyze %in% c("forceAtlas2Based", "layout_nicely")) {
        show("divRandomSeedAnalyze")
      }
      
      # Show sliderSelectEdges if there are common edges
      if (length(input$sliderSelectEdges) > 1) {
        show("divSliderSelectEdges")
      }
      
      # Show matching options when comparison data was uploaded.
      if (rv$comparisonData) {
        show("divTitleMatchingOptions")
        show("divMatchingType")
        if (input$matchingType == "approximate") {
          show("divNodesOrEdges")
          show("divMatchDistance")
        } 
      }
      
      show("divTitleDownload")
      show("divDownloadListAnalyze")
      show("divDownloadButtonAnalyze")
      show("divTitleChangeData")
      show("divChangeData")
    }
  }
}

#' @description This function dynamically creates and inserts various UI 
#' components into the body of the dashboard.
#'
#' @param rv reactiveValues object. Used to store and manage reactive variables,
#' in this case used to control the visibility and configuration of UI elements.
#' @param lang list. A language object containing text and labels.
#'
#' @return None. This function is used for its side effect of dynamically
#' modifying body UI elements.
#'
#' @export
insertBodyUI <- function(rv = NULL, lang = NULL) {
  # Build primary map box with centrality and edge sliders
  boxMap1 <- box(id = "boxMap1",
                 title = lang$tabAnalyze$primaryMap,
                 width = 6, style='height: calc(100vh - 460px); min-height:750px', solidHeader = TRUE,
                 div(
                   style = "display: flex; justify-content: space-between; align-items: center;",  # Flexbox for horizontal alignment
                   hidden(
                     div(id = "divSliderCentrality1", 
                         style = "width: 48%;",
                         sliderTextInput("sliderCentrality1", 
                                         label = lang$tabAnalyze$sliderCentrality$title,
                                         choices = 0:10, 
                                         selected = c(0, 10), 
                                         width = "100%"
                                         )
                         )
                   ),
                   hidden(
                     div(id = "divSliderEdges1", 
                         style = "width: 48%;",
                         sliderTextInput("sliderEdges1", 
                                         label = lang$tabAnalyze$sliderEdge$title,
                                         choices = 0:10, 
                                         selected = c(0, 10), 
                                         width = "100%"
                                         )
                         )
                   ),
                 ),
                 visNetworkOutput("plotMap1")
  )
  
  # Build comparison map box with centrality and edge sliders
  boxMap2 <- box(id = "boxMap2",
                 title = lang$tabAnalyze$comparisonMap, 
                 width = 6, style='height: calc(100vh - 460px); min-height:750px', solidHeader = TRUE,
                 hidden(
                   div(id = "divSliderCentrality2", 
                       style="display:inline-block; width: 46%",
                       sliderTextInput("sliderCentrality2", 
                                       label = lang$tabAnalyze$sliderCentrality$title,
                                       choices = 1:10, 
                                       selected = c(1, 10), 
                                       width = "90%"))
                 ),
                 hidden(
                   div(id = "divSliderEdges2", 
                       style="display:inline-block; width: 46%",
                       sliderTextInput("sliderEdges2", 
                                       label = lang$tabAnalyze$sliderEdge$title,
                                       choices = 1:10, 
                                       selected = c(1, 10), 
                                       width = "90%"))
                 ),
                 visNetworkOutput("plotMap2")
  )
  
  # Build box containing the centrality table
  boxCentrality <- box(id = "boxCentrality",
                       title = lang$tabAnalyze$tblCentrality$title, 
                       width = NULL, style='height: calc(100vh - 460px); min-height:750px', solidHeader = TRUE,
                       reactableOutput("tblCentrality")
  )
  
  # Build box with tabs without centrality table
  box3Tabs <- tabBox(
                     width = 12,
                     tabPanel(lang$tabAnalyze$tblFile$title,
                              reactableOutput("tblFile")
                     ),
                     tabPanel(lang$tabAnalyze$tblNode$title,
                              reactableOutput("tblNode")
                     ),
                     tabPanel(lang$tabAnalyze$tblEdge$title,
                              reactableOutput("tblEdge")
                     )
  )
  
  # Build box with tabs with centrality table
  box4Tabs <- tabBox(
                     width = 12,
                     tabPanel(lang$tabAnalyze$tblCentrality$title, 
                              reactableOutput("tblCentrality")
                     ),
                     tabPanel(lang$tabAnalyze$tblFile$title,
                              reactableOutput("tblFile")
                     ),
                     tabPanel(lang$tabAnalyze$tblNode$title,
                              reactableOutput("tblNode")
                     ),
                     tabPanel(lang$tabAnalyze$tblEdge$title,
                              reactableOutput("tblEdge")
                     )
  )
  
  # Combine boxes depending on whether multiple files and/or comparison data 
  # were uploaded.
  if ((rv$multipleFiles == FALSE) & (rv$comparisonData == FALSE)) {
    ui <- fluidRow(id = "row1",
                   boxMap1,
                   column(width = 6,
                          boxCentrality
                   )
    )
  } else if ((rv$multipleFiles == FALSE) & (rv$comparisonData == TRUE)) {
    ui <- tagList(
      fluidRow(id = "row1", 
               boxMap1,
               boxMap2),
      fluidRow(id = "row2",
               column(width = 12,
                      boxCentrality
               )
      )
    )
  } else if ((rv$multipleFiles == TRUE) & (rv$comparisonData == FALSE)) {
    ui <- tagList(
      fluidRow(id = "row1",
               boxMap1,
               column(width = 6,
                      boxCentrality
               )
      ),
      fluidRow(id = "row2",
               box3Tabs
      )
    )
  } else if ((rv$multipleFiles == TRUE) & (rv$comparisonData == TRUE)) {
    ui <- tagList(
      fluidRow(id = "row1",
               boxMap1,
               boxMap2),
      fluidRow(id = "row2",
               box4Tabs
      )
    )
  }
  
  # Insert UI
  insertUI(
    selector = "#shiny-tab-tabAnalyze",
    where = "afterBegin",
    immediate = TRUE,
    ui = ui
  )
}

#' @description This function reads and aggregates multiple uploaded files of 
#' various formats (e.g., *.csv, *.tsv, *.txt, *.xlsx, *.cxl). It allows for the 
#' combination of different file types in one upload by iterating over all given 
#' files and processing them accordingly.
#'
#' @param files character vector or data.frame. A vector of file paths or a 
#' data.frame produced by `shiny::fileInput` containing the file paths and names
#' of the uploaded files.
#'
#' @return data.frame. A concatenated and cleaned dataframe with 5 columns: 
#' fromLabel, label, toLabel, arrowheads, and filename.
#'
#' @export
readFiles <- function(files) {
  # Check input
  if (is.data.frame(files)) {
    datapath <- files$datapath
    filename <- files$name
  } else {
    datapath <- files
    filename <- basename(files)
  }
  
  # Initialize dataAll
  dataAll <- NULL
  
  # Load files
  for (i in 1:length(datapath)) {
    result <- tryCatch({
      # Determine file extension
      fileExt <- tail(str_split(datapath[i], "\\.")[[1]], 1)
      
      # Load file
      # *.csv, *.tsv or *.txt
      if (fileExt %in% c("csv", "tsv", "txt")) {
        # Determine encoding
        encoding <- guess_encoding(datapath[i])[[1, "encoding"]]
        
        # Read rows into a vector
        v <- scan(file = datapath[i], what = character(),                        
                  sep = "\n", 
                  encoding = encoding)
        
        # Determine delimiter (use the one that occurs most often)
        sep <- data.frame(sep = c(",", ";", "\t"), 
                          n = c(length(grep(",", v)), length(grep(";", v)), length(grep("\t", v)))) %>%
          arrange(desc(n)) %>%
          filter(row_number() == 1) %>%
          pull(sep)
        
        # Read file
        data <- read.csv(datapath[i], 
                         sep = sep, 
                         header = FALSE, 
                         col.names = c("fromLabel", "label", "toLabel", "arrowheads"))
        
        
      # *.xlsx
      } else if (fileExt %in% c("xlsx")) {
        data <- read_xlsx(datapath[i], 
                          range = cell_cols("A:D"),
                          col_names = c("fromLabel", "label", "toLabel", "arrowheads"))
      # *.cxl
      } else if (fileExt %in% c("cxl")) {
        data <- readCXL(datapath[i])
      }
  
      # Set default structure
      data <- data %>%
        restructureAndFillData()
  
      # Add filename
      data$nodes <- data$nodes %>%
        mutate(filename = !!filename[i]) %>%
        select(filename, everything()) 
      data$edges <- data$edges %>%
        mutate(filename = !!filename[i]) %>%
        select(filename, everything()) 
      
      # Append
      if (is.null(dataAll)) {
        dataAll <- data
      } else {
        dataAll$nodes <- dataAll$nodes %>%
          bind_rows(data$nodes)
        
        dataAll$edges <- dataAll$edges %>%
          bind_rows(data$edges)
      }

    }, error = function(e) {
      filename[i]                                                               # Return the problematic filename
    })
    
    if(is.character(result)){
      return(result)                                                            # Return the filename right away if error occurs
    }
  }
  
  # --- Return the final dataframe ---
  return(dataAll)
}

#' @description This function reads `.cxl` files generated by CmapTools and extracts
#' information on nodes (labels, positions, size, color) and edges (labels, arrows, 
#' width, color). Currently, only a limited set of attributes are supported. 
#' Additional attributes such as shapes and other properties saved by CmapTools 
#' are currently not supported.
#'
#' @param file character. A single file path pointing to the `.cxl` file to be read.
#'
#' @return list. A list containing two dataframes:
#' \item{nodes}{A dataframe with columns:
#'   \describe{
#'     \item{label}{Character. The label of the node.}
#'     \item{x}{Numeric. The x-coordinate position of the node.}
#'     \item{y}{Numeric. The y-coordinate position of the node.}
#'     \item{size}{Numeric. The size of the node.}
#'     \item{color.background}{Character. The background color of the node (e.g. "#00FF00").}
#'   }
#' }
#' \item{edges}{A dataframe with columns:
#'   \describe{
#'     \item{fromLabel}{Character. The label of the source node.}
#'     \item{label}{Character. The label of the edge.}
#'     \item{toLabel}{Character. The label of the target node.}
#'     \item{arrowheads}{Character. Specifies the number of arrowheads (i.e., 0, 1, 2).}
#'     \item{width}{Numeric. The width of the edge.}
#'     \item{color.color}{Character. The color of the edge  (e.g. "#00FF00").}
#'   }
#' }
#' 
#' @export
readCXL <- function(file) {
  # --- Extract data ---
  # Load files
  x <- read_xml(file)
  
  # Inspect XML structure (for debugging) 
  #xml_structure(x)
  #xml_children(x)
  #xml_ns(x) # They are namespaces which make selecting nodes more difficult
  
  # Remove namespace to simplify node selection 
  xml_ns_strip(x) 
  
  # Extract concepts
  tmp <- xml_find_all(xml_child(xml_child(x, "map"), "concept-list"), "concept")
  concepts <- data.frame(id = xml_attr(tmp, "id"), 
                         label = xml_attr(tmp, "label")
  )
  
  # Extract concept appearances
  tmp <- xml_find_all(xml_child(xml_child(x, "map"), "concept-appearance-list"), "concept-appearance")
  conceptAppearance <- data.frame(id = xml_attr(tmp, "id"), 
                                  x = xml_attr(tmp, "x"),
                                  y = xml_attr(tmp, "y"),
                                  size = xml_attr(tmp, "width"),
                                  color.background = xml_attr(tmp, "background-color")) %>%
    separate_wider_delim(color.background, delim = ",", 
                         names = c("color1", "color2", "color3"), 
                         too_many = "drop", cols_remove = FALSE) %>%
    mutate(size = as.numeric(size),
           size = case_when(
             any(size > 100) ~ rescale(size, lower = 25, upper = 100),
             TRUE ~ size                                                        # Otherwise let the original value to remain
           ),
           size = as.integer(size)
    ) %>%
    rowwise() %>%
    mutate(color.background = ifelse(is.na(color.background),
                                     NA,
                                     rgb(color1, color2, color3, maxColorValue = 255))) %>%
    select(!color1:color3)
  
  # Extract linking phrases
  tmp <- xml_find_all(xml_child(xml_child(x, "map"), "linking-phrase-list"), "linking-phrase")
  phrases <- data.frame(id = xml_attr(tmp, "id"), 
                        label = xml_attr(tmp, "label")
  )
  
  # Extract connections
  # "Connections" link a "concept" and a "phrase", and both can act as sources or targets.
  tmp <- xml_find_all(xml_child(xml_child(x, "map"), "connection-list"), "connection")
  connections <- data.frame(id = xml_attr(tmp, "id"), 
                            idFrom = xml_attr(tmp, "from-id"),
                            idTo = xml_attr(tmp, "to-id"),
                            isBidrectional = xml_attr(tmp, "isBidirectional"))

  # Extract connection appearances
  tmp <- xml_find_all(xml_child(xml_child(x, "map"), "connection-appearance-list"), "connection-appearance")
  connectionAppearance <- data.frame(id = xml_attr(tmp, "id"), 
                                     arrowhead = xml_attr(tmp, "arrowhead"),
                                     width = xml_attr(tmp, "thickness"),
                                     color.color = xml_attr(tmp, "color"))
  if (nrow(connectionAppearance) > 0) {
    connectionAppearance <- connectionAppearance %>%
      separate_wider_delim(color.color, delim = ",", 
                         names = c("color1", "color2", "color3"), 
                         too_many = "drop", cols_remove = FALSE) %>%
      mutate(width = as.numeric(width),
             width = case_when(
               any(width > 10) ~ rescale(width, lower = 1, upper = 10),
               TRUE ~ width                                                       # Otherwise let the original value to remain
             ),
             width = as.integer(width)
      ) %>%
      rowwise() %>%
      mutate(color.color = ifelse(is.na(color.color),
                                 NA,
                                 rgb(color1, color2, color3, maxColorValue = 255))) %>%
      select(!color1:color3)
  }
  
  # --- Restructure edges ---
  # Convert data from the CmapTools format to a format required by igraph and visNetwork.
  if (nrow(connections) > 0) {
    # Merge with appearance settings
    edges1 <- connections %>%
      left_join(connectionAppearance)
    
    # Determine if the source is a node or a label
    edges1 <- edges1 %>%
      mutate(start = ifelse(idFrom %in% concepts$id, "node", "label"),
             end = ifelse(idTo %in% concepts$id, "node", "label"))

    # Dataframe where the source is a node and the target is a label
    edges2 <- edges1 %>%
      filter(start == "node", end == "label") %>%
      select(idFrom, idLink = idTo, everything())
    
    # Dataframe where the source is a label and the target is a node
    edges3 <- edges1 %>%
      filter(start == "label", end == "node") %>%
      select(idLink = idFrom, idTo, everything())
    
    if (nrow(edges2) > 0) {
  
      # Match the dataframes (one having the node as source, one having the node 
      # as target) by the shared label
      edges4 <- edges2 %>%
        full_join(edges3, multiple = "all", by = "idLink")
      
      # Deal with a special case
      # In CmapTools, it is possible to have a connection such as 
      # "A <- Label -> B" where the source is always the link. These now appear as 
      # two rows with NA in idFrom. The following code combines these two rows 
      # into one.
      edges5 <- edges4 %>%     
        filter(is.na(idFrom)) %>%
        group_by(idLink) %>%
        mutate(
          # Move values within the first row (e.g. idTo -> idFrom, arrowhead.y -> arrowhead.x)
          idFrom = ifelse(is.na(idFrom) & (row_number() == 1), idTo, idFrom),
          arrowhead.x = ifelse(row_number() == 1, arrowhead.y, arrowhead.x),
          
          # Both isBidrectional.x and *.x are "true"
          isBidrectional.x = ifelse(row_number() == 1, "true", isBidrectional.x),
          isBidrectional.y = ifelse(row_number() == 1, "true", isBidrectional.y),
          
          # Move values from the second to the first row
          idTo = ifelse((row_number() == 1), lead(idTo), idTo),
          arrowhead.y = ifelse(row_number() == 1, lead(arrowhead.y), arrowhead.y)
        ) %>%
        filter(!is.na(idFrom))
      
      # Join
      if (nrow(edges5) == 0) {
        edges6 <- edges4
      } else {
        edges6 <- edges4 %>%     
          filter(!is.na(idFrom)) %>%
          bind_rows(edges5)
      }
  
      # In CmapTools, arrow visibility and directionality are separate settings, i.e.,
      # an arrow can have a direction without a visible arrowhead.
      # The following code makes decisions about how the map is actually shown in CmapTools 
      # and deals with the fact that "A - Label - B" is represented as two connections 
      # in Cmaptools that can have different arrow visibility/directionality, which contrasts 
      # with how it is represented in R/visNetwork.
      # All combinations of visibility and directionality: 
      #   expand.grid(arrowhead.x = c(FALSE, TRUE), arrowhead.y = c(FALSE, TRUE), isBidrectional.x = c(FALSE, TRUE), isBidrectional.y = c(FALSE, TRUE))
      edges7 <- edges6 %>%
        mutate(arrowhead.x = if_else(arrowhead.x == "no" | is.na(arrowhead.x), FALSE, TRUE),
               arrowhead.y = if_else(arrowhead.y == "no" | is.na(arrowhead.y), FALSE, TRUE),
               isBidrectional.x = if_else(is.na(isBidrectional.x), FALSE, TRUE),
               isBidrectional.y = if_else(is.na(isBidrectional.y), FALSE, TRUE)
        ) %>%
        mutate(arrowheads = NA,
               arrowheads = if_else((!arrowhead.x & !arrowhead.y & !isBidrectional.x & !isBidrectional.y), # FALSE FALSE FALSE FALSE
                                    0, arrowheads, missing = arrowheads),
               arrowheads = if_else((arrowhead.x & !arrowhead.y & !isBidrectional.x & !isBidrectional.y),  # TRUE FALSE FALSE FALSE
                                    0, arrowheads, missing = arrowheads),
               arrowheads = if_else((!arrowhead.x & arrowhead.y & !isBidrectional.x & !isBidrectional.y),  # FALSE TRUE FALSE FALSE 
                                    1, arrowheads, missing = arrowheads),
               arrowheads = if_else((arrowhead.x & arrowhead.y & !isBidrectional.x & !isBidrectional.y),   # TRUE TRUE FALSE FALSE
                                    1, arrowheads, missing = arrowheads),
               arrowheads = if_else((!arrowhead.x & !arrowhead.y & isBidrectional.x & !isBidrectional.y),  # FALSE FALSE TRUE FALSE
                                    0, arrowheads, missing = arrowheads),
               arrowheads = if_else((arrowhead.x & !arrowhead.y & isBidrectional.x & !isBidrectional.y),   # TRUE FALSE TRUE FALSE
                                    0, arrowheads, missing = arrowheads),
               arrowheads = if_else((!arrowhead.x & arrowhead.y & isBidrectional.x & !isBidrectional.y),   # FALSE TRUE TRUE FALSE
                                    1, arrowheads, missing = arrowheads),
               arrowheads = if_else((arrowhead.x & arrowhead.y & isBidrectional.x & !isBidrectional.y),    # TRUE TRUE TRUE FALSE
                                    1, arrowheads, missing = arrowheads),
               arrowheads = if_else((!arrowhead.x & !arrowhead.y & !isBidrectional.x & isBidrectional.y),  # FALSE FALSE FALSE TRUE
                                    0, arrowheads, missing = arrowheads),
               arrowheads = if_else((arrowhead.x & !arrowhead.y & !isBidrectional.x & isBidrectional.y),   # TRUE FALSE FALSE TRUE
                                    0, arrowheads, missing = arrowheads),
               arrowheads = if_else((!arrowhead.x & arrowhead.y & !isBidrectional.x & isBidrectional.y),   # FALSE TRUE FALSE TRUE
                                    1, arrowheads, missing = arrowheads),
               arrowheads = if_else((arrowhead.x & arrowhead.y & !isBidrectional.x & isBidrectional.y),    # TRUE TRUE FALSE TRUE
                                    1, arrowheads, missing = arrowheads),
               arrowheads = if_else((!arrowhead.x & !arrowhead.y & isBidrectional.x & isBidrectional.y),   # FALSE FALSE TRUE TRUE
                                    0, arrowheads, missing = arrowheads),
               arrowheads = if_else((arrowhead.x & !arrowhead.y & isBidrectional.x & isBidrectional.y),    # TRUE FALSE TRUE TRUE
                                    0, arrowheads, missing = arrowheads),
               arrowheads = if_else((!arrowhead.x & arrowhead.y & isBidrectional.x & isBidrectional.y),    # FALSE TRUE TRUE TRUE
                                    1, arrowheads, missing = arrowheads),
               arrowheads = if_else((arrowhead.x & arrowhead.y & isBidrectional.x & isBidrectional.y),     # TRUE TRUE TRUE TRUE
                                    2, arrowheads, missing = arrowheads)
        ) 
      
      # Add labels to the edges and clean up
      edges8 <- edges7 %>%
        mutate(width = width.x,                                                                            # Select width of first connection
               width = ifelse(is.na(width), 1, width),
               color.color = ifelse(is.na(color.color.x), color.color.y, color.color.x)) %>%
        select(idFrom, idLink, idTo, arrowheads, width, color.color)
    } else {
      edges8 <- data.frame(idFrom = character(),
                           idLink = character(),
                           idTo = character(),
                           arrowheads = numeric(),
                           width = numeric(),
                           color.color = character())
    }
    
    # Dataframe where the source is a node and the target is a node
    edges9 <- edges1 %>%
      filter(start == "node", end == "node") %>%
      mutate(idLink = "",
             arrowhead = if_else(arrowhead == "no" | is.na(arrowhead), FALSE, TRUE),
             isBidrectional = if_else(is.na(isBidrectional), FALSE, TRUE),
             arrowheads = case_when(!arrowhead & !isBidrectional ~ 0,
                                    arrowhead & !isBidrectional ~ 1,
                                    !arrowhead & isBidrectional ~ 0,
                                    arrowhead & isBidrectional ~ 1,
                                    .default = NA)
             ) %>%
      select(idFrom, idLink, idTo, arrowheads, width, color.color)
    
    if (nrow(edges9) == 0) {
      edges9 <- data.frame(idFrom = character(),
                           idLink = character(),
                           idTo = character(),
                           arrowheads = numeric(),
                           width = numeric(),
                           color.color = character()) 
    }
      
    # Add node and edge labels and clean up
    edges10 <- edges8 %>%
      bind_rows(edges9) %>%
      left_join(concepts %>% rename(fromLabel = label), by = c("idFrom" = "id")) %>%
      left_join(phrases, by = c("idLink" = "id")) %>%
      left_join(concepts %>% rename(toLabel = label), by = c("idTo" = "id")) %>%               # Select color of one connection
      select(idFrom, idLink, idTo, fromLabel, label, toLabel, arrowheads, width, color.color) %>%
      arrange(fromLabel, toLabel)
      
  } else {
    edges10 <- data.frame(idFrom = character(),
                          idLink = character(),
                          idTo = character(),
                          fromLabel = character(),
                          label = character(),
                          toLabel = character(),
                          arrowheads = numeric(),
                          width = numeric(),
                          color.color = character())
  }
  
  # --- Restructure nodes ---
  # Extract unique nodes from the edges and merge with appearance data
  nodes <- edges10 %>%
    select(idFrom, idTo) %>%
    pivot_longer(everything(), names_to = NULL, values_to = "id") %>%
    drop_na() %>%
    distinct() %>% 
    full_join(concepts) %>%
    left_join(conceptAppearance) %>%
    select(label, x, y, size, color.background)
  
  # --- Restructure edges ---
  edges <- edges10 %>%
    select(fromLabel, label, toLabel, arrowheads, width, color.color)
  
  # --- Return the final dataframes ---
  # Return a list containing the processed nodes and edges dataframes
  return(list(nodes = nodes, edges = edges))
}


#' @description This function writes a `.cxl` file in a format compatible with CmapTools, using 
#' information on nodes (labels, positions, size, color) and edges (labels, arrows, width, color). 
#' The function exports the network data into the XML structure required by CmapTools, with support 
#' for a limited set of attributes. Additional attributes such as shapes and other properties saved 
#' by CmapTools are currently not supported.
#' 
#' @param nodes dataframe. A dataframe containing nodes with their properties.
#' @param edges dataframe. A dataframe containing edges with their properties.
#' @param file character. The output file path where the `.cxl` file will be saved.
#'
#' @return None. This function writes the formatted XML content directly to a specified file.
#'
#' @export
writeCXL <- function(nodes = NULL, edges = NULL, file = NULL) {
  # Initialize the XML document and add root elements
  doc <- xml_new_document()
  root <- xml_add_child(doc, "cmap")
  map <- xml_add_child(root, "map")

  # Prepare nodes
  if (nrow(nodes) > 0) {
    nodes <- nodes %>%
      mutate(x = x - min(nodes$x) + 250,
             y = y - min(nodes$y) + 250,
             size = rescale(as.integer(size), 25, 50)) %>%
      rowwise() %>%
      mutate(color.background = str_replace(color.background, fixed("rgba(0,0,0,0)"), "#97c2fc"),
             color.background = str_c(str_c(col2rgb(color.background), collapse = ","), ",255")
             
      )
  }
  
  # Prepare phrases
  if (nrow(edges) > 0) {
    phrases <- edges %>%
      select(id, from, label, to, fromLabel, toLabel) %>%
      left_join(nodes %>%
                  select(id, xFrom = x, yFrom = y),
                by = c("from" = "id")) %>%
      left_join(nodes %>%
                  select(id, xTo = x, yTo = y),
                by = c("to" = "id")) %>%
      mutate(x = as.integer((xFrom + xTo) / 2),
             y = as.integer((yFrom + yTo) / 2)) %>%
      filter(label != "") # Remove empty labels
  }
  
  # Prepare connections
  if (nrow(edges) > 0) {
    connections <- edges %>%
      # connection from node to edge
      filter(label != "") %>%
      select(from, to = id, arrowheads, width, color.color) %>%
      mutate(from2 = from,
             from = if_else(arrowheads == 2, to, from2),
             to = if_else(arrowheads == 2, from2, to)) %>%                      # Switch source and target for 'from' arrows
      select(-from2) %>%
      # connection from edge to node
      bind_rows(edges %>%
                  filter(label != "") %>%
                  select(from = id, to, arrowheads, width, color.color)
                ) %>%
      # connection from node to node (no label)
      bind_rows(edges %>%
                  filter(label == "") %>%
                  select(from, to, arrowheads, width, color.color)
                ) %>%
      mutate(id = 1:n(),
             arrows = if_else(arrowheads > 0, "if-to-concept", "no", missing = "no")) %>%
      rowwise() %>%
      mutate(color.color = str_replace(color.color, fixed("rgba(0,0,0,0)"), "#97c2fc"),
             color.color = str_c(str_c(col2rgb(color.color), collapse = ","), ",255")
             
      ) %>%
      select(id, from, to, everything())
  }

  # Add child nodes
  if (nrow(nodes) > 0) {
    concept_list_node <- xml_add_child(map, "concept-list")
    concept_appearance_list_node <- xml_add_child(map, "concept-appearance-list")
  }
  if (nrow(phrases) > 0) {
    linking_phrase_list_node <- xml_add_child(map, "linking-phrase-list")
    linking_phrase_appearance_list_node <- xml_add_child(map, "linking-phrase-appearance-list")
  }
  if (nrow(edges) > 0) {
    connection_list_node <- xml_add_child(map, "connection-list")
    connection_appearance_list_node <- xml_add_child(map, "connection-appearance-list")
  }
  
  # Add concepts
  if (nrow(nodes) > 0) {
    for (i in 1:nrow(nodes)) {
      xml_add_child(concept_list_node, "concept", 
                    id = as.character(nodes$id[i]), 
                    label = as.character(nodes$label[i]))
    }
  }
  
  # Add concept appearances
  if (nrow(nodes) > 0) {
    for (i in 1:nrow(nodes)) {
      xml_add_child(concept_appearance_list_node, "concept-appearance", 
                    id = as.character(nodes$id[i]), 
                    x = as.character(nodes$x[i]), 
                    y = as.character(nodes$y[i]), 
                    width = as.character(nodes$size[i]),
                    height = as.character(nodes$size[i]),
                    "min-width" = as.character(nodes$size[i]),
                    #"min-height" = as.character(nodes$size[i]),                 
                    "background-color" = as.character(nodes$color.background[i]),
                    "border-color" = as.character(nodes$color.background[i]),
                    "border-shape" = "oval")
    }
  }
  
  # Add linking phrases
  if (nrow(phrases) > 0) {
    for (i in 1:nrow(phrases)) {
      xml_add_child(linking_phrase_list_node, "linking-phrase", 
                    id = as.character(phrases$id[i]), 
                    label = as.character(phrases$label[i]))
    }
  }
  
  # Add connections
  if (nrow(edges) > 0) {
    for (i in 1:nrow(connections)) {
      xml_add_child(connection_list_node, "connection", 
                    id = as.character(connections$id[i]), 
                    "from-id" = as.character(connections$from[i]),
                    "to-id" = as.character(connections$to[i]))
    }
  }

  # Add linking phrase appearance
  if (nrow(phrases) > 0) {
    for (i in 1:nrow(phrases)) {
      xml_add_child(linking_phrase_appearance_list_node, "linking-phrase-appearance", 
                    id = as.character(phrases$id[i]),
                    x = as.character(phrases$x[i]),
                    y = as.character(phrases$y[i]))
      
    }
  }
  
  # Add connection appearances
  if (nrow(edges) > 0) {
    for (i in 1:nrow(connections)) {
      xml_add_child(connection_appearance_list_node, "connection-appearance", 
                    id = as.character(connections$id[i]), 
                    arrowhead = as.character(connections$arrows[i]),
                    thickness = as.character(connections$width[i]),
                    color = as.character(connections$color.color[i])
      )
    }
  }

  # Save the XML document to a file
  write_xml(doc, file)
}

#' @description This function restructures a dataframe or a list of dataframes to ensure 
#' they have the necessary columns for node and edge visualization. It sets default 
#' values for various attributes such as positions, sizes, and colors to prepare the data 
#' for plotting or analysis. The output is always a list of dataframes.
#'
#' @param data data.frame or list. The input dataframe or a list of dataframes representing 
#' nodes or edges that may lack required columns or default values.
#'
#' @return list. A list of dataframes with added columns and default values.
#'
#' @export
restructureAndFillData <- function(data) {
  # --- Function to generate grid points for node placement ---
  # This function places nodes in a grid pattern to ensure they are evenly
  # distributed on the plot. It calculates the x and y coordinates based on the 
  # total number of nodes and the desired number of columns.
  generateGridPoints <- function(n, columns = 5) {
    rows <- ceiling(n / columns)                                                # Calculate the number of rows needed to fit all nodes
    x <- rep(1:columns, length.out = n)                                         # Repeat 1:columns to get x-coordinates for all nodes
    y <- rep(1:rows, each = columns)[1:n]                                       # Repeat 1:rows to get y-coordinates for all nodes
    
    return(data.frame(x = x, y = y))                                            # Return a dataframe with x and y positions
  }
  
  # --- Process a single dataframe or a list of dataframes ---
  # If the input is already a list
  if ("nodes" %in%  names(data) & "edges" %in%  names(data)) {
    nodes <- data$nodes
    edges <- data$edges
  # If the input is a single dataframe
  } else {
    # No rows
    if (nrow(data) == 0) {
      nodes <- data.frame(filename = character(0))
      edges <- data.frame(filename = character(0))
    # Node list
    } else if (all(is.na(data$toLabel))) {
      nodes <- data %>%
        select(label = fromLabel) %>%
        mutate(generateGridPoints(nrow(.), columns = 5) * 100)
      
      edges <- data.frame(filename = character(0))
    # Edge list
    } else {
      # Add a unique ID to isolated nodes that share the same name as connected nodes.
      # Note: The current file format does not distinguish between nodes with identical names,
      # treating them as a single node. However, for isolated nodes (those not connected to others), 
      # we assume they are distinct entities even if they share a name with a connected node.
      # To preserve these isolated nodes, we assign a unique ID rather than removing them.
      data <- data %>%
        mutate(isIsolate = ifelse(fromLabel == "" | toLabel == "", TRUE, FALSE)) %>%
        group_by(fromLabel) %>%
        mutate(i = row_number(),
               fromLabel = ifelse(i > 1 & isIsolate, paste0(fromLabel, " (", i, ")"), fromLabel)) %>%
        select(-isIsolate, -i) %>%
        ungroup()
      
      nodes <- data %>%
        select(fromLabel, toLabel) %>%
        pivot_longer(c(fromLabel, toLabel), names_to = NULL, values_to = "label") %>%
        distinct() %>% 
        filter(label !="") %>%
        filter(complete.cases(.))
      
      edges <- data %>%
        filter(!(fromLabel == "" | toLabel == ""))                              # Remove isolates
    }
  } 
  
  # --- Process nodes ---
  # Add required columns
  requiredCols <- c("filename", "id", "name", "label", "isIsolate", "size", "font.color",  "coloring", "color.background", "color.border", "color.highlight.background", "color.highlight.border")
  missingCols <- setdiff(requiredCols, names(nodes))
  nodes[missingCols] <- lapply(missingCols, function(x) {
    if (nrow(nodes) == 0) {
      return(character(0))
    } else {
      return(as.character(rep(NA, nrow(nodes))))
    }
  })
  nodes <- nodes %>%
    mutate(size = as.numeric(size))
    
  # Clean nodes
  nodes <- nodes %>%
    mutate(across(where(is.character), str_trim),                               # Remove leading and trailing whitespace
           label = gsub("???", "", label))                                      # Replace ???? which is the default by CmapTools
  
  # Add defaults
  if (nrow(nodes) > 0) { 
    nodes <- nodes %>%  
      mutate(across(c(size), ~as.numeric(.)),
             across(where(is.character), str_trim),                             # Remove leading and trailing whitespace
             filename = ifelse(is.na(filename), "unknown", filename),
             id = ifelse(is.na(id), paste0("node",  row_number()), id),
             isIsolate = ifelse(label %in% c(edges$fromLabel, edges$toLabel),   # Determine if the node is an isolate (unconnectd node)
                                FALSE, 
                                TRUE), 
             label = ifelse(is.na(label), "", label),
             label = str_wrap(label, 15),
             label = gsub("\n", "\n ", label),
             name = label,                                                      # 'name' is used as intermediate to set column 'label' in drawing
             size = ifelse(is.na(size), 25, size),                              
             font.color = "#000000",
             font.size = 10,
             color.background = ifelse(is.na(color.background), 
                                       "#97c2fc",
                                       color.background),
             color.border = color.background,
             coloring = color.background,                                       # 'coloring' is used as intermediate to set column 'color.background' in drawing
             color.highlight.background = color.background,
             color.highlight.border = "#000000",
             shape = "dot") %>%
      mutate(across(any_of(c("x", "y", "size")), ~as.numeric(.))) %>%             
      select(all_of(requiredCols), everything()) %>%
      as.data.frame()
  }
  
  # --- Process edges ---
  # Add required columns
  requiredCols <- c("filename", "id",  "from", "to", "fromLabel", "label", "toLabel", "name", "arrows", "arrowheads", "width", "font.color", "font.size", "coloring", "color.color", "color.highlight")
  missingCols <- setdiff(requiredCols, names(edges))
  edges[missingCols] <- lapply(missingCols, function(x) {
    if (nrow(edges) == 0) {
      return(character(0))
    } else {
      return(as.character(rep(NA, nrow(edges))))
    }
  })
  edges <- edges %>%
    mutate(across(c(arrowheads, width, font.size), ~as.numeric(.)))
  
  # Clean edges
  edges <- edges %>%
    mutate(across(where(is.character), str_trim),                               # Remove leading and trailing whitespace
           label = gsub("???", "", label))                                      # Replace ???? which is the default by CmapTools

  # Add defaults
  if (nrow(edges) > 0) { 
    edges <- edges %>%
      mutate(across(c(id), ~as.character(.)),
             across(c(width, arrowheads), ~as.numeric(.)), 
             across(where(is.character), str_trim),                             # Remove leading and trailing whitespace
             filename = ifelse(is.na(filename), "unknown", filename),
             id = ifelse(is.na(id), paste0("edge",  row_number()), id),
             label = ifelse(is.na(label), "", label),
             across(fromLabel:toLabel, ~str_wrap(., 15)),
             across(fromLabel:toLabel, ~gsub("\n", "\n ", .)),
             name = label,                                                      # In drawing 'name' is used as intermediate to set column 'label'
             from = nodes[match(fromLabel, nodes$label), "id"],                 # Match 'from' node IDs
             to = nodes[match(toLabel, nodes$label), "id"],                     # Match 'to' node IDs
             arrowheads = ifelse(is.na(arrowheads), 1, arrowheads),             # In drawing 'arrowheads' is used as intermediate to set column 'arrows' 
             arrows = case_match(                                               # Recode into the arrow format as required by visNetwork
               arrowheads,
               0 ~ "no",
               1 ~ "to",
               2 ~ "to;from"
             ),
             width = ifelse(is.na(width), 1, width),
             font.color = "#808080",
             font.size = 10,
             color.color = ifelse(is.na(color.color), "#808080", color.color),
             coloring = color.color,                                            # In drawing 'coloring' is used as intermediate to set column 'color.color'
             color.highlight = "#000000") %>%
      select(all_of(requiredCols), everything()) %>%
      as.data.frame()
  }
  
  # --- Return the final dataframes ---
  # Return a list containing the processed nodes and edges dataframes
  return(list(nodes = nodes, edges = edges))
}

#' @description This function matches nodes and edges from two lists of dataframes 
#' using specified matching criteria. It supports both case-insensitive matching 
#' and approximate string matching (e.g., Levenshtein distance). Values in `data1` 
#' are modified and replaced based on matches found in `data2`. Nodes and edges 
#' can be compared separately based on the provided `nodesOrEdges` argument.
#'
#' @param data1 list. A list containing two dataframes, `nodes` and `edges`.
#' @param data2 list. A list containing two dataframes, `nodes` and `edges`.
#' @param matchingType character. Specifies the type of matching to be applied. 
#' Options are 'caseInsensitive' or 'approximate'.
#' @param nodesOrEdges character. Specifies whether to match 'nodes' or 'edges' (which also matches nodes).
#' @param matchDistance numeric. The maximum string distance allowed for approximate matching (e.g., 1). 
#' Only used when `matchingType` is 'approximate'.
#' @param checkEdgeLabels character. Optional. Specifies whether edge labels should be ignored ('no').
#' @param checkEdgeDirection character. Optional. Specifies whether edge direction should be ignored ('no').
#'
#' @return list. A list containing the modified `nodes` and `edges` dataframes from `data1` 
#' with matched and replaced values from `data2`.
#'
#' @export
prepareDataMatched <- function(data1 = NULL, 
                               data2 = NULL,
                               matchingType = NULL, nodesOrEdges = NULL, matchDistance = NULL,
                               checkEdgeLabels = NULL,
                               checkEdgeDirection = NULL) {
  
  # --- Initialize data2 if it is NULL ---
  # If data2 is NULL, create an empty dataframe and apply the default structure 
  # using the restructureAndFillData function to ensure it is ready for processing.
  if (is.null(data2)) {
    data2 <- data.frame() %>%
      restructureAndFillData()
  }
  
  # --- Remove edge labels if specified ---
  # If edge labels should not be considered (checkEdgeLabels == "no"), remove
  # all labels from the edges dataframes of both datasets.
  if (checkEdgeLabels == "no") {
    data1$edges <- data1$edges %>%
      mutate(label = "")
    data2$edges <- data2$edges %>%
      mutate(label = "")
  }

  # --- Remove edge direction if checkEdgeDirection is set to 'no' ---
  # If edge directions should not be considered (checkEdgeDirection == "no"), 
  # set all arrowheads to 0 in the edges dataframes of both datasets.
  if (checkEdgeDirection == "no") {
    data1$edges <- data1$edges %>%
      mutate(arrowheads = 0)
    data2$edges <- data2$edges %>%
      mutate(arrowheads = 0)
  }
  
  # --- Perform matching based on specified type ---
  # Apply the matching process depending on the matching type specified.
  # If 'caseInsensitive', perform case-insensitive matching.
  # If 'approximate', perform approximate matching with a specified distance.
  if ((matchingType == "caseInsensitive")) {
    data1 <- caseInsensitiveMatch(data1 = data1, data2 = data2)
  } else if ((matchingType == "approximate")) {
    data1 <- approximateMatch(data1 = data1, data2 = data2, nodesOrEdges = nodesOrEdges, matchDistance = matchDistance)
  } 
  
  # --- Adjust column names for undirected arrows ---
  # For datasets with multiple filenames or if data2 is provided, ensure consistency 
  # by adjusting the 'fromLabel' and 'toLabel' columns to match "A - B" with "B - A" 
  # for undirected arrows (arrowheads == 0).
  if ((length(unique(data1$edges$filename)) > 1) | (nrow(data2$edges) > 0)) {
    data1$edges <- data1$edges %>%
      rowwise() %>%
      mutate(fromLabel2 = ifelse(arrowheads == 0, sort(c(fromLabel, toLabel))[1], fromLabel),
             toLabel2 = ifelse(arrowheads == 0, sort(c(fromLabel, toLabel))[2], toLabel),
             from2 = ifelse(fromLabel != fromLabel2, to, from),
             to2 = ifelse(toLabel != toLabel2, from, to),
             fromLabel = fromLabel2,
             toLabel = toLabel2,
             from = from2,
             to = to2) %>%
      select(-fromLabel2, -toLabel2, from2, to2) %>%
      ungroup()
    
    data2$edges <- data2$edges %>%
      rowwise() %>%
      mutate(fromLabel2 = ifelse(arrowheads == 0, sort(c(fromLabel, toLabel))[1], fromLabel),
             toLabel2 = ifelse(arrowheads == 0, sort(c(fromLabel, toLabel))[2], toLabel),
             from2 = ifelse(fromLabel != fromLabel2, to, from),
             to2 = ifelse(toLabel != toLabel2, from, to),
             fromLabel = fromLabel2,
             toLabel = toLabel2,
             from = from2,
             to = to2) %>%
      select(-fromLabel2, -toLabel2, from2, to2) %>%
      ungroup()
  }
  
  # --- Return the final dataframes ---
  # Return a list containing the processed nodes and edges dataframes
  return(list(data1 = data1, data2 = data2))
}

#' @description This function matches nodes and edges from two dataframes using approximate 
#' string distances (currently, Levenshtein distance). Values in `data1` are replaced with matching 
#' values from `data2`. Nodes and edges are compared and replaced separately based on the specified 
#' matching type.
#'
#' @param data1 list. A list containing two dataframes, `nodes` and `edges`.
#' @param data2 list. A list containing two dataframes, `nodes` and `edges`.
#' @param nodesOrEdges character. Specifies whether to match 'nodes' or 'edges' (which also matches nodes).
#' @param matchDistance numeric. The maximum string distance allowed for approximate matching (e.g., 1).
#'
#' @return list. A list containing the modified `nodes` and `edges` dataframes from `data1` with matched and replaced values from `data2`.
#'
#' @export
approximateMatch <- function(data1 = NULL, data2 = NULL, nodesOrEdges = NULL, matchDistance = 1) {
  # --- Function to find matches between two sets of values ---
  # This helper function computes the Levenshtein distance between all 
  # combinations of values in 'values1' and 'values2' and finds matches within 
  # the specified distance.
  findMatches <- function(values1, values2) {
    # Remove NA
    values1 <- values1[!is.na(values1)]
    values2 <- values2[!is.na(values2)]
    
    # Compute distance matrix
    repl <- stringdistmatrix(values1, values2, method = "lv")                   # Compute distance between all combinations
    rownames(repl) <- values1
    colnames(repl) <- values2
    
    # Clean up distance matrix
    repl <- repl %>%
      as_tibble(repl, rownames = "A") %>%
      pivot_longer(!A, names_to = "B", values_to = "distance") %>%
      filter(distance <= matchDistance) %>%                                     # Remove all distances larger than matchDistance
      filter(distance > 0) %>%                                                  # Remove 0 distances
      filter(!is.na(distance)) %>%                                              # Remove NA
      arrange(A, distance) %>%
      group_by(A) %>%
      slice(which.min(distance))                                                # Select lowest distance for each node in A
  }
  
  ## --- Match nodes ---
  # Match nodes if 'nodes' or 'edges' is specified by 'nodesOrEdges'
  if (nodesOrEdges %in% c("nodes", "edges")) {
    # Find replacements for node labels
    repl <- findMatches(values1 = data1$nodes$label, values2 = data2$nodes$label)
    
    # Replace
    data1$nodes$label[data1$nodes$label %in% repl$A] <- repl$B[match(data1$nodes$label, repl$A, nomatch = FALSE)]
    data1$edges$fromLabel[data1$edges$fromLabel %in% repl$A] <- repl$B[match(data1$edges$fromLabel, repl$A, nomatch = FALSE)]
    data1$edges$toLabel[data1$edges$toLabel %in% repl$A] <- repl$B[match(data1$edges$toLabel, repl$A, nomatch = FALSE)]
  }
  
  ## --- Match edges ---
  # Match edges if 'edges' is specified by 'nodesOrEdges'
  if (nodesOrEdges %in% c("edges")) {
    # Find replacements for edge labels
    repl <- findMatches(values1 = unique(data1$edges$label), values2 = unique(data2$edges$label))
    
    # Replace
    data1$edges$label[data1$edges$label %in% repl$A] <- repl$B[match(data1$edges$label, repl$A, nomatch = FALSE)]
  }
  
  # --- Remove duplicated rows ---
  # Remove any duplicated rows in nodes and edges after replacement
  data1$nodes <- data1$nodes %>%
    distinct(label, .keep_all = TRUE)
  data1$edges <- data1$edges %>%
    distinct(fromLabel, label, toLabel, .keep_all = TRUE)
  
  # --- Return the matched dataframes ---
  return(data1)
}

#' @description This function matches nodes and edges from two dataframes using case-insensitive 
#' string matching. Values in `data1` are replaced with matching values from `data2`. 
#' Nodes and edges are compared and replaced separately.
#'
#' @param data1 list. A list containing two dataframes, `nodes` and `edges`.
#' @param data2 list. A list containing two dataframes, `nodes` and `edges`.
#'
#' @return list. A list containing the modified `nodes` and `edges` dataframes from `data1` with matched and replaced values from `data2`.
#'
#' @export
caseInsensitiveMatch <- function(data1 = NULL, data2 = NULL) {
  # --- Function to perform case-insensitive matching between two sets of values ---
  # This helper function finds replacements by converting both sets of values 
  # (values1 and values2 to lowercase and comparing them.
  findMatches <- function(values1, values2) {
    # Remove NA values
    values1 <- values1[!is.na(values1)]
    values2 <- values2[!is.na(values2)]
    
    # Find replacements
    repl <- data.frame(A = values1) %>%
      mutate(a = tolower(A)) %>%
      # Join values2 with lowercase conversion
      left_join(data.frame(B = values2) %>%
                  mutate(b = tolower(B)),
                by = c("a" = "b"),
                keep = TRUE) %>%
      # Keep values that do not already match with case sensitivity
      filter(A != B)
  }
  
  ## --- Match modes ---
  # Find replacements for node labels
  repl <- findMatches(values1 = data1$nodes$label, values2 = data2$nodes$label)
  
  # Replace
  data1$nodes$label[data1$nodes$label %in% repl$A] <- repl$B[match(data1$nodes$label, repl$A, nomatch = FALSE)]
  data1$edges$fromLabel[data1$edges$fromLabel %in% repl$A] <- repl$B[match(data1$edges$fromLabel, repl$A, nomatch = FALSE)]
  data1$edges$toLabel[data1$edges$toLabel %in% repl$A] <- repl$B[match(data1$edges$toLabel, repl$A, nomatch = FALSE)]
  
  ## --- Match edges ---
  # Find replacements for edge labels
  repl <- findMatches(values1 = unique(data1$edges$label), values2 = unique(data2$edges$label))
  
  # Replace
  data1$edges$label[data1$edges$label %in% repl$A] <- repl$B[match(data1$edges$label, repl$A, nomatch = FALSE)]
  
  # --- Remove duplicated rows ---
  # Remove any duplicated rows in nodes and edges after replacement
  data1$nodes <- data1$nodes %>%
    distinct(label, .keep_all = TRUE)
  data1$edges <- data1$edges %>%
    distinct(fromLabel, label, toLabel, .keep_all = TRUE)
  
  # --- Return the matched dataframes ---
  return(data1)
}

#' @description This function aggregates node and edge data from multiple files.
#'
#' @param data list. A list containing two dataframes, `nodes` and `edges`.
#'
#' @return list. A list containing two aggregated dataframes: `nodes` and `edges` (e.g., n, nTotal)
#'
#' @export
prepareDataAgg <- function(data = NULL) {
  # Aggregate nodes 
  nodesAgg <- data$nodes %>%
    group_by(label) %>%
    summarize(n = n(),                                                          # Count occurrences of each node label
      nTotal = length(unique(.$filename)),                                      # Count the number of unique filenames
      filename = paste(filename, collapse = ", ")) %>%                          # Combine all filenames into a single string
    ungroup()

  # Aggregate edges
  edgesAgg <- data$edges %>%
    distinct(filename, fromLabel, label, toLabel, .keep_all = TRUE) %>%         # Keep only unique rows per file
    group_by(fromLabel, label, toLabel) %>%
    summarize(n = n(),                                                          # Count occurrences of each edge
              nTotal = length(unique(.$filename)),                              # Count the number of unique filenames
              arrowheads = mean(arrowheads, na.rm = TRUE),                      # Calculate the average number of arrowheads
              filename = paste(filename, collapse = ", ") ) %>%                 # Combine all filenames into a single string
    mutate(arrowheads = ifelse(arrowheads %in% c(1, 2), arrowheads, 0)) %>%     # Keep arrows if all files had to same arrow type (i.e., there are no decimal digits)
    ungroup() 
  
  # Ensure correct data types if there are now edges
  if (nrow(edgesAgg) == 0) {
    edgesAgg <- edgesAgg %>%
      mutate(across(c(fromLabel, label, toLabel, filename), ~as.character(.)),
             across(c(n, nTotal, arrowheads), ~as.integer(.)))
  }
  
  # Return the aggregated dataframes
  return(list(nodes = nodesAgg, edges = edgesAgg))
}

#' @description This function computes a selection of network measures for each network file, 
#' including the number of nodes, isolates, edges, network density, diameter, and average 
#' distance. It also calculates centrality measures such as degree, betweenness, and closeness 
#' for each node. If multiple files are present, the function returns the averages of these measures across files.
#'
#' @param data list. A list containing two dataframes, `nodes` and `edges`.
#' 
#' @return list. A named list containing various network measures: 
#' \item{nodes}{Numeric. Average number of nodes with at least one connection across files.}
#' \item{isolates}{Numeric. Average number of isolated nodes across files.}
#' \item{edges}{Numeric. Average number of edges across files.}
#' \item{density}{Numeric. Average density of the network across files.}
#' \item{diameter}{Numeric. Average diameter of the network across files.}
#' \item{distance}{Numeric. Average distance between nodes across files.}
#' \item{degree}{dataframe. A dataframe with node labels and their average degree centrality across files.}
#' \item{betweenness}{dataframe. A dataframe with node labels and their average betweenness centrality across files.}
#' \item{closeness}{dataframe. A dataframe with node labels and their average closeness centrality across files.}
#'
#' @export
computeNetworkMeasures <- function(data = NULL) {
  # --- Initialize value list ---
  # Initialize a named list to store computed network measures.
  values = list(nodes = NULL,
                isolates = NULL,
                edges = NULL,
                density = NULL,
                diameter = NULL,
                distance = NULL,
                degree = NULL,
                betweenness = NULL,
                closeness= NULL)
  
  # --- Get number of files ---
  # Extract unique filenames from the edge dataframe to process each network separately.
  files <- c(unique(data$nodes$filename))
  nFiles <- length(files)
  
  # --- Compute measures for each file ---
  # Loop over each network file to compute the measures.
  for (i in 1:nFiles) {
    # Identify isolated nodes (nodes not connected to any edges).
    isolates <- data$nodes %>%
      filter(filename == files[i]) %>%
      filter(isIsolate) %>%                                                     # Select isolates
      pull(label)    
    
    # Create an igraph object from the edge list of the current file.
    graph <- data$edges %>%
      filter(filename == files[i]) %>%
      select(fromLabel, toLabel, label) %>%
      graph_from_data_frame(directed = F)
    
    # Add isolated nodes to the graph.
    graph <- graph %>%
      add_vertices(length(isolates), name = isolates)
    
    # --- Calculate graph measures ---
    # Calculate basic graph measures and append to the corresponding list elements.
    values$nodes <- c(values$nodes, sum(degree(graph)>0))
    values$isolates <- c(values$isolates, sum(degree(graph)==0))
    values$edges <- c(values$edges, round(length(E(graph)), 2))
    values$density <- c(values$density, round(edge_density(graph, loops=F), 2))
    values$diameter  <- c(values$diameter, round(diameter(graph, directed=F, weights=NA), 2))
    values$distance <- c(values$distance, round(mean_distance(graph, directed=F), 2))
    
    # --- Calculate centrality measures ---
    # Degree centrality
    val <- degree(graph, mode = "all")
    values$degree <- values$degree %>% 
      bind_rows(data.frame(label = names(val), val = val))
    
    # Betweenness centrality
    val <- betweenness(graph, directed = F)
    values$betweenness <- values$betweenness %>%
      bind_rows(data.frame(label = names(val), val = val))

    # Closeness centrality:
    val <- closeness(graph, normalized = T)
    values$closeness <- values$closeness %>%
      bind_rows(data.frame(label = names(val), val = val))
  }
  
  # --- Aggregate measures across files ---
  values$nodes <- round(mean(values$nodes), 2)
  values$isolates <- round(mean(values$isolates), 2)
  values$edges <- round(mean(values$edges), 2)
  values$density <- round(mean(values$density), 2)
  values$diameter  <- round(mean(values$diameter), 2)
  values$distance <- round(mean(values$distance), 2)
  values$degree <- values$degree %>% 
    group_by(label) %>% 
    summarize(val = round(mean(val), 2))
  values$betweenness <- values$betweenness %>% 
    group_by(label) %>% 
    summarize(val = round(mean(val), 2))
  values$closeness <- values$closeness %>% 
    group_by(label) %>% 
    summarize(val = round(mean(val), 2))
  
  # Replace NaN
  replace_nan <- function(df) {
    if (is.data.frame(df) && "val" %in% colnames(df)) {
      # Check it's a data frame with "val"
      df$val[is.nan(df$val)] <- 0
    } else if (is.numeric(df) && length(df) == 1) {
      # Handle the case where it's a single numeric value (like values$distance)
      df[is.nan(df)] <- 0
    }
    return(df)
  }
  
  for (name in names(values)) {
    values[[name]] <- replace_nan(values[[name]])
  }
  
  # --- Return the computed network measures ---
  return(values)
}

#' @description This function prepares and formats data for visualizing nodes and edges as a network. 
#' It merges centrality values, determines uniqueness of nodes and edges, and sets visual properties 
#' like color, shape, size, and labels.
#'
#' @param data1 list. A list containing two dataframes, `nodes` and `edges`.
#' @param data2 list. An optional list containing two dataframes, `nodes` and `edges`.
#' @param centrality dataframe. A dataframe with centrality measures to be merged.
#'
#' @return list. A list containing the modified `nodes` and `edges` dataframes from `data1` with additional 
#' attributes for visualization.
#'
#' @export
prepareDataMap <- function(data1 = NULL, 
                           data2 = NULL,
                           centrality = NULL) {
  
  # Initialize data2 if it is empty
  if (is.null(data2)) {
    data2 <- data.frame() %>%
      restructureAndFillData()
  }
  
  # Process nodes
  data1$nodes <- data1$nodes %>%
    select(-starts_with("size")) %>%                                                   # Remove existing size columns
    left_join(centrality %>% rename(sizeUnscaled = val)) %>%                           # Merge centrality values
    mutate(isUnique = ifelse(label %in% c(data2$nodes$label), "no", "yes"),            # Determine if the node is unique
           isUnique = ifelse(rep(nrow(data2$nodes) == 0, nrow(.)), "no", isUnique),    # Set to 'no' if no data2 available
           isUnique = factor(isUnique, levels = c("no", "yes")),        
           p = round(n/nTotal*100, 0),                                                 # Calculate percentage presence of each node
           labelStar = ifelse(isUnique == "no", label, paste0("*** ", label, " ***")), # Mark unique nodes with stars
           title = paste0("Label: ", label, " ",
                          "<br>Size (Centrality): ", 
                          ifelse(is.na(sizeUnscaled), "-", sizeUnscaled)),
           color.background = ifelse(isUnique == "yes", "orange", color.background),   # Unique nodes are orange
           color.border = color.background,                                            # Border color matches background color
           color.highlight.background = color.background,
           shape = ifelse(isUnique == "yes", "square", shape),                         # Unique nodes are squares
           size = ifelse(is.na(sizeUnscaled), "-", 10),                                # Default size if centrality is missing
           size = rescale(sizeUnscaled, 25, 50)                                        # Scale size based on centrality
    ) %>%                     
    select(label, n, p, isUnique, filename, everything()) %>%
    arrange(desc(p))
  
  # Process edges
  data1$edges <- data1$edges %>%
    mutate(isUnique = ifelse(paste0(fromLabel, label, toLabel, arrowheads) %in% 
                               paste0(data2$edges$fromLabel, data2$edges$label, data2$edges$toLabel, data2$edges$arrowheads),
                             "no", 
                             "yes"),                                                   # Determine if the edge is unique
           isUnique = ifelse(rep(nrow(data2$edges) == 0, nrow(.)), "no", isUnique),    # Set to 'no' if no data2 available
           isUnique = factor(isUnique, levels = c("no", "yes")),
           p = round(n/nTotal*100, 0),                                                 # Calculate percentage presence of each edge
           labelTableArrow = case_match(arrowheads,                                    # Define arrow labels for tables
                                        0 ~ " --- ",
                                        1 ~ " --> ",
                                        2 ~ " <-> "),
           labelTableArrowLeft = case_match(arrowheads,
                                            0 ~ " --- ",
                                            1 ~ " --- ",
                                            2 ~ " <-- "),
           labelTableArrowRight = case_match(arrowheads,
                                             0 ~ " --- ",
                                             1 ~ " --> ",
                                             2 ~ " --> "),
           labelTable = ifelse(label == "",
                               paste0(fromLabel, labelTableArrow, toLabel, ""),        # Handle cases where there is no edge label
                               paste0(fromLabel, labelTableArrowLeft, label, "", labelTableArrowRight, toLabel, "")
           ),
           labelStar = ifelse(isUnique == "yes", labelTable, paste0("*** ", labelTable, " ***")), # Mark unique edges with stars
           title = paste0("Label: ", label,
                          "<br>Thickness: ", n),
           font.color = ifelse(isUnique == "yes", "orange", "grey"),                   # Unique edges are orange
           color.color = ifelse(isUnique == "yes", "orange", "grey"),                  # Unique edges are orange
           color.highlight = ifelse(isUnique == "yes", "orange", "grey"),              # Unique edges are orange
           dashes = ifelse(isUnique == "yes", TRUE, FALSE),                            # Unique edges are dashed
           width = rescale(n, 1, 5)                                                    # Scale edge thickness
    ) %>%
    select(-labelTableArrow, -labelTableArrowLeft, -labelTableArrowRight)%>%
    select(fromLabel, label, toLabel, n, p, isUnique, filename, title, labelStar, everything()) %>%
    arrange(desc(p))
  
  # Return the modified data1
  return(data1)
}

#' @description This function filters and updates nodes and edges in the network data based on 
#' selected ranges for centrality and edge attributes. Nodes and edges outside of the specified 
#' range are hidden from the visualization.
#'
#' @param data list. A list containing two dataframes, `nodes` and `edges`.
#' @param sliderCentrality numeric vector. A numeric range vector with two elements specifying the minimum 
#' and maximum centrality values for filtering nodes.
#' @param sliderEdges numeric vector. A numeric range vector with two elements specifying the minimum 
#' and maximum number of occurences across files ('edge thickness') for filtering edges.
#'
#' @return list. The modified list of `nodes` and `edges` dataframes with updated attributes for visualization.
#'
#' @export
prepareDataMapSel <- function(data = NULL, sliderCentrality = NULL, sliderEdges = NULL) {
  # --- Update node / edge attributes based on filtered nodes defined by sliderCentrality ---
  # Filter nodes based on centrality slider range
  keep <- data$nodes %>%
    filter(((sizeUnscaled >= sliderCentrality[1]) & (sizeUnscaled <= sliderCentrality[2]))) %>%
    pull(id)
  
  # Hide nodes outside the selected centrality range
  data$nodes <- data$nodes %>%
    mutate(title = ifelse(id %in% keep, title, ""),
           font.color = ifelse(id %in% keep, font.color, 'rgba(0,0,0,0)'),
           color.background = ifelse(id %in% keep, color.background, 'rgba(0,0,0,0)'),
           color.border = ifelse(id %in% keep, color.border, 'rgba(0,0,0,0)'),
           color.highlight.background = ifelse(id %in% keep, color.highlight.background, 'rgba(0,0,0,0)'),
           color.highlight.border = ifelse(id %in% keep, color.highlight.border, 'rgba(0,0,0,0)')
           )
  
  # Hide edges of hidden nodes
  data$edges <- data$edges %>%
    mutate(title = ifelse(((from %in% keep) & (to %in% keep)),                
                          title, 
                          ""),
           font.color = ifelse(((from %in% keep) & (to %in% keep)), 
                               font.color,
                               'rgba(0,0,0,0)'),
           color.color = ifelse(((from %in% keep) & (to %in% keep)),
                                color.color, 
                                'rgba(0,0,0,0)'),
           color.highlight = ifelse(((from %in% keep) & (to %in% keep)),
                                    color.highlight, 
                                    'rgba(0,0,0,0)')
           )
  
  # --- Update edge attributes based on filtered edges defined by sliderEdges ---
  # Filter edges based on the number of occurences across files (edge thickness)
  keep <- data$edges %>%
    filter(((n >= sliderEdges[1]) & (n <= sliderEdges[2]))) %>%
    pull(id)
  
  # Hide edges outside the selected range
  data$edges <- data$edges %>%
    mutate(font.color = ifelse(id %in% keep, font.color, 'rgba(0,0,0,0)'),
           color.color = ifelse(id %in% keep, color.color, 'rgba(0,0,0,0)'),
           color.highlight = ifelse(id %in% keep, color.highlight, 'rgba(0,0,0,0)')
           ) 
  
  # Return the modified data with hidden nodes and edges
  return(data) 
}

#' @description This function prepares a table summarizing centrality measures (degree, betweenness, closeness) 
#' for nodes in a network, optionally comparing primary and comparison data. The table is formatted for 
#' visualization (reactable) and export (normal table) in different formats.
#'
#' @param centrality1 list. A list containing dataframes with centrality 
#' measures (`degree`, `betweenness`, `closeness`) for the primary data.
#' @param centrality2 list. An optional list containing dataframes with centrality 
#' measures (`degree`, `betweenness`, `closeness`) for the comparison data.
#' @param centralityMeasure character. The currently selected centrality measure to highlight in the table.
#' @param lang list. A language object containing text and labels for renaming and tooltips in the table.
#' @param comparisonData logical. Indicates whether comparison data is available and should be included in the table.
#'
#' @return list. A list containing two elements:
#' \item{excel}{A dataframe formatted for export.}
#' \item{reactable}{A reactable object formatted for display with tooltips.}
#'
#' @export
prepareTblCentrality <- function(centrality1 = NULL, centrality2 = NULL, 
                                 centralityMeasure = NULL, lang = NULL, comparisonData = NULL) {

  # Restructure primary centrality data
  tblCentrality <- centrality1$degree %>%
    mutate(measure = "degree") %>%
    bind_rows(centrality1$betweenness %>%
                mutate(measure = "betweenness")) %>%
    bind_rows(centrality1$closeness %>%
                mutate(measure = "closeness")) %>%
    as_tibble() %>%
    mutate(map = "primary")
  
  # Combine with comparison data if available
  if (comparisonData) {
    tblCentrality <- tblCentrality %>%
      bind_rows(centrality2$degree %>%
                  mutate(measure = "degree") %>%
                  bind_rows(centrality2$betweenness %>%
                              mutate(measure = "betweenness")) %>%
                  bind_rows(centrality2$closeness %>%
                              mutate(measure = "closeness")) %>%
                  as_tibble() %>%
                  mutate(map = "comparison")) %>%
      complete(label, map)                                                      # Add all missing combinations explicitly
  }
  
  # Remove invalid entries
  tblCentrality <- tblCentrality %>%
    filter(label != "NA")
  
  # Reshape table to wide format
  tblCentrality <- tblCentrality %>%
    pivot_wider(names_from = map, values_from = val)
  
  # Compute difference between primary and comparison data
  if (comparisonData) {
    tblCentrality <- tblCentrality %>%
      mutate(difference = abs(comparison - primary))
  }
  
  # Sort table entries
  tblCentrality <- tblCentrality %>%
    select(measure, label, starts_with("p"), starts_with("c"), starts_with("d")) %>%
    ungroup() %>%
    arrange(measure, desc(primary), label)
  
  # Rename measures
  tblCentrality <- tblCentrality %>%
    mutate(measure = case_match(measure,
                                "degree" ~ lang$sidebar$displayOptions$centrality[["degree"]],
                                "betweenness" ~ lang$sidebar$displayOptions$centrality[["betweenness"]],
                                "closeness" ~ lang$sidebar$displayOptions$centrality[["closeness"]]),
           measure = ifelse(measure == lang$sidebar$displayOptions$centrality[[centralityMeasure]], paste0(measure, " (selected)"), measure)) %>%
    select(measure, everything())
  
  # Rename table columns
  if (comparisonData) {
    cols <- c(lang$tabAnalyze$tblCentrality$measure, 
              lang$tabAnalyze$tblCentrality$node,
              lang$tabAnalyze$tblCentrality$primary, 
              lang$tabAnalyze$tblCentrality$comparison, 
              lang$tabAnalyze$tblCentrality$difference)
  } else {
    cols <- c(lang$tabAnalyze$tblCentrality$measure,
              lang$tabAnalyze$tblCentrality$node,
              lang$tabAnalyze$tblCentrality$primary)
  }
  tblCentrality <- tblCentrality %>%
    rename_with(.fn = ~cols)
  
  # Prepare tooltips
  tooltipList <- list(A = lang$tabAnalyze$tblCentrality$tooltipPrimary,
                      B = lang$tabAnalyze$tblCentrality$tooltipComparison,
                      C = lang$tabAnalyze$tblCentrality$tooltipDifference
  )
  colsTooltips <- names(tblCentrality)[3:ncol(tblCentrality)]
  tooltipList <- setNames(tooltipList, colsTooltips)
  
  # Create reactable
  tblCentralityReactable <- tblCentrality %>%
    filter(grepl("selected", .[[1]])) %>%
    select(-1) %>%
    bartable(barCols = colsTooltips, tooltipList = tooltipList)
  
  # Return the prepared tables in both formats
  return(list(excel = tblCentrality, reactable = tblCentralityReactable))
}

#' @description This function prepares a table summarizing the shared and unique nodes, 
#' isolates, and edges for each file, optionally comparing primary and comparison data. 
#' The table is formatted for visualization (reactable) and export (normal table) in different formats.
#'
#' @param data1 list. A list containing two dataframes, `nodes` and `edges`.
#' @param data2 list. An optional list containing two dataframes, `nodes` and `edges`.
#' @param lang list. A language object containing text and labels for renaming and tooltips in the table.
#' @param comparisonData logical. Indicates whether comparison data is available and should be included in the table.
#'
#' @return list. A list containing two elements:
#' \item{excel}{A dataframe formatted for export.}
#' \item{reactable}{A reactable object formatted for display with tooltips.}
#'
#' @export
prepareTblFile <- function(data1 = NULL, data2 = NULL, lang = NULL, comparisonData = NULL) {
  # Initialize comparison data if not available
  if (!comparisonData) {
    data2 <- data.frame() %>%
      restructureAndFillData()
  }
  
  data1$edges %>%
    mutate(edgeIsUnique = ifelse(paste0(fromLabel, label, toLabel, arrowheads) %in% 
                                   paste0(data2$edges$fromLabel, data2$edges$label, data2$edges$toLabel, data2$edges$arrowheads),
                                 "no", 
                                 "yes"),
           edgeIsUnique = ifelse(rep(nrow(data2$edges) == 0, nrow(.)), "no", edgeIsUnique)) %>%
    group_by(filename, edgeIsUnique) %>%
    summarize(nEdge = n()) %>%
    ungroup() %>%
    mutate(edgeIsUnique = factor(edgeIsUnique, levels = c("no", "yes"), labels = c("EdgeShared", "EdgeUnique"))) %>%
    complete(filename, edgeIsUnique) %>%
    pivot_wider(names_from = edgeIsUnique, values_from = nEdge, names_prefix = "n")
  
  # Prepare node-level summary
  nodeSummary <- data1$nodes %>%
    mutate(isIsolate = factor(isIsolate, levels = c(FALSE, TRUE), labels = c("Node", "Iso")),
           isUnique = ifelse(label %in% c(data2$nodes$label), "Shared", "Unique"),
           isUnique = factor(isUnique, levels = c("Shared", "Unique"))) %>%
    group_by(filename, isIsolate, isUnique) %>%
    summarize(nNode = n()) %>%
    ungroup() %>%
    complete(filename, isUnique, isIsolate) %>%
    pivot_wider(names_from = c(isIsolate, isUnique), values_from = nNode, names_prefix = "n", names_sep = "")
  
  # Prepare edge-level summary
  if (nrow(data1$edges) == 0) {
    # Create an empty df with the necessary columns.
    edgeSummary <- data.frame(filename = character(), nEdgeUnique = numeric(), nEdgeShared = numeric()) 
  } else {
    edgeSummary <- data1$edges %>%
      mutate(edgeIsUnique = ifelse(paste0(fromLabel, label, toLabel, arrowheads) %in% 
                                     paste0(data2$edges$fromLabel, data2$edges$label, data2$edges$toLabel, data2$edges$arrowheads),
                                   "no", 
                                   "yes"),
             edgeIsUnique = ifelse(rep(nrow(data2$edges) == 0, nrow(.)), "no", edgeIsUnique)) %>%
      group_by(filename, edgeIsUnique) %>%
      summarize(nEdge = n()) %>%
      ungroup() %>%
      mutate(edgeIsUnique = factor(edgeIsUnique, levels = c("no", "yes"), labels = c("EdgeShared", "EdgeUnique"))) %>%
      complete(filename, edgeIsUnique) %>%
      pivot_wider(names_from = edgeIsUnique, values_from = nEdge, names_prefix = "n")  
  }
  
  # Prepare table
  tblFile <- nodeSummary %>%
    left_join(edgeSummary) %>%
    ungroup() %>%
    # Compute total and percentage values
    mutate(across(everything(), ~replace_na(., 0)),
           nNodeTotal = nNodeUnique + nNodeShared,
           pNodeShared = round(nNodeShared/(nNodeTotal)*100, 0),
           nIsoTotal = nIsoUnique + nIsoShared,
           pIsoShared = round(nIsoShared/(nIsoTotal)*100, 0),
           nEdgeTotal = nEdgeUnique + nEdgeShared,
           pEdgeShared = round(nEdgeShared/(nEdgeTotal)*100, 0),
           across(everything(), ~replace_na(., 0)),
           across(where(is.numeric), ~as.double(.))
    ) %>%
    select(filename, 
           nNodeShared, nNodeUnique, nNodeTotal, pNodeShared, 
           nIsoShared, nIsoUnique, nIsoTotal, pIsoShared, 
           nEdgeShared, nEdgeUnique, nEdgeTotal, pEdgeShared) %>%
    arrange(desc(nNodeShared))
  
  # Adjust table for comparison data
  if (comparisonData) {
    tblFile <- tblFile %>%
      select(-nNodeTotal, -nIsoTotal, -nEdgeTotal)
    
    # Rename columns for export
    cols <- c(lang$tabAnalyze$tblFile$filename,
              paste0(lang$tabAnalyze$tblFile$nodes, ": ", lang$tabAnalyze$tblFile$countNodeShared),
              paste0(lang$tabAnalyze$tblFile$nodes, ": ", lang$tabAnalyze$tblFile$countNodeUnique),
              paste0(lang$tabAnalyze$tblFile$nodes, ": ", lang$tabAnalyze$tblFile$percentNodeShared),
              paste0(lang$tabAnalyze$tblFile$iso, ": ", lang$tabAnalyze$tblFile$countIsoShared),
              paste0(lang$tabAnalyze$tblFile$iso, ": ", lang$tabAnalyze$tblFile$countIsoUnique),
              paste0(lang$tabAnalyze$tblFile$iso, ": ", lang$tabAnalyze$tblFile$percentIsoShared),
              paste0(lang$tabAnalyze$tblFile$edges, ": ", lang$tabAnalyze$tblFile$countEdgeShared),
              paste0(lang$tabAnalyze$tblFile$edges, ": ", lang$tabAnalyze$tblFile$countEdgeUnique),
              paste0(lang$tabAnalyze$tblFile$edges, ": ", lang$tabAnalyze$tblFile$percentEdgeShared)
    )
    tblFile <- tblFile %>%
      rename_with(.fn = ~cols)
    
    # Rename columns for reactable
    cols <- c(lang$tabAnalyze$tblFile$filename,
              lang$tabAnalyze$tblFile$countNodeShared,
              lang$tabAnalyze$tblFile$countNodeUnique,
              lang$tabAnalyze$tblFile$percentNodeShared,
              paste0(lang$tabAnalyze$tblFile$countIsoShared, " "),              # Add whitespace to have unique names
              paste0(lang$tabAnalyze$tblFile$countIsoUnique, " "),
              paste0(lang$tabAnalyze$tblFile$percentIsoShared, " "),
              paste0(lang$tabAnalyze$tblFile$countEdgeShared, "  "),
              paste0(lang$tabAnalyze$tblFile$countEdgeUnique, "  "),
              paste0(lang$tabAnalyze$tblFile$percentEdgeShared, "  "))
    tblFileReactable <- tblFile %>%
      rename_with(.fn = ~cols)
    
    # Prepare tooltips
    tooltipList <- list(A = lang$tabAnalyze$tblFile$tooltipCountNodeShared,
                        B = lang$tabAnalyze$tblFile$tooltipCountNodeUnique,
                        C = lang$tabAnalyze$tblFile$tooltipPercentNodeShared,
                        D = lang$tabAnalyze$tblFile$tooltipCountIsoShared,
                        E = lang$tabAnalyze$tblFile$tooltipCountIsoUnique,
                        F = lang$tabAnalyze$tblFile$tooltipPercentIsoShared,
                        G = lang$tabAnalyze$tblFile$tooltipCountEdgeShared,
                        H = lang$tabAnalyze$tblFile$tooltipCountEdgeUnique,
                        I = lang$tabAnalyze$tblFile$tooltipPercentEdgeShared)
    colsTooltips <- names(tblFileReactable)[2:ncol(tblFileReactable)]
    tooltipList <- setNames(tooltipList, colsTooltips)
    
    # Prepare columns groups
    columnGroups <- list(
      colGroup(name = lang$tabAnalyze$tblFile$nodes, 
               columns = colsTooltips[1:3]),
      colGroup(name = lang$tabAnalyze$tblFile$iso, 
               columns = colsTooltips[4:6]),
      colGroup(name = lang$tabAnalyze$tblFile$edges, 
               columns = colsTooltips[7:9])
    )
    
    # Create reactable
    tblFileReactable <- tblFileReactable %>%
      bartable(barCols = colsTooltips,
               tooltipList = tooltipList, columnGroups = columnGroups)
  } else {
    tblFile <- tblFile %>%
      select(filename, nNodeTotal, nIsoTotal, nEdgeTotal)
    
    # Rename columns
    cols <- c(lang$tabAnalyze$tblFile$filename,
              lang$tabAnalyze$tblFile$countNodeTotal,
              lang$tabAnalyze$tblFile$countIsoTotal,
              lang$tabAnalyze$tblFile$countEdgeTotal)
    tblFile <- tblFile %>%
      rename_with(.fn = ~cols)
    tblFileReactable <- tblFile
    
    # Prepare tooltips
    tooltipList <- list(A = lang$tabAnalyze$tblFile$tooltipCountNodeTotal,
                        B = lang$tabAnalyze$tblFile$tooltipCountIsoTotal,
                        C = lang$tabAnalyze$tblFile$tooltipCountEdgeTotal)
    colsTooltips <- names(tblFileReactable)[2:ncol(tblFileReactable)]
    tooltipList <- setNames(tooltipList, colsTooltips)

    # Create reactable
    tblFileReactable <- tblFileReactable %>%
      bartable(barCols = colsTooltips,
               tooltipList = tooltipList)
  }
  
  # Return the prepared tables in both formats
  return(list(excel = tblFile, reactable = tblFileReactable))
}

#' @description This function prepares a table summarizing node-level information 
#' including details about shared and unique nodes and their percentages across files. 
#' The table is formatted for visualization (reactable) and export (normal table).
#'
#' @param data list. A list containing two dataframes, `nodes` and `edges`.
#' @param lang list. A language object containing text and labels for renaming and tooltips in the table.
#' @param comparisonData logical. Indicates whether comparison data is available and should be included in the table.
#'
#' @return list. A list containing two elements:
#' \item{excel}{A dataframe formatted for export.}
#' \item{reactable}{A reactable object formatted for display with tooltips.}
#'
#' @export
prepareTblNode <- function(data = NULL, lang = NULL, comparisonData = NULL) {
  # Initialize comparison data if not available
  if (!comparisonData) {
    data2 <- data.frame() %>%
      restructureAndFillData()
  }

  # Prepare table
  tblNode <- data$nodes %>%
    select(label, isUnique, p, filename)
  
  # Rename columms
  cols <- c(lang$tabAnalyze$tblNode$node,
            lang$tabAnalyze$tblNode$unique,
            lang$tabAnalyze$tblNode$percent,
            lang$tabAnalyze$tblNode$filename)
  tblNode <- tblNode %>%
    rename_with(.fn = ~cols)
  
  # Prepare tooltips
  tooltipList <- list(A = lang$tabAnalyze$tblNode$tooltipUnique,
                      B = lang$tabAnalyze$tblNode$tooltipPercent
  )
  colsTooltips <- c(lang$tabAnalyze$tblNode$unique,
                    lang$tabAnalyze$tblNode$percent)
  tooltipList <- setNames(tooltipList, colsTooltips)
  
  # Prepare which columns to hide
  # Hiding is used to display tooltips using hidden columns (e.g., filename).
  hideCols <- c(lang$tabAnalyze$tblNode$filename)
  
  # Create reactable
  if (comparisonData) {
    tblNode <- tblNode
    
    tblNodeReactable <- tblNode %>%
      bartable(barCols = lang$tabAnalyze$tblNode$percent, 
               hideCols = hideCols, 
               uniqueCol = lang$tabAnalyze$tblNode$unique,
               tooltipList = tooltipList)
    
  } else {
    # Remove isUnique column if no comparison data
    tblNode <- tblNode %>%
      select(-2)
    
    tblNodeReactable <- tblNode %>%
      bartable(barCols = lang$tabAnalyze$tblNode$percent, 
               hideCols = hideCols, 
               tooltipList = tooltipList)
  }
  
  # Return the prepared tables in both formats
  return(list(excel = tblNode, reactable = tblNodeReactable))
}

#' @description This function prepares a table summarizing edge-level information,
#' including details about source, target, label, and uniqueness. The table is 
#' formatted for visualization (reactable) and export (normal table).
#'
#' @param data list. A list containing two dataframes, `nodes` and `edges`.
#' @param lang list. A language object containing text and labels for renaming and tooltips in the table.
#' @param comparisonData logical. Indicates whether comparison data is available and should be included in the table.
#'
#' @return list. A list containing two elements:
#' \item{excel}{A dataframe formatted for export.}
#' \item{reactable}{A reactable object formatted for display with tooltips.}
#'
#' @export
prepareTblEdge <- function(data = NULL, lang = NULL, comparisonData = NULL) {
  # Prepare table
  tblEdge <- data$edges %>%
    select(fromLabel, label, toLabel, labelTable, isUnique, p, filename)
  
  # Rename columms
  cols <- c(lang$tabAnalyze$tblEdge$from,
            lang$tabAnalyze$tblEdge$label,
            lang$tabAnalyze$tblEdge$to,
            paste0(lang$tabAnalyze$tblEdge$from, " --- ", lang$tabAnalyze$tblEdge$label, " --- ", lang$tabAnalyze$tblEdge$to),
            lang$tabAnalyze$tblEdge$unique,
            lang$tabAnalyze$tblEdge$percent,
            lang$tabAnalyze$tblEdge$filename)
  tblEdge <- tblEdge %>%
    rename_with(.fn = ~cols)
  
  # Prepare tooltips
  tooltipList <- list(A = lang$tabAnalyze$tblEdge$tooltipUnique,
                      B = lang$tabAnalyze$tblEdge$tooltipPercent
  )
  colsTooltips <- c(lang$tabAnalyze$tblEdge$unique,
            lang$tabAnalyze$tblEdge$percent)
  tooltipList <- setNames(tooltipList, colsTooltips)
  
  # Prepare which columns to hide
  # Hiding is used to display tooltips using hidden columns (e.g., filename).
  hideCols <- c(lang$tabAnalyze$tblEdge$filename)
  
  # Create reactable
  if (comparisonData) {
    tblEdge <- tblEdge
    
    tblEdgeReactable <- tblEdge %>%
      bartable(barCols = lang$tabAnalyze$tblEdge$percent, 
               hideCols = hideCols, 
               uniqueCol = lang$tabAnalyze$tblEdge$unique,
               tooltipList = tooltipList)
    
  } else {
    # Remove isUnique column if no comparison data
    tblEdge <- tblEdge %>%
      select(-5)
    
    tblEdgeReactable <- tblEdge %>%
      bartable(barCols = lang$tabAnalyze$tblEdge$percent, 
               hideCols = hideCols, 
               tooltipList = tooltipList)
  }

  # Return the prepared tables in both formats
  return(list(excel = tblEdge, reactable = tblEdgeReactable))
}

#' @description This function prepares a formatted table of matched edges data. 
#' including the source, target, label, and presence of arrowheads for each edge. 
#' If no arrows are present, the arrowheads column is removed.
#'
#' @param data list. A list containing two dataframes, `nodes` and `edges`.
#' @param lang list. A language object containing text and labels for renaming in the table.
#'
#' @return dataframe. A formatted dataframe containing the matched edges data.
#'
#' @export
prepareTblMatched <- function(data = NULL, lang = NULL) {
  # Prepare table
  tblMatched <- data$edges %>%
    # Select columns
    select(fromLabel, label, toLabel, arrowheads, filename) %>%
    # Add isolates
    full_join(data$nodes %>%
                filter(isIsolate) %>%
                select(fromLabel = label, filename))

  # Rename columms
  cols <- c(lang$tabAnalyze$tblEdge$from,
            lang$tabAnalyze$tblEdge$label,
            lang$tabAnalyze$tblEdge$to,
            lang$tabAnalyze$tblEdge$arrowheads,
            lang$tabAnalyze$tblEdge$filename)
  tblMatched <- tblMatched %>%
    select(fromLabel, label, toLabel, arrowheads, filename) %>%
    rename_with(.fn = ~cols)
  
  # Remove 'Arrows' column if there are no arrows
  if (all(tblMatched[4] == 0 | is.na(tblMatched[4]))) {                                     
    tblMatched <- tblMatched[, -4]
  }
  
  # Return the prepared table
  return(tblMatched)
}

#' @description This function prepares a table summarizing key network measures 
#' (nodes, isolates, edges, density) for both the primary and comparison data, 
#' if available. The table is formatted for (reactable) and export (normal table).
#'
#' @param centrality1 list. A list containing network measures (`nodes`, `isolates`, `edges`, `density`) for the primary data.
#' @param centrality2 list. An optional list containing network measures for the comparison data.
#' @param lang list. A language object containing text and labels for renaming in the table.
#' @param comparisonData logical. Indicates whether comparison data is available and should be included in the table.
#'
#' @return dataframe. A dataframe formatted for export.
#'
#' @export
prepareTblBoxes <- function(centrality1 = NULL, centrality2 = NULL, lang = NULL, comparisonData = NULL) {
  # Prepare primary data table
  tblBoxes <- tibble(measure = names(unlist(centrality1))[1:4],
                     primary = as.numeric(unlist(centrality1)[1:4]))
  
  # Combine with comparison data if available
  if (comparisonData)  {
    tblBoxes <- tblBoxes %>%
      mutate(comparison = as.numeric(unlist(centrality2)[1:4])
      )
  }
  
  # Rename values
  tblBoxes <- tblBoxes %>%
    mutate(measure = case_match(measure,
                                "nodes" ~ lang$tabAnalyze$boxNodes$title,
                                "isolates" ~ lang$tabAnalyze$boxIsolates$title,
                                "edges" ~ lang$tabAnalyze$boxEdges$title,
                                "density" ~ lang$tabAnalyze$boxDensity$title))
  
  # Rename columms
  if (comparisonData)  {
    cols <- c(lang$tabAnalyze$tblCentrality$measure, 
              lang$tabAnalyze$tblCentrality$primary, 
              lang$tabAnalyze$tblCentrality$comparison)
  } else {
    cols <- c(lang$tabAnalyze$tblCentrality$measure, 
              lang$tabAnalyze$tblCentrality$primary)
  }
  tblBoxes <- tblBoxes %>%
    rename_with(.fn = ~cols)
  
  # Return the prepared data
  return(tblBoxes)
}

#' @description This function generates a list of filenames for downloading files from the dashboard 
#' based on the specified file formats in `selection`. It handles scenarios where files are 
#' requested individually or combined into a zip file. If `comparison` is set to TRUE, separate 
#' filenames are created for primary and comparison data.
#'
#' @param selection character vector. A vector of requested file formats (e.g., "cxl", "png", "xlsxEdgeList").
#' @param comparison logical. Indicates whether separate filenames for primary and comparison data should be created.
#' @param basepath character string. A string that will be prefixed to the generated filenames.
#' @param lang list. A language object containing text and labels used to create filenames.
#'
#' @return list. A named list of all generated filenames, with a "returned" element indicating the main file returned 
#' (either a single file or a zip file if multiple formats are requested).
#'
#' @export
prepareFilenames <- function(selection = NULL, comparison = NULL, basepath = NULL, lang = NULL) {
  # Initialize an empty list to store generated filenames
  files <- list()

  # Generate a timestamp to append to filenames
  currentTime <- format(Sys.time(), "%Y%m%d-%H%M%S")
  
  # Generate filenames when comparison data is present
  if (comparison) {
    for (i in 1:length(selection)) {
      if (selection[i] == "cxl") {
        files["cxlPrimary"] <- paste0(gsub(".cxl", "", lang$download$files$filenameCxlPrimary), "-", currentTime, ".cxl")
        files["cxlComparison"] <- paste0(gsub(".cxl", "", lang$download$files$filenameCxlComparison), "-", currentTime, ".cxl")
      } else  if (selection[i] == "xlsxEdgeList") {
        files["xlsxEdgeListPrimary"] <- paste0(gsub(".xlsx", "", lang$download$files$filenameXlsxEdgeListPrimary), "-", currentTime, ".xlsx")
        files["xlsxEdgeListComparison"] <- paste0(gsub(".xlsx", "", lang$download$files$filenameXlsxEdgeListComparison), "-", currentTime, ".xlsx")
      } else  if (selection[i] == "xlsxAnalyses") {
        files["xlsxAnalyses"] <- paste0(gsub(".xlsx", "", lang$download$files$filenameXlsxAnalyses), "-", currentTime, ".xlsx")
      } else  if (selection[i] == "png") {
        files["pngPrimary"]  <- paste0(gsub(".png", "", lang$download$files$filenamePngPrimary), "-", currentTime, ".png")
        files["pngComparison"]  <- paste0(gsub(".png", "", lang$download$files$filenamePngComparison), "-", currentTime, ".png")
      } else  if (selection[i] == "svg") {
        files["svgPrimary"] <- paste0(gsub(".svg", "", lang$download$files$filenameSvgPrimary), "-", currentTime, ".svg")
        files["svgComparison"] <- paste0(gsub(".svg", "", lang$download$files$filenameSvgComparison), "-", currentTime, ".svg")
      }
    }
  } else {
    # Generate filenames when no comparison data is present
    for (i in 1:length(selection)) {
      if (selection[i] == "cxl") {
        files["cxl"] <- paste0(gsub(".cxl", "", lang$download$files$filenameCxl), "-", currentTime, ".cxl")
      } else  if (selection[i] == "xlsxEdgeList") {
        files["xlsxEdgeList"] <- paste0(gsub(".xlsx", "", lang$download$files$filenameXlsxEdgeList), "-", currentTime, ".xlsx")
      } else  if (selection[i] == "xlsxAnalyses") {
        files["xlsxAnalyses"] <- paste0(gsub(".xlsx", "", lang$download$files$filenameXlsxAnalyses), "-", currentTime, ".xlsx")
      } else  if (selection[i] == "png") {
        files["png"]  <- paste0(gsub(".png", "", lang$download$files$filenamePng), "-", currentTime, ".png")
      } else  if (selection[i] == "svg") {
        files["svg"] <- paste0(gsub(".svg", "", lang$download$files$filenameSvg), "-", currentTime, ".svg")
      }
    }
  }

  # Determine the main file to be returned
  if (length(selection) == 1) {
    files["returned"] <- files[1]
  } else {
    files["returned"] <- paste0(lang$app$title, "-", currentTime, ".zip")
  }
  
  # Add basepath
  files <- lapply(files, function(x) file.path(basepath, x))
  
  return(files)
}

#' @description This function writes an edge list with source, target, labels, 
#' and arrowheads as columns to an Excel file (`.xlsx`).
#'
#' @param nodes dataframe. A dataframe containing nodes with their properties.
#' @param edges dataframe. A dataframe containing edges with their properties.
#' @param file character. The output file path where the Excel file will be saved.
#'
#' @return None. This function writes the formatted edge list directly to the specified Excel file.
#'
#' @export
writeXlsxEdgeList <- function(nodes = NULL, edges = NULL, file = NULL) {
  # Prepare edge list
  edgeList <- edges %>%
    select(fromLabel, label, toLabel, arrowheads) %>%
    # Add isolates
    full_join(nodes %>%
                filter(isIsolate) %>%
                select(fromLabel = label)) %>%                          
    mutate(across(where(is.character), ~na_if(., "")),
           across(everything(), ~gsub("\n", " ", .)))                           # Replace newlines
  
  # Write file
  write_xlsx(edgeList, 
             path = file,
             col_names = FALSE,
             format_headers = FALSE)
}

#' @description This function serves as a wrapper to plot networks using the visNetwork library. 
#' It handles network layout options, edge smoothing, and optional node/edge manipulation features.
#'
#' @param nodes dataframe. A dataframe of nodes structured to work with visNetwork.
#' @param edges dataframe. A dataframe of edges structured to work with visNetwork.
#' @param layout character. The network layout, either 'forceAtlas2Based' or any layout compatible 
#' with visIgraphLayout.
#' @param manipulation logical. Whether to enable interactive manipulation of nodes and edges.
#' @param randomSeed numeric. The random seed used for positioning nodes.
#'
#' @return visNetwork plot object. A network plot with specified settings.
#'
#' @export
networkPlot <- function(nodes = NULL, edges = NULL, layout = NULL, manipulation = FALSE, randomSeed = 42, lang = NULL) {
  # General setup for visNetwork plot
  p <- visNetwork(nodes = nodes, edges = edges) %>%
    visEdges(arrows = list(to = list(scaleFactor = 0.5),
                           from = list(scaleFactor = 0.5)),
             selectionWidth = 1) %>%
    visInteraction(tooltipDelay = 200, zoomSpeed = 0.5, navigationButtons = FALSE, multiselect = TRUE)
  
  # General setup for visNetwork plot
  if (layout == "forceAtlas2Based") {
    p <- p %>% 
      visLayout(randomSeed = randomSeed) %>%
      visPhysics(solver = layout, forceAtlas2Based = list(springLength = 150))
  } else if (layout == "manual") {
    p <- p %>% 
      visLayout(randomSeed = randomSeed) %>%
      visNodes(physics = FALSE)
  } else {
    p <- p %>% 
      visIgraphLayout(layout = layout, physics = F, smooth = F, randomSeed = randomSeed) 
  }
  
  # Handle manipulation options
  if (manipulation) {
    p <- p %>%
      visOptions(manipulation = list(enabled = manipulation,
                                     initiallyActive = TRUE,
                                     addNodeCols = list("text" = c("name"),
                                                        "number" = c("size"),
                                                        "color" = c("coloring")),
                                     editNodeCols = list("text" = c("name"),
                                                         "number" = c("size"),
                                                         "color" = c("coloring")),
                                     editEdgeCols = list("text" = c("name"),
                                                         "number" = c("arrowheads"),
                                                         "number" = c("width"),
                                                         "color" = c("coloring"))
      )) %>%
      visEvents(doubleClick = "function(properties) {
          // Double clicking nodes or edges open edit popup
          var network = this;
          if (properties.nodes.length === 1) {
            network.manipulation.editNode();
          } else if (properties.edges.length === 1) {
            network.manipulation.editEdgeMode();
          }
          
          // Double clicking adds node
          // if (properties.nodes.length === 0 && properties.edges.length === 0) {
          //  var newNode = {x: properties.pointer.canvas.x, y: properties.pointer.canvas.y, label: 'new'};
          //  network.body.data.nodes.add(newNode);
          //}
        }") %>%
      visEvents(
        afterDrawing = "function() {
            var network = this;
            if (!network.customKeyBindings) {
              network.customKeyBindings = true;
              
              document.addEventListener('keydown', function(e) {
                if (e.repeat) return;
                
                var activeElement = document.activeElement.tagName;
                if (activeElement === 'INPUT' || activeElement === 'TEXTAREA') return;
                
                var addNodePopUpVisible = document.getElementById('addnode-popUp') && document.getElementById('addnode-popUp').style.display === 'block';
                var editNodePopUpVisible = document.getElementById('editnode-popUp') && document.getElementById('editnode-popUp').style.display === 'block';
                var editEdgePopUpVisible = document.getElementById('editedge-popUp') && document.getElementById('editedge-popUp').style.display === 'block';
                
                // Check N, E, D keys only when no popups are visible
                if (!(addNodePopUpVisible || editNodePopUpVisible || editEdgePopUpVisible)) {
                  switch (e.code) {
                    case 'KeyN':
                      network.addNodeMode();
                      break;
                    case 'KeyE':
                      network.addEdgeMode();
                      break;
                    case 'KeyD':
                      var selectedNodes = network.getSelectedNodes();
                      var selectedEdges = network.getSelectedEdges();
                      if (selectedNodes.length > 0 || selectedEdges.length > 0) {
                        network.deleteSelected();
                      }
                      break;
                  }
                }
  
                // Check ENTER and ESC keys only when a popup is visible
                if (addNodePopUpVisible || editNodePopUpVisible || editEdgePopUpVisible) {
                  switch (e.key) {
                    case 'Enter':
                      ['addnode-saveButton', 'editnode-saveButton', 'editedge-saveButton'].forEach(function(id) {
                        var btn = document.getElementById(id);
                        console.log(btn);
                        if (btn && btn.offsetParent !== null) btn.click();
                      });
                      break;
                    case 'Escape':
                      ['addnode-cancelButton', 'editnode-cancelButton', 'editedge-cancelButton'].forEach(function(id) {
                        var btn = document.getElementById(id);
                        if (btn && btn.offsetParent !== null) btn.click();
                      });
                      break;
                  }
                }
              });
            }
          }"
      )
  } else {
    # Add node selection option
    p <- p %>%
      visOptions(nodesIdSelection = list(enabled = !manipulation, 
                                         values = sort(nodes$id),               # Alphabetical order in drop down
                                         useLabels = TRUE,
                                         main = lang$tabAnalyze$nodeSelection)) 
  }
  
  # Return the configured plot
  p
}

#' @description This function saves a network to a file in either PNG or SVG format, using 
#' Graphviz to handle the rendering. The file type is determined by the provided filename extension. 
#' The function processes node and edge data to construct a plot in the DOT language compatible with Graphviz.
#'
#' @param nodes dataframe. A dataframe containing nodes with their properties.
#' @param edges dataframe. A dataframe containing edges with their properties.
#' @param file character. The output file path where the plot will be saved, with `.png` or `.svg` extension.
#'
#' @return graph. A Graphviz object representing the network plot.
#'
#' @export
saveNetworkPlot <- function(nodes = NULL, edges = NULL, file = NULL) {
  # Calculate the bounding box
  min_x <- min(nodes$x)
  max_x <- max(nodes$x)
  min_y <- min(nodes$y)
  max_y <- max(nodes$y)
  
  # Determine the width and height of the graph in the original scale
  width <- max_x - min_x
  height <- max_y - min_y
  
  # Choose a target size for the Graphviz canvas (in inches)
  n_nodes <- nodes %>%
    filter(!color.background == "rgba(0,0,0,0)") %>%
    nrow()
  base_side <- 5                                                      
  target_side <- base_side + n_nodes * 0.25
  target_width  <- target_side
  target_height <- target_side
  
  # Choose a target font size
  base_fontsize = 12
  n_steps <- floor(n_nodes / 20)
  target_fontsize <- base_fontsize + n_steps * 1
  
  # Calculate the scaling factor to fit the graph within the target size
  scale_factor <- min(target_width / width, target_height / height)
  
  # Find the minimum and maximum node sizes in the network
  min_size_vis <- min(nodes$size)
  max_size_vis <- max(nodes$size)
  
  # Convert sizes to a range suitable for Graphviz
  min_size_graphviz <- 0.5
  max_size_graphviz <- 1.5
  
  # Prepare nodes
  nodes <- nodes %>%
    filter(!color.background == "rgba(0,0,0,0)") %>%                            # Remove hidden nodes
    select(id, label, x, y, size, isUnique,
           color.border, color.background) %>%                                   
    mutate(id = gsub("^[0-9]*|-", "", id),                                      # Remove any numbers at the start and hyphens within the id
           xlabel = label, 
           xlabel = paste(gsub("\n", "<br/>", xlabel)),
           x = (x - min_x) * scale_factor,
           y = (max_y - y) * scale_factor,
           # Scale node sizes from visNetwork range to Graphviz range
           size = ifelse(rep(min_size_vis == max_size_vis, nrow(.)),                           
                         min_size_graphviz,                                     # Assign a constant value when all sizes are the same (to prevent division by zero)
                         min_size_graphviz + (size - min_size_vis) * 
                           (max_size_graphviz - min_size_graphviz) / (max_size_vis - min_size_vis)
           ),
           height = size,                         
           width = size,
           fontsize = target_fontsize,
           color = color.border,
           fillcolor = color.background,
           shape = ifelse(isUnique == "yes", "square", "circle")
    ) %>%
    # Create DOT language strings
    mutate(dotString = paste0("node [",
                              "xlabel = <", xlabel, ">, ",
                              "label = '", "', ",
                              "pos = '", x, ",", y, "!', ",
                              "height = ", height, ", ",
                              "width = ", width, ", ",
                              "fontsize = ", fontsize, ", ",
                              "color = '", color, "', ",
                              "fillcolor = '", fillcolor, "', ",
                              "style = 'filled'", ", ",
                              "shape = '", shape, "'",
                              "] ", id
    ) 
    )
  
  # Prepare edges
  edges <- edges %>%
    filter(!color.color == "rgba(0,0,0,0)") %>%                                 # Remove hidden edges
    select(from, label, to, isUnique, 
           width, arrowheads, color.color, font.color) %>%
    mutate(across(c(from, to), ~gsub("^[0-9]*|-", "", .)),                      # Remove any numbers at the start and hyphens within the id
           label = replace_na(label, ""),
           label = paste(gsub("\n", "<br/>", label)),
           fontsize = target_fontsize - 2,
           penwidth = width,                                                    # Scale edge thickness
           fontcolor = font.color,                                             
           color = color.color,
           style = ifelse(isUnique == "yes", "dashed", "solid"), 
           dir = case_match(arrowheads,
                            0 ~ "none",
                            1 ~ "forward",
                            2 ~ "both"
           )
    ) %>% 
    # Create DOT language strings
    mutate(dotString = paste0(from, "--", to, " [", 
                              "label = <", label, ">, ",
                              "fontsize = ", fontsize - 2, ", ",
                              "penwidth = ", penwidth, ", ",
                              "fontcolor = '", fontcolor, "', ",
                              "color = '", color, "', ",
                              "style = '", style, "', ",
                              "dir = '", dir, "'",
                              "]"
    )
    )
  
  # Construct graph syntax using DOT language
  graphSyntax <-  paste0("graph {
     graph [layout = 'neato' overlap = true fixedsize = true]\n\n     ",
     paste0(nodes$dotString, collapse = "\n     "),
     "\n\n     ",
     paste0(edges$dotString, collapse = "\n     "),
     "\n}",
     collapse = "\n"
  )
  cat(graphSyntax)
  
  # Render plot with Graphviz 
  graphPlot <- grViz(graphSyntax, engine = "neato")
  graphPlot
  
  # Save plot as PNG
  if (grepl(".png$", file)) {
    graphPlot %>%
      export_svg() %>%
      charToRaw %>% 
      rsvg_png(file, 
               width = 3000)
  }
  
  # Save plot as SVG
  if (grepl(".svg$", file)) {
    graphPlot %>%
      export_svg() %>%
      charToRaw %>% 
      rsvg_svg(file, 
               width = 3000)
  }
  
  # Return plot
  return(graphPlot)  
}

#' @description This function is a wrapper to display tables in the dashboard using `reactable`. 
#' It allows for custom column definitions, including bar charts, tooltips, and hidden columns, 
#' to enhance the visualization.
#'
#' @param data dataframe. The dataframe to be displayed.
#' @param barCols character vector. A vector specifying the columns that should be displayed as bar graphs.
#' @param hideCols character vector. A vector specifying the columns that should be hidden.
#' @param uniqueCol character. A string specifying the column that indicates whether 
#' a value is unique. Unique values are highlighted in orange.
#' @param tooltipList list. A named list specifying the columns and the tooltips 
#' that appear when hovering over the corresponding column headers.
#' @param columnGroups list. A list specifying grouped columns using `reactable::colGroup`.
#'
#' @return A `reactable` table object customized with bar charts, tooltips, and other visual enhancements.
#'
#' @export
bartable <- function(data = NULL, barCols = NULL, hideCols = NULL, uniqueCol = NULL, tooltipList = NULL, columnGroups = NULL) {
  # Helper function: Style tooltip text
  tooltipTextStyling <- function(text) {
    paste0("<span style='font-size:13px;'>", text , "<span>")
  }
  
  # Helper function: Insert tooltips in dashboard tables
  withTooltip <- function(value, tooltip, ...) {
    # Based on https://github.com/glin/reactable/issues/220.
    div(style = "text-decoration: underline; cursor: help",
        tippy(value, tooltipTextStyling(tooltip), ...), theme = "custom", allowHTML = TRUE)
  }
  
  # Helper function: Insert bar chart into a reactable 
  bar_chart <- function(label, width = "100%", height = "3rem", fill = "#97c2fc", background = NULL) {
    # Based on https://glin.github.io/reactable/articles/cookbook/cookbook.html#bar-charts
    # See also https://stackoverflow.com/questions/7693224/how-do-i-right-align-div-elements
    label <- div(style = list(display = "flex", width = "20px", `justify-content` = "flex-start", `margin-right` = 0), label) 
    bar <- div(style = list(background = fill, width = width, height = height))
    chart <- div(bar, style = list(flexGrow = 1, marginRight= "0.5rem", background = background))
    div(style = list(display = "flex", alignItems = "center"), chart, label)
  }
  
  # Determine unique rows based on uniqueCol 
  if (is.null(uniqueCol)) {
    uniqueRows <- c()
  } else if (uniqueCol %in% names(data)) {
    uniqueRows <- which(data[uniqueCol] == "yes")
  }
  
  # Check for decimal points in bar columns
  # If any cell has a decimal point, all values are shown with 1 decimal digits
  anyDecimal <- any(grepl("\\.", data[barCols]))
  
  # Create custom column definitions
  customColDefs <- list()
  for (thisCol in names(data)) {
    if (thisCol %in% hideCols) {
      # Columns to hide
      customColDefs[[thisCol]] <- colDef(show = FALSE)
    } else if (thisCol %in% barCols) {
      # Columns to display as bar graphs with header tooltips 
      customColDefs[[thisCol]] <- colDef(name = thisCol,
                                         align = "left",
                                         header = withTooltip(thisCol, tooltipList[[thisCol]]),
                                         cell = function(value, index, name) {
                                           if (is.na(value)) return()
                                           # Compute bar width
                                           width <- ifelse(grepl("Percent",  name), 
                                                           paste0(value, "%"),  # Directly use percent value if applicable
                                                           paste0(value / max(data[name], na.rm = T) * 100, "%")) 
                                           label <- ifelse(anyDecimal, format(value, nsmall = 1), value)
                                           color <- ifelse(index %in% uniqueRows,  "orange", "#97c2fc")
                                           bar_chart(label, width = width, fill = color, background = "#e1e1e1")
                                         }
      )
    } else {
      # All remaining columns will have a cell tooltip if "Filename" exists
      if (("Filename" %in% hideCols) & ("Filename" %in% names(data))) {
        customColDefs[[thisCol]] <- colDef(
          header = function(thisCol) {
            if (!thisCol %in% names(tooltipList)) return()                      # No tooltip if column is not in tooltipList
            withTooltip(thisCol, tooltipList[[thisCol]])
          },
          cell = function(value, index) {
            withTooltip(value, paste0("This element is in the following files: ", data[index, "Filename"]))
          }
        )
      }
    }
  }
  
  # Create reactable
  reactable(data,
            columns = customColDefs,
            filterable = TRUE,
            resizable = TRUE,
            pagination = TRUE,
            defaultPageSize = 50,
            columnGroups = columnGroups
  )
}

#' @description This function adds or updates the x and y coordinates for nodes in a dataframe
#' based on a provided positions dataframe. If any coordinates are missing (NA), they are set 
#' to the minimum coordinate value available in the data.
#'
#' @param nodes data.frame. A dataframe containing node information, including any existing 
#' x and y coordinates.
#' @param pos data.frame. A dataframe containing new or additional positions (x, y coordinates)
#' for the nodes.
#'
#' @return data.frame. The updated nodes dataframe with updated x and y coordinates.
#'
#' @export
addPositions <- function(data = NULL, pos = NULL) {
  data <- data %>%
    select(!any_of(c("x", "y"))) %>%                                            # Remove any existing x and y columns
    left_join(pos) %>%                                                          # Join the nodes data with the positions dataframe
    mutate(x = ifelse(is.na(x), min(x, na.rm = TRUE), x),                       # Set missing x values to minimum x position
           y = ifelse(is.na(y), min(y, na.rm = TRUE), y))                       # Set missing y values to minimum y position
  
  return(data)
}

#' @description This function rescales a numeric vector to a specified range, 
#' adjusting its values proportionally between a lower and upper bound. 
#' The function is adapted from https://stackoverflow.com/questions/5468280/scale-a-series-between-two-points.
#'
#' @param x numeric. The input vector to be rescaled.
#' @param lower numeric. The lower bound of the new range.
#' @param upper numeric. The upper bound of the new range.
#'
#' @return numeric. A vector rescaled to the new range specified by `lower` and `upper`.
#'
#' @examples
#' # Example usage:
#' rescale(x = c(1, 5, 10), lower = 0, upper = 100)
#'
#' @export
rescale <- function(x, lower, upper) {
  if (length(unique(x)) > 1) {
    # Scale if there are multiple unique values 
    y <- (upper - lower) / (max(x) - min(x)) * (x - min(x)) + lower
  } else {
    # Return lower bound if only one unique value
    y <- lower
  }
  return(y)
} 

#' @description This function checks for duplicated node labels when adding new nodes to a graph. 
#' If a duplicate label is detected, an index is appended to the end of the label to ensure uniqueness.
#'
#' @param newLabel character. The value of the new label being added.
#' @param currentLabels character vector. A vector of all current labels in the graph.
#'
#' @return character. The value of the new label, potentially with an index added to avoid duplication.
#' 
#' @export
checkLabel <- function(newLabel, currentLabels) {
  # Replace empty label with default
  newLabel <- ifelse(length(newLabel) == 0, "new node", newLabel)
  
  # Check for matching labels
  matchingLabels <- (newLabel == gsub(" \\([0-9]*\\)$", "", currentLabels))
  
  # Add index to duplicate labels
  # If a matching label exists, find the highest existing index and increment it.
  if (sum(matchingLabels) > 0) {
    ind <- as.numeric( gsub(".*\\(([0-9]+)\\)", "\\1", currentLabels[matchingLabels]) )
    ind <- ifelse(all(is.na(ind)), 2, max(ind, na.rm = TRUE) + 1)
    newLabel <- paste0(newLabel, " (", ind, ")")
  }
  
  # Return the new label
  return(newLabel)
}

#' @description This function dynamically removes Shiny input elements server-side. 
#' It is particularly useful when removing modules or inputs created dynamically in a Shiny application.
#' The function is adapted from https://roh.engineering/posts/2020/02/shiny-add/removing-modules-dynamically/.
#'
#' @param id character. The id of the element to be removed.
#' @param input reactive input object. Contains the current values of all input
#' fields in the Shiny application.
#'
#' @return None The function performs input removal side effects without returning any visible output.
#'
#' @export
remove_shiny_inputs <- function(id, input) {
  invisible(
    lapply(grep(id, names(input), value = TRUE), function(i) {
      .subset2(input, "impl")$.values$remove(i)
    })
  )
}