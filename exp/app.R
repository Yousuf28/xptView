library(shiny)

# Define UI for data upload app ----
ui <- fluidPage(

  # App title ----
  # titlePanel("Uploading Files"),

  # Sidebar layout with input and output definitions ----
  # sidebarLayout(

    # Sidebar panel for inputs ----
    # sidebarPanel(width = 2,

      # Input: Select a file ----
      # fileInput("file1", "Choose CSV File",
      #           multiple = FALSE,
      #           accept = c("text/csv",
      #                    "text/comma-separated-values,text/plain",
      #                    ".csv")),
      
      shiny::fileInput('file1', "Choose xpt file",
                       accept = '.xpt'),

      # Horizontal line ----
      # tags$hr(),

      # Input: Checkbox if file has header ----
      # checkboxInput("header", "Header", TRUE),

      # Input: Select separator ----
      # radioButtons("sep", "Separator",
      #              choices = c(Comma = ",",
      #                          Semicolon = ";",
      #                          Tab = "\t"),
      #              selected = ","),

      # Input: Select quotes ----
      # radioButtons("quote", "Quote",
      #              choices = c(None = "",
      #                          "Double Quote" = '\\"',
      #                          "Single Quote" = "'"),
      #              selected = '\\"'),

      # Horizontal line ----
      tags$hr(),

      # Input: Select number of rows to display ----
    #   radioButtons("disp", "Display",
    #                choices = c(Head = "head",
    #                            All = "all"),
    #                selected = "head")
    # 
    

    # Main panel for displaying outputs ----
    # mainPanel(

      # Output: Data file ----
      # rhandsontable::rHandsontableOutput('contents')
      # tableOutput("contents")
      DT::DTOutput('contents')

    # )

  
)

# Define server logic to read selected file ----
server <- function(input, output) {

  # output$contents <- renderTable({
  # output$contents <- rhandsontable::renderRHandsontable({
  output$contents <- DT::renderDT({

    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.

    req(input$file1)

    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        # df <- read.csv(input$file1$datapath,
        #          header = input$header,
        #          sep = input$sep,
        #          quote = input$quote)
        df <- haven::read_xpt(input$file1$datapath)
        # df <- rhandsontable::rhandsontable(df)
        df
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )

    # if(input$disp == "head") {
    #   return(head(df))
    # }
    # else {
    #   return(df)
    # }

  })

}

# Create Shiny app ----
shinyApp(ui, server)