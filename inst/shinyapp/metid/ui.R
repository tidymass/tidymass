options(shiny.maxRequestSize = 300 * 1024 ^ 2)

if (!require(tidyverse)) {
  install.packages("tidyverse")
  library(tidyverse)
}
if (!require(shiny)) {
  install.packages("shiny")
  library(shiny)
}
if (!require(shinydashboard)) {
  install.packages("shinydashboard")
  library(shinydashboard)
}
if (!require(shinyjs)) {
  install.packages("shinyjs")
  library(shinyjs)
}
if (!require(shinyBS)) {
  install.packages("shinyBS")
  library(shinyBS)
}
if (!require(patchwork)) {
  install.packages("patchwork")
  library(patchwork)
}
if (!require(shinyWidgets)) {
  install.packages("shinyWidgets")
  library(shinyWidgets)
}
if (!require(markdown)) {
  install.packages("markdown")
  library(markdown)
}

if (!require(massdataset)) {
  remotes::install_github("tidymass/massdataset")
}

# if (!require(tidymass)) {
#   source("https://www.tidymass.org/tidymass-packages/install_tidymass.txt")
#   install_tidymass(from = "tidymass.org")
# }

# if (!require(extrafont)) {
#   install.packages("extrafont")
#   library(extrafont)
#   extrafont::loadfonts()
# }

ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = "MetID"),
  ###sidebar of the app
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      menuItem(
        "Introduction",
        tabName = "introduction",
        icon = icon("info-circle")
      ),
      menuItem(
        "Totorial",
        tabName = "tutorial",
        icon = icon("book")
      ),
      hr(),
      h4("Database construction"),
      menuItem(
        "Upload Data",
        tabName = "upload_data",
        icon = icon("upload")
      ),
      menuItem(
        "Enrich Pathways",
        tabName = "enrich_pathways",
        icon = icon("cogs")
      ),
      menuItem(
        "Merge Pathways",
        tabName = "merge_pathways",
        icon = icon("cogs")
      ),
      menuItem(
        "Merge Modules",
        tabName = "merge_modules",
        icon = icon("cogs")
      ),
      hr(),
      h4("Metabolite annotation"),
      menuItem(
        "Translation",
        tabName = "translation",
        icon = icon("globe")
      ),
      menuItem(
        "Data Visualization",
        tabName = "data_visualization",
        icon = icon("chart-line")
      ),
      menuItem(
        "LLM Interpretation",
        tabName = "llm_interpretation",
        icon = icon("brain")
      ),
      menuItem(
        "Results and Report",
        tabName = "results",
        icon = icon("clipboard-list")
      )
    )
  ),
  
  ##dashboard body code
  
  dashboardBody(
    shinyjs::useShinyjs(),
    div(
      id = "loading",
      hidden = TRUE,
      class = "loading-style",
      "",
      tags$img(src = "loading.gif",
               height = "200px")
    ),
    tags$style(
      HTML(
        "
      .content-wrapper {
        padding-bottom: 120px;
      }
      .loading-style {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        text-align: center;
        z-index: 100;
      }
    "
      )
    ),
    
    tabItems(
      ####introduction tab
      tabItem(tabName = "introduction",
              fluidPage(
                titlePanel("Introduction of MAPA"),
                fluidRow(
                  column(12,
                         includeHTML("files/introduction.html")
                  )
                )
              )),
      ####tutorial tab
      tabItem(tabName = "tutorial",
              fluidPage(
                titlePanel("Tutorials of MAPA"),
                fluidRow(
                  column(12,
                         includeHTML("files/tutorials.html")
                  )
                )
              )),
      ####upload data tab
      tabItem(tabName = "upload_data",
              fluidPage(
                titlePanel("Upload Data"),
                fluidRow(
                  column(4,
                         fileInput(
                           "expression_data",
                           "Expression data",
                           accept = c(
                             "text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv",
                             ".xlsx",
                             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                             "application/vnd.ms-excel"
                           )
                         ),
                         fileInput(
                           "sample_info",
                           "Sample information",
                           accept = c(
                             "text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv",
                             ".xlsx",
                             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                             "application/vnd.ms-excel"
                           )
                         ),
                         fileInput(
                           "variable_info",
                           "Variable information",
                           accept = c(
                             "text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv",
                             ".xlsx",
                             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                             "application/vnd.ms-excel"
                           )
                         ),
                         checkboxInput(inputId = "use_example",
                                       label = "Use example",
                                       value = FALSE),
                         actionButton("create_mass_dataset",
                                      "Submit",
                                      class = "btn-primary",
                                      style = "background-color: #d83428; color: white;"),
                         
                         actionButton(
                           inputId = "go2enrich_pathways",
                           label = "Next",
                           class = "btn-primary",
                           style = "background-color: #d83428; color: white;"
                         ),
                         actionButton(
                           inputId = "show_upload_data_code",
                           label = "Code",
                           class = "btn-primary",
                           style = "background-color: #d83428; color: white;"
                         ),
                         style = "border-right: 1px solid #ddd; padding-right: 20px;"
                  ),
                  column(8,
                         tabsetPanel(
                           tabPanel(
                             title = "Expression data",
                             shiny::dataTableOutput("expression_data")
                           ),
                           tabPanel(
                             title = "Sample information",
                             shiny::dataTableOutput("sample_info")
                           ),
                           tabPanel(
                             title = "Variable information",
                             shiny::dataTableOutput("variable_info")
                           ),
                           tabPanel(
                             title = "R object",
                             verbatimTextOutput("enriched_pathways_object"),
                             br(),
                             shinyjs::useShinyjs(),
                             downloadButton("download_enriched_pathways_object",
                                            "Download",
                                            class = "btn-primary",
                                            style = "background-color: #d83428; color: white;")
                           )
                         )
                  )
                )
              )),
      
      ####enrich pathways tab
      tabItem(tabName = "enrich_pathways",
              fluidPage(
                titlePanel("Enrich Pathways"),
                fluidPage(
                  fluidRow(
                    column(4,
                           checkboxGroupInput(
                             "pathway_database",
                             "Database",
                             choices = c(
                               "GO" = "go",
                               "KEGG" = "kegg",
                               "Reactome" = "reactome"
                             ),
                             selected = c("go", "kegg", "reactome")
                           ),
                           selectInput(
                             "organism",
                             "Organism",
                             choices = list(
                               "Human" = "hsa",
                               "Rat" = "rno",
                               "Mouse" = "mmu",
                               "C. elegans" = "cel",
                               "Yeast" = "sce",
                               "Zebrafish" = "dre",
                               "Fruit fly" = "dme"),
                             selected = "hsa"
                           ),
                           numericInput(
                             "p_value_cutoff",
                             "P-value cutoff",
                             value = 0.05,
                             min = 0,
                             max = 0.5),
                           selectInput(
                             "p_adjust_method",
                             "P-adjust method",
                             choices = c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr"),
                             selected = "BH"),
                           sliderInput(
                             "gene_set_size",
                             "Gene set size",
                             min = 5,
                             max = 2000,
                             value = c(10, 500)),
                           
                           actionButton(
                             "submit_enrich_pathways",
                             "Submit",
                             class = "btn-primary",
                             style = "background-color: #d83428; color: white;"),
                           
                           actionButton(
                             "go2merge_pathways",
                             "Next",
                             class = "btn-primary",
                             style = "background-color: #d83428; color: white;"),
                           
                           actionButton(
                             "show_enrich_pathways_code",
                             "Code",
                             class = "btn-primary",
                             style = "background-color: #d83428; color: white;"),
                           
                           style = "border-right: 1px solid #ddd; padding-right: 20px;"
                    ),
                    column(8,
                           tabsetPanel(
                             id = "enriched_pathways_result",
                             tabPanel(
                               title = "GO",
                               shiny::dataTableOutput("enriched_pathways_go"),
                               br(),
                               shinyjs::useShinyjs(),
                               downloadButton("download_enriched_pathways_go",
                                              "Download",
                                              class = "btn-primary",
                                              style = "background-color: #d83428; color: white;")
                             ),
                             tabPanel(
                               title = "KEGG",
                               shiny::dataTableOutput("enriched_pathways_kegg"),
                               br(),
                               shinyjs::useShinyjs(),
                               downloadButton("download_enriched_pathways_kegg",
                                              "Download",
                                              class = "btn-primary",
                                              style = "background-color: #d83428; color: white;")
                             ),
                             tabPanel(
                               title = "Reactome",
                               shiny::dataTableOutput("enriched_pathways_reactome"),
                               br(),
                               shinyjs::useShinyjs(),
                               downloadButton("download_enriched_pathways_reactome",
                                              "Download",
                                              class = "btn-primary",
                                              style = "background-color: #d83428; color: white;")
                             ),
                             tabPanel(
                               title = "R object",
                               verbatimTextOutput("enriched_pathways_object"),
                               br(),
                               shinyjs::useShinyjs(),
                               downloadButton("download_enriched_pathways_object",
                                              "Download",
                                              class = "btn-primary",
                                              style = "background-color: #d83428; color: white;")
                             )
                           )
                    )
                  )
                )
              )),
      
      ####merge pathways tab
      tabItem(tabName = "merge_pathways",
              fluidPage(
                titlePanel("Merge Pathways"),
                fluidPage(
                  fluidRow(
                    column(4,
                           h4("GO"),
                           fluidRow(
                             column(6,
                                    numericInput(
                                      "p.adjust.cutoff.go",
                                      "P-adjust cutoff",
                                      value = 0.05,
                                      min = 0,
                                      max = 0.5)
                             ),
                             column(6,
                                    numericInput(
                                      "count.cutoff.go",
                                      "Gene count cutoff",
                                      value = 5,
                                      min = 0,
                                      max = 1000
                                    )
                             )),
                           h4("Network"),
                           fluidRow(
                             column(6,
                                    selectInput(
                                      "measure.method.go",
                                      "Similarity method",
                                      choices = c("Wang", "Resnik", "Rel", "Jiang",
                                                  "Lin", "TCSS", "jaccard"),
                                      selected = "Wang"
                                    )
                             ),
                             column(6,
                                    numericInput(
                                      "sim.cutoff.go",
                                      "Similarity cutoff",
                                      value = 0.5,
                                      min = 0,
                                      max = 1
                                    )
                             )),
                           h4("KEGG"),
                           fluidRow(
                             column(6,
                                    numericInput(
                                      "p.adjust.cutoff.kegg",
                                      "P-adjust cutoff",
                                      value = 0.05,
                                      min = 0,
                                      max = 0.5)
                             ),
                             column(6,
                                    numericInput(
                                      "count.cutoff.kegg",
                                      "Gene count cutoff",
                                      value = 5,
                                      min = 0,
                                      max = 1000)
                             )
                           ),
                           h4("Network"),
                           fluidRow(
                             column(6,
                                    selectInput(
                                      "measure.method.kegg",
                                      "Similarity method",
                                      choices = c("jaccard"),
                                      selected = "jaccard")
                             ),
                             column(6,
                                    numericInput(
                                      "sim.cutoff.kegg",
                                      "Similarity cutoff",
                                      value = 0.5,
                                      min = 0,
                                      max = 1)
                             )),
                           
                           h4("Reactome"),
                           fluidRow(
                             column(6,
                                    numericInput(
                                      "p.adjust.cutoff.reactome",
                                      "P-adjust cutoff",
                                      value = 0.05,
                                      min = 0,
                                      max = 0.5)
                             ),
                             column(6,
                                    numericInput(
                                      "count.cutoff.reactome",
                                      "Gene count cutoff",
                                      value = 5,
                                      min = 0,
                                      max = 1000)
                             )),
                           h4("Network"),
                           fluidRow(
                             column(6,
                                    selectInput(
                                      "measure.method.reactome",
                                      "Similarity method",
                                      choices = c("jaccard"),
                                      selected = "jaccard")
                             ),
                             column(6,
                                    numericInput(
                                      "sim.cutoff.reactome",
                                      "Similarity cutoff",
                                      value = 0.5,
                                      min = 0,
                                      max = 1)
                             )),
                           
                           actionButton(
                             "submit_merge_pathways",
                             "Submit",
                             class = "btn-primary",
                             style = "background-color: #d83428; color: white;"),
                           
                           actionButton(
                             "go2merge_modules",
                             "Next",
                             class = "btn-primary",
                             style = "background-color: #d83428; color: white;"),
                           
                           actionButton(
                             "show_merge_pathways_code",
                             "Code",
                             class = "btn-primary",
                             style = "background-color: #d83428; color: white;"),
                           style = "border-right: 1px solid #ddd; padding-right: 20px;"
                    ),
                    
                    column(8,
                           tabsetPanel(
                             tabPanel("Table",
                                      tabsetPanel(
                                        tabPanel(
                                          title = "GO",
                                          shiny::dataTableOutput("merged_pathway_go"),
                                          br(),
                                          shinyjs::useShinyjs(),
                                          downloadButton("download_merged_pathway_go",
                                                         "Download",
                                                         class = "btn-primary",
                                                         style = "background-color: #d83428; color: white;")
                                        ),
                                        tabPanel(
                                          title = "KEGG",
                                          shiny::dataTableOutput("merged_pathway_kegg"),
                                          br(),
                                          shinyjs::useShinyjs(),
                                          downloadButton("download_merged_pathway_kegg",
                                                         "Download",
                                                         class = "btn-primary",
                                                         style = "background-color: #d83428; color: white;")
                                        ),
                                        tabPanel(
                                          title = "Reactome",
                                          shiny::dataTableOutput("merged_pathway_reactome"),
                                          br(),
                                          shinyjs::useShinyjs(),
                                          downloadButton("download_merged_pathway_reactome",
                                                         "Download",
                                                         class = "btn-primary",
                                                         style = "background-color: #d83428; color: white;")
                                        )
                                      )),
                             tabPanel(
                               title = "Data visualization",
                               tabsetPanel(
                                 tabPanel(
                                   title = "GO",
                                   shiny::plotOutput("enirched_module_go_plot"),
                                   br(),
                                   fluidRow(
                                     column(3,
                                            actionButton("generate_enirched_module_plot_go",
                                                         "Generate plot",
                                                         class = "btn-primary",
                                                         style = "background-color: #d83428; color: white;")
                                     ),
                                     column(3,
                                            checkboxInput("enirched_module_plot_text_go", "Text", FALSE)
                                     ),
                                     column(3,
                                            checkboxInput("enirched_module_plot_text_all_go", "Text all", FALSE)
                                     ),
                                     column(3,
                                            numericInput(
                                              "enirched_module_plot_degree_cutoff_go",
                                              "Degree cutoff",
                                              value = 0,
                                              min = 0,
                                              max = 1000)
                                     )
                                   )
                                 ),
                                 tabPanel(
                                   title = "KEGG",
                                   shiny::plotOutput("enirched_module_kegg_plot"),
                                   br(),
                                   fluidRow(
                                     column(3,
                                            actionButton("generate_enirched_module_plot_kegg",
                                                         "Generate plot",
                                                         class = "btn-primary",
                                                         style = "background-color: #d83428; color: white;")
                                     ),
                                     column(3,
                                            checkboxInput("enirched_module_plot_text_kegg", "Text", FALSE)
                                     ),
                                     column(3,
                                            checkboxInput("enirched_module_plot_text_all_kegg", "Text all", FALSE)
                                     ),
                                     column(3,
                                            numericInput(
                                              "enirched_module_plot_degree_cutoff_kegg",
                                              "Degree cutoff",
                                              value = 0,
                                              min = 0,
                                              max = 1000
                                            )
                                     )
                                   )
                                 ),
                                 tabPanel(
                                   title = "Reactome",
                                   shiny::plotOutput("enirched_module_reactome_plot"),
                                   br(),
                                   fluidRow(
                                     column(3,
                                            actionButton("generate_enirched_module_plot_reactome",
                                                         "Generate plot",
                                                         class = "btn-primary",
                                                         style = "background-color: #d83428; color: white;")
                                     ),
                                     column(3,
                                            checkboxInput("enirched_module_plot_text_reactome", "Text", FALSE)
                                     ),
                                     column(3,
                                            checkboxInput("enirched_module_plot_text_all_reactome", "Text all", FALSE)
                                     ),
                                     column(3,
                                            numericInput(
                                              "enirched_module_plot_degree_cutoff_reactome",
                                              "Degree cutoff",
                                              value = 0,
                                              min = 0,
                                              max = 1000)
                                     )
                                   )
                                 )
                               )
                             ),
                             tabPanel(
                               title = "R object",
                               verbatimTextOutput("enriched_modules_object"),
                               br(),
                               shinyjs::useShinyjs(),
                               downloadButton("download_enriched_modules_object",
                                              "Download",
                                              class = "btn-primary",
                                              style = "background-color: #d83428; color: white;")
                             )
                           ))
                  )
                )
              )),
      
      #### Merge modules tab
      tabItem(
        tabName = "merge_modules",
        fluidPage(titlePanel("Merge Modules"),
                  fluidPage(
                    fluidRow(
                      column(4,
                             fluidRow(
                               column(6,
                                      selectInput(
                                        "measure.method.module",
                                        "Similarity method",
                                        choices = c("jaccard"),
                                        selected = "jaccard")
                               ),
                               column(6,
                                      numericInput(
                                        "sim.cutoff.module",
                                        "Similarity cutoff",
                                        value = 0.5,
                                        min = 0,
                                        max = 1)
                               )),
                             
                             actionButton(
                               "submit_merge_modules",
                               "Submit",
                               class = "btn-primary",
                               style = "background-color: #d83428; color: white;"),
                             
                             actionButton(
                               "go2translation",
                               "Next",
                               class = "btn-primary",
                               style = "background-color: #d83428; color: white;"),
                             
                             actionButton(
                               "show_merge_modules_code",
                               "Code",
                               class = "btn-primary",
                               style = "background-color: #d83428; color: white;"),
                             style = "border-right: 1px solid #ddd; padding-right: 20px;"
                      ),
                      column(8,
                             tabsetPanel(
                               tabPanel(
                                 title = "Table",
                                 shiny::dataTableOutput("enriched_functional_modules"),
                                 br(),
                                 shinyjs::useShinyjs(),
                                 downloadButton("download_enriched_functional_modules",
                                                "Download",
                                                class = "btn-primary",
                                                style = "background-color: #d83428; color: white;")
                               ),
                               tabPanel(
                                 title = "Data visualization",
                                 shiny::plotOutput("enirched_functional_module_plot"),
                                 br(),
                                 fluidRow(
                                   column(3,
                                          actionButton("generate_enirched_functional_module",
                                                       "Generate plot",
                                                       class = "btn-primary",
                                                       style = "background-color: #d83428; color: white;")
                                   ),
                                   column(3,
                                          checkboxInput("enirched_functional_module_plot_text", "Text", FALSE)
                                   ),
                                   column(3,
                                          checkboxInput("enirched_functional_module_plot_text_all", "Text all", FALSE)
                                   ),
                                   column(3,
                                          numericInput(
                                            "enirched_functional_moduleplot__degree_cutoff",
                                            "Degree cutoff",
                                            value = 0,
                                            min = 0,
                                            max = 1000)
                                   )
                                 )
                               ),
                               tabPanel(
                                 title = "R object",
                                 verbatimTextOutput("enriched_functional_module_object"),
                                 br(),
                                 shinyjs::useShinyjs(),
                                 downloadButton("download_enriched_functional_module_object",
                                                "Download",
                                                class = "btn-primary",
                                                style = "background-color: #d83428; color: white;")
                               )
                             ))
                    )))
      ),
      
      
      
      #### Translation tab
      tabItem(
        tabName = "translation",
        fluidPage(titlePanel("Translation"),
                  fluidPage(fluidRow(
                    column(
                      4,
                      fluidRow(column(
                        5,
                        selectInput(
                          "translation_model",
                          "Model",
                          choices = c(
                            "Gemini" = "gemini",
                            "ChatGPT" = "chatgpt"),
                          selected = "gemini"
                        )
                      ),
                      column(
                        7,
                        textInput("translation_model_ai_key",
                                  "AI key",
                                  value = "")
                      )),
                      fluidRow(column(
                        12,
                        selectInput(
                          "translation_to",
                          "Translation to",
                          choices = c("Chinese" = "chinese",
                                      "Spanish" = "spanish",
                                      "English" = "english",
                                      "French" = "french",
                                      "German" = "german",
                                      "Italian" = "italian",
                                      "Japanese" = "japanese",
                                      "Korean" = "korean",
                                      "Portuguese" = "portuguese",
                                      "Russian" = "russian",
                                      "Spanish" = "spanish"),
                          selected = "chinese"
                        )
                      )),
                      actionButton(
                        "submit_translation",
                        "Submit",
                        class = "btn-primary",
                        style = "background-color: #d83428; color: white;"
                      ),
                      
                      actionButton(
                        "skip_translation",
                        "Skip",
                        class = "btn-primary",
                        style = "background-color: #d83428; color: white;"
                      ),
                      
                      actionButton(
                        "go2data_visualization",
                        "Next",
                        class = "btn-primary",
                        style = "background-color: #d83428; color: white;"
                      ),
                      actionButton(
                        "show_translation_code",
                        "Code",
                        class = "btn-primary",
                        style = "background-color: #d83428; color: white;"
                      ),
                      style = "border-right: 1px solid #ddd; padding-right: 20px;"
                    ),
                    column(8,
                           tabsetPanel(
                             tabPanel(
                               title = "R object",
                               verbatimTextOutput("enriched_functional_module_object2"),
                               br(),
                               shinyjs::useShinyjs(),
                               downloadButton("download_enriched_functional_module_object2",
                                              "Download",
                                              class = "btn-primary",
                                              style = "background-color: #d83428; color: white;")
                             )
                           )
                    )
                  )))
      ),
      
      #### Data visualization tab
      tabItem(tabName = "data_visualization",
              fluidPage(
                titlePanel("Data Visualization"),
                tabsetPanel(
                  tabPanel(
                    title = "Barplot",
                    fluidRow(
                      column(4,
                             br(),
                             fluidRow(
                               column(8,
                                      fileInput(inputId = "upload_enriched_functional_module",
                                                label = tags$span("Upload functional module",
                                                                  shinyBS::bsButton("upload_functional_module_info",
                                                                                    label = "",
                                                                                    icon = icon("info"),
                                                                                    style = "info",
                                                                                    size = "extra-small")),
                                                accept = ".rda"),
                                      bsPopover(
                                        id = "upload_functional_module_info",
                                        title = "",
                                        content = "You can upload the functional module file here for data visualization only.",
                                        placement = "right",
                                        trigger = "hover",
                                        options = list(container = "body")
                                      )
                               )
                             ),
                             fluidRow(
                               column(4,
                                      selectInput(
                                        inputId = "barplot_level",
                                        label = "Level",
                                        choices = c(
                                          "FM" = "functional_module",
                                          "Module" = "module",
                                          "Pathway" = "pathway"),
                                        selected = "functional_module")
                               ),
                               column(4,
                                      numericInput(
                                        inputId = "barplot_top_n",
                                        label = "Top N",
                                        value = 5,
                                        min = 1,
                                        max = 1000)
                               ),
                               column(4,
                                      selectInput(
                                        "line_type",
                                        "Line type",
                                        choices = c(
                                          "Straight" = "straight",
                                          "Meteor" = "meteor"))
                               )
                             ),
                             fluidRow(
                               column(4,
                                      numericInput(
                                        "barplot_y_lable_width",
                                        "Y label width",
                                        value = 50,
                                        min = 20,
                                        max = 100)
                               ),
                               column(4,
                                      numericInput("barplot_p_adjust_cutoff",
                                                   "P-adjust cutoff",
                                                   value = 0.05,
                                                   min = 0,
                                                   max = 0.5),
                               ),
                               column(4,
                                      numericInput("barplot_count_cutoff",
                                                   "Count cutoff",
                                                   value = 5,
                                                   min = 1,
                                                   max = 1000)
                               )
                             ),
                             fluidRow(
                               column(8,
                                      checkboxGroupInput("barplot_database",
                                                         "Database",
                                                         choices = c(
                                                           "GO" = "go",
                                                           "KEGG" = "kegg",
                                                           "Reactome" = "reactome"
                                                         ),
                                                         selected = c("go", "kegg", "reactome"),
                                                         inline = TRUE)
                               ),
                               column(4,
                                      checkboxInput("barplot_translation", "Translation", FALSE)
                               )
                             ),
                             h4("Database color"),
                             fluidRow(
                               column(4,
                                      shinyWidgets::colorPickr(
                                        inputId = "barplot_go_color",
                                        label = "GO",
                                        selected = "#1F77B4FF",
                                        theme = "monolith",
                                        width = "100%")
                               ),
                               column(4,
                                      shinyWidgets::colorPickr(
                                        inputId = "barplot_kegg_color",
                                        label = "KEGG",
                                        selected = "#FF7F0EFF",
                                        theme = "monolith",
                                        width = "100%")
                               ),
                               column(4,
                                      shinyWidgets::colorPickr(
                                        inputId = "barplot_reactome_color",
                                        label = "Reactome",
                                        selected = "#2CA02CFF",
                                        theme = "monolith",
                                        width = "100%")
                               )
                             ),
                             fluidRow(
                               column(4,
                                      selectInput("barplot_type", "Type",
                                                  choices = c("pdf", "png", "jpeg"))
                               ),
                               column(4,
                                      numericInput("barplot_width", "Width",
                                                   value = 7, min = 4, max = 20)
                                      
                               ),
                               column(4,
                                      numericInput("barplot_height", "Height",
                                                   value = 7, min = 4, max = 20)
                                      
                               )
                             ),
                             fluidRow(
                               column(12,
                                      actionButton("generate_barplot",
                                                   "Generate plot",
                                                   class = "btn-primary",
                                                   style = "background-color: #d83428; color: white;"),
                                      downloadButton("download_barplot",
                                                     "Download",
                                                     class = "btn-primary",
                                                     style = "background-color: #d83428; color: white;")
                               )
                             ),
                             br(),
                             fluidRow(
                               column(12,
                                      actionButton(
                                        "go2llm_interpretation_1",
                                        "Next",
                                        class = "btn-primary",
                                        style = "background-color: #d83428; color: white;"),
                                      actionButton(
                                        "show_barplot_code",
                                        "Code",
                                        class = "btn-primary",
                                        style = "background-color: #d83428; color: white;")
                               )
                             ),
                             style = "border-right: 1px solid #ddd; padding-right: 20px;"
                      ),
                      column(8,
                             br(),
                             shiny::plotOutput("barplot")
                      )
                    )
                  ),
                  tabPanel(
                    title = "Module Similarity Network",
                    fluidRow(
                      column(4,
                             br(),
                             fluidRow(
                               column(6,
                                      selectInput(
                                        "module_similarity_network_database",
                                        "Database",
                                        choices = c("GO" = "go",
                                                    "KEGG" = "kegg",
                                                    "Reactome" = "reactome"),
                                        selected = "go")
                               ),
                               column(6,
                                      numericInput(
                                        "module_similarity_network_degree_cutoff",
                                        "Degree cutoff",
                                        value = 0,
                                        min = 0,
                                        max = 1000)
                               )
                             ),
                             fluidRow(
                               column(6,
                                      selectInput(
                                        "module_similarity_network_level",
                                        "Level",
                                        choices = c(
                                          "FM" = "functional_module",
                                          "Module" = "module"),
                                        selected = "functional_module")
                               )
                             ),
                             fluidRow(
                               column(4,
                                      checkboxInput("module_similarity_network_translation", "Translation", FALSE)
                               ),
                               column(4,
                                      checkboxInput("module_similarity_network_text", "Text", FALSE)
                               ),
                               column(4,
                                      checkboxInput("module_similarity_network_text_all", "Text all", FALSE)
                               )
                             ),
                             fluidRow(
                               column(4,
                                      selectInput("module_similarity_network_type", "Type",
                                                  choices = c("pdf", "png", "jpeg"))
                               ),
                               column(4,
                                      numericInput("module_similarity_network_width", "Width",
                                                   value = 7, min = 4, max = 20)),
                               column(4,
                                      numericInput("module_similarity_network_height", "Height",
                                                   value = 7, min = 4, max = 20))
                             ),
                             fluidRow(
                               column(12,
                                      shinyjs::useShinyjs(),
                                      actionButton("generate_module_similarity_network",
                                                   "Generate plot",
                                                   class = "btn-primary",
                                                   style = "background-color: #d83428; color: white;"),
                                      shinyjs::useShinyjs(),
                                      downloadButton("download_module_similarity_network",
                                                     "Download",
                                                     class = "btn-primary",
                                                     style = "background-color: #d83428; color: white;")
                               )
                             ),
                             br(),
                             fluidRow(
                               column(12,
                                      actionButton(
                                        "go2llm_interpretation_2",
                                        "Next",
                                        class = "btn-primary",
                                        style = "background-color: #d83428; color: white;"
                                      ),
                                      actionButton(
                                        "show_module_similarity_network_code",
                                        "Code",
                                        class = "btn-primary",
                                        style = "background-color: #d83428; color: white;")
                               )
                             ),
                             style = "border-right: 1px solid #ddd; padding-right: 20px;"
                      ),
                      column(8,
                             br(),
                             shiny::plotOutput("module_similarity_network")
                      )
                    )
                  ),
                  tabPanel(
                    title = "Module information",
                    fluidRow(
                      column(4,
                             br(),
                             fluidRow(
                               column(6,
                                      selectInput(
                                        "module_information_level",
                                        "Level",
                                        choices = c(
                                          "FM" = "functional_module",
                                          "Module" = "module"),
                                        selected = "functional_module")
                               ),
                               column(6,
                                      selectInput(
                                        "module_information_database",
                                        "Database",
                                        choices = c("GO" = "go",
                                                    "KEGG" = "kegg",
                                                    "Reactome" = "reactome"),
                                        selected = "go")
                               )
                             ),
                             fluidRow(
                               column(7,
                                      selectInput(
                                        "module_information_module_id",
                                        "Module ID",
                                        choices = NULL)
                               ),
                               column(5,
                                      checkboxInput("module_information_translation",
                                                    "Translation", FALSE)
                               )
                             ),
                             fluidRow(
                               column(4,
                                      selectInput("module_information_type", "Type",
                                                  choices = c("pdf", "png", "jpeg"))
                               ),
                               column(4,
                                      numericInput("module_information_width", "Width",
                                                   value = 7, min = 4, max = 30)),
                               column(4,
                                      numericInput("module_information_height", "Height",
                                                   value = 21, min = 4, max = 20))
                             ),
                             fluidRow(
                               column(12,
                                      shinyjs::useShinyjs(),
                                      actionButton("generate_module_information",
                                                   "Generate plot",
                                                   class = "btn-primary",
                                                   style = "background-color: #d83428; color: white;"),
                                      downloadButton("download_module_information",
                                                     "Download",
                                                     class = "btn-primary",
                                                     style = "background-color: #d83428; color: white;")
                               )
                             ),
                             br(),
                             fluidRow(
                               column(12,
                                      shinyjs::useShinyjs(),
                                      actionButton(
                                        "go2llm_interpretation_3",
                                        "Next",
                                        class = "btn-primary",
                                        style = "background-color: #d83428; color: white;"),
                                      actionButton(
                                        "show_module_information_code",
                                        "Code",
                                        class = "btn-primary",
                                        style = "background-color: #d83428; color: white;")
                               )
                             ),
                             style = "border-right: 1px solid #ddd; padding-right: 20px;"
                      ),
                      column(8,
                             br(),
                             shiny::plotOutput("module_information1"),
                             shiny::plotOutput("module_information2"),
                             shiny::plotOutput("module_information3")
                      )
                    )
                  ),
                  tabPanel(
                    title = "Relationship network",
                    fluidRow(
                      column(4,
                             br(),
                             fluidRow(
                               column(5,
                                      checkboxInput("relationship_network_circular_plot",
                                                    "Circular layout", FALSE)
                               ),
                               column(3,
                                      checkboxInput("relationship_network_filter",
                                                    "Filter", FALSE)
                               ),
                               column(4,
                                      checkboxInput("relationship_network_translation",
                                                    "Translation", FALSE)
                               )
                             ),
                             fluidRow(
                               column(6,
                                      selectInput(
                                        "relationship_network_level",
                                        "Filter Level",
                                        choices = c(
                                          "FM" = "functional_module",
                                          "Module" = "module"),
                                        selected = "functional_module")
                               ),
                               column(6,
                                      selectInput(
                                        "relationship_network_module_id",
                                        "Module ID",
                                        choices = NULL,
                                        multiple = TRUE)
                               )
                             ),
                             h4("Includes"),
                             fluidRow(
                               column(3,
                                      checkboxInput("relationship_network_include_functional_modules",
                                                    label = tags$span("FM",
                                                                      shinyBS::bsButton("functional_module_info",
                                                                                        label = "",
                                                                                        icon = icon("info"),
                                                                                        style = "info",
                                                                                        size = "extra-small")),
                                                    TRUE)),
                               bsPopover(
                                 id = "functional_module_info",
                                 title = "",
                                 content = "FM is functional module",
                                 placement = "right",
                                 trigger = "hover",
                                 options = list(container = "body")
                               ),
                               column(3,
                                      checkboxInput("relationship_network_include_modules",
                                                    "Modules", TRUE)
                               ),
                               column(3,
                                      checkboxInput("relationship_network_include_pathways",
                                                    "Pathways", TRUE)
                               ),
                               column(3,
                                      checkboxInput("relationship_network_include_molecules",
                                                    "Molecules", TRUE)
                               )
                             ),
                             h4("Colors"),
                             fluidRow(
                               column(3,
                                      shinyWidgets::colorPickr(
                                        inputId = "relationship_network_functional_module_color",
                                        label = "FM",
                                        selected = "#F05C3BFF",
                                        theme = "monolith",
                                        width = "100%"
                                      )
                               ),
                               column(3,
                                      shinyWidgets::colorPickr(
                                        inputId = "relationship_network_module_color",
                                        label = "Module",
                                        selected = "#46732EFF",
                                        theme = "monolith",
                                        width = "100%"
                                      )
                               ),
                               column(3,
                                      shinyWidgets::colorPickr(
                                        inputId = "relationship_network_pathway_color",
                                        label = "Pathway",
                                        selected = "#197EC0FF",
                                        theme = "monolith",
                                        width = "100%"
                                      )
                               ),
                               column(3,
                                      shinyWidgets::colorPickr(
                                        inputId = "relationship_network_molecule_color",
                                        label = "Molecule",
                                        selected = "#3B4992FF",
                                        theme = "monolith",
                                        width = "100%"
                                      )
                               )
                             ),
                             h4("Text"),
                             fluidRow(
                               column(3,
                                      checkboxInput("relationship_network_functional_module_text",
                                                    "FM", TRUE)
                               ),
                               column(3,
                                      checkboxInput("relationship_network_module_text",
                                                    "Module", TRUE)
                               ),
                               column(3,
                                      checkboxInput("relationship_network_pathway_text",
                                                    "Pathway", TRUE)
                               ),
                               column(3,
                                      checkboxInput("relationship_network_molecule_text",
                                                    "Molecules", FALSE)
                               )
                             ),
                             h4("Text size"),
                             fluidRow(
                               column(3,
                                      numericInput("relationship_network_functional_module_text_size",
                                                   "FM",
                                                   value = 3, min = 0.3, max = 10)
                               ),
                               column(3,
                                      numericInput("relationship_network_module_text_size",
                                                   "Module",
                                                   value = 3, min = 0.3, max = 10)
                               ),
                               column(3,
                                      numericInput("relationship_network_pathway_text_size",
                                                   "Pathway",
                                                   value = 3, min = 0.3, max = 10)
                               ),
                               column(3,
                                      numericInput("relationship_network_molecule_text_size",
                                                   "Molecule",
                                                   value = 3, min = 0.3, max = 10)
                               )
                             ),
                             h4("Arrange posision"),
                             fluidRow(
                               column(3,
                                      checkboxInput("relationship_network_functional_module_arrange_position",
                                                    "FM", TRUE)
                               ),
                               column(3,
                                      checkboxInput("relationship_network_module_arrange_position",
                                                    "Module", TRUE)
                               ),
                               column(3,
                                      checkboxInput("relationship_network_pathway_arrange_position",
                                                    "Pathway", TRUE)
                               ),
                               column(3,
                                      checkboxInput("relationship_network_molecule_arrange_position",
                                                    "Molecules", FALSE)
                               )
                             ),
                             h4("Posision limits"),
                             fluidRow(
                               column(6,
                                      sliderInput(
                                        "relationship_network_functional_module_position_limits",
                                        "Functional module",
                                        min = 0, max = 1,
                                        value = c(0, 1))
                               ),
                               column(6,
                                      sliderInput(
                                        "relationship_network_module_position_limits",
                                        "Module",
                                        min = 0, max = 1,
                                        value = c(0, 1))
                               )
                             ),
                             fluidRow(
                               column(6,
                                      sliderInput(
                                        "relationship_network_pathway_position_limits",
                                        "Pathway",
                                        min = 0, max = 1,
                                        value = c(0, 1))
                               ),
                               column(6,
                                      sliderInput(
                                        "relationship_network_molecule_position_limits",
                                        "Molecule",
                                        min = 0, max = 1,
                                        value = c(0, 1))
                               )
                             ),
                             fluidRow(
                               column(4,
                                      selectInput("relationship_network_type",
                                                  "Type",
                                                  choices = c("pdf", "png", "jpeg")
                                      )
                               ),
                               column(4,
                                      numericInput("relationship_network_width",
                                                   "Width",
                                                   value = 21, min = 4, max = 30)
                               ),
                               column(4,
                                      numericInput("relationship_network_height",
                                                   "Height",
                                                   value = 7, min = 4, max = 20)
                               )
                             ),
                             fluidRow(
                               column(12,
                                      actionButton("generate_relationship_network",
                                                   "Generate plot",
                                                   class = "btn-primary",
                                                   style = "background-color: #d83428; color: white;"),
                                      shinyjs::useShinyjs(),
                                      downloadButton("download_relationship_network",
                                                     "Download",
                                                     class = "btn-primary",
                                                     style = "background-color: #d83428; color: white;")
                               )
                             ),
                             br(),
                             fluidRow(
                               column(12,
                                      actionButton(
                                        "go2llm_interpretation_4",
                                        "Next",
                                        class = "btn-primary",
                                        style = "background-color: #d83428; color: white;"),
                                      actionButton(
                                        "show_relationship_network_code",
                                        "Code",
                                        class = "btn-primary",
                                        style = "background-color: #d83428; color: white;"
                                      )
                               )
                             ),
                             style = "border-right: 1px solid #ddd; padding-right: 20px;"
                      ),
                      column(8,
                             br(),
                             shiny::plotOutput("relationship_network")
                      )
                    )
                  )
                )
              )),
      
      #### LLM Interpretation tab
      tabItem(
        tabName = "llm_interpretation",
        fluidPage(titlePanel("LLM Interpretation"),
                  fluidPage(fluidRow(
                    column(
                      4,
                      fluidRow(column(
                        5,
                        selectInput(
                          "llm_model",
                          "LLM model",
                          choices = c("ChatGPT" = "chatgpt"),
                          selected = "chatgpt"
                        )
                      ),
                      column(
                        7,
                        textInput("openai_key",
                                  "OpenAI key",
                                  value = "")
                      )),
                      fluidRow(column(
                        12,
                        textInput(
                          "llm_interpretation_disease",
                          "Disease or phenotype",
                          value = "pregnancy",
                          width = "100%"
                        )
                      )),
                      fluidRow(
                        column(4,
                               numericInput("llm_interpretation_top_n",
                                            "Top N",
                                            value = 5,
                                            min = 1,
                                            max = 1000)
                        ),
                        column(4,
                               numericInput("llm_interpretation_p_adjust_cutoff",
                                            "P-adjust cutoff",
                                            value = 0.05,
                                            min = 0,
                                            max = 0.5),
                        ),
                        column(4,
                               numericInput("llm_interpretation_count_cutoff",
                                            "Count cutoff",
                                            value = 5,
                                            min = 1,
                                            max = 1000)
                        )
                      ),
                      actionButton(
                        "submit_llm_interpretation",
                        "Submit",
                        class = "btn-primary",
                        style = "background-color: #d83428; color: white;"
                      ),
                      
                      actionButton(
                        "go2results",
                        "Next",
                        class = "btn-primary",
                        style = "background-color: #d83428; color: white;"
                      ),
                      actionButton(
                        "show_llm_interpretation_code",
                        "Code",
                        class = "btn-primary",
                        style = "background-color: #d83428; color: white;"
                      ),
                      style = "border-right: 1px solid #ddd; padding-right: 20px;"
                    ),
                    column(8,
                           tabsetPanel(
                             tabPanel(
                               title = "LLM interpretation results",
                               uiOutput("llm_interpretation_result"),
                               br(),
                               shinyjs::useShinyjs(),
                               downloadButton("download_llm_interpretation_result",
                                              "Download",
                                              class = "btn-primary",
                                              style = "background-color: #d83428; color: white;")
                             ),
                             tabPanel(
                               title = "Functional module table 1",
                               shiny::dataTableOutput("llm_enriched_functional_modules1")
                             ),
                             tabPanel(
                               title = "Functional module table 2",
                               shiny::dataTableOutput("llm_enriched_functional_modules2")
                             )
                           )
                    )
                  )))
      ),
      
      #### result tab
      tabItem(
        tabName = "results",
        fluidPage(titlePanel("Results and Report"),
                  fluidPage(
                    column(4,
                           br(),
                           fluidRow(
                             actionButton(
                               inputId = "generate_report",
                               label = "Generate report",
                               class = "btn-primary",
                               style = "background-color: #d83428; color: white;"
                             ),
                             shinyjs::useShinyjs(),
                             downloadButton("download_report",
                                            "Download",
                                            class = "btn-primary",
                                            style = "background-color: #d83428; color: white;"),
                             actionButton(
                               inputId = "show_report_code",
                               label = "Code",
                               class = "btn-primary",
                               style = "background-color: #d83428; color: white;"
                             )
                           ),
                           style = "border-right: 1px solid #ddd; padding-right: 20px;"
                    ),
                    column(8,
                           tabsetPanel(
                             tabPanel(
                               title = "Report",
                               uiOutput("mapa_report")
                             ))
                    )
                  )
        )
      )
    ),
    tags$footer(
      div(
        style = "background-color: #ecf0f4; display: flex; align-items: center; justify-content: left; padding: 10px; height: 80px; position: fixed; bottom: 0; width: 100%; z-index: 100; border-top: 1px solid #ccc;",
        tags$img(
          src = "shen_lab_logo.png",
          height = "50px",
          style = "margin-right: 15px;"
        ),
        div(
          HTML("The Shen Lab at Nanyang Technological University Singapore"),
          HTML("<br>"),
          tags$a(
            href = "http://www.shen-lab.org",
            target = "_blank",
            tags$i(class = "fa fa-house", style = "color: #e04c3c;"),
            " Shen Lab",
            style = "text-align: left; margin-left: 10px;"
          ),
          tags$a(
            href = "https://www.shen-lab.org/#contact",
            target = "_blank",
            tags$i(class = "fa fa-envelope", style = "color: #e04c3c;"),
            " Email",
            style = "text-align: left; margin-left: 10px;"
          ),
          tags$a(
            href = "https://github.com/jaspershen/mapa",
            target = "_blank",
            tags$i(class = "fa fa-github", style = "color: #e04c3c;"),
            " GitHub",
            style = "text-align: left; margin-left: 10px;"
          ),
          style = "text-align: left;"
        ),
        tags$img(
          src = "metid_logo.png",
          height = "50px",
          style = "margin-left: 15px;"
        )
      )
    )
  )
)
