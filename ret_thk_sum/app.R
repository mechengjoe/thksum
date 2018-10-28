#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for data upload app ----
ui <- fluidPage(
   
   # Application title ----
   titlePanel("Upload Files"),
   
   #Sidebar layout with input and output defintitions ---- 
   sidebarLayout(
     
     #Sidebar panel for inputs ----
      sidebarPanel(
        
        #Input: Select a file ----
         fileInput("file1", "Choose CSV File",
                   multiple = TRUE,
                   accept = c("text/csv",
                              "text/comma-separated-values,text/plain",
                              ".csv")),
         
         #Horizontal line ----
         tags$hr(),
         
         #Input: Checkbox if file has header ----
         checkboxInput("header", "Header", TRUE),
         
         #Input; Select separator ----
         radioButtons("sep", "Separator",
                      choices = c(Comma = ",",
                                  Semicolon = ";",
                                  Tab = "\t"),
                      selected = '"'),
         
         #horizontal line ----
         tags$hr(),
         
         #Input: Select number of rows to display ----
         radioButtons("disp", "Display",
                      choices = c(Head = "head",
                                  All = "all"),
                      selected = "head")
      ),
      
      # Main panel for displaying outputs ----
      mainPanel(
        
        #Output: Data file ----
         tableOutput("contents")
      )
   )
)

# Define server logic to read selected file ----
server <- function(input, output) {
   
  output$contents <- renderTable({
    
    #input$file1 will be NULL initially.  After the user selects and uploads
    #a file, head of that data file by default, or all rows if selected, will be shown
    
    req(input$file1)
    
    df <- read.csv(input$file1$datapath,
                   header = input$header,
                   sep = input$sep,
                   quote = input$quote,
                   stringsAsFactors = FALSE)
    
    df[,3] <- as.numeric(as.character(df[,3]))
    
    if(input$disp == "head"){
      return(head(df))
    }
    else{
      return(df)
    }
      
   })
}

# Run the app ---- 
shinyApp(ui = ui, server = server)

