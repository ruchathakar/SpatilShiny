library(shiny)

ui <- fluidPage(
   
   titlePanel("Interactive Application for studying features in counties in California"),
   
   sidebarLayout(
     sidebarPanel(NULL),
     
     mainPanel(tabsetPanel(type = "tab",
                           
                           tabPanel("Review Selection", 
                                    selectInput("county", "Select counties",
                                                choices = unique(CAdata$county),
                                                selectize = TRUE),
                                    textOutput ("countyselection")),
                           
                           
                           tabPanel("Summary Data",
                                    textOutput("summarytext"),
                                    tableOutput ("summarytable"),
                                    plotOutput("featureplot")),
                           
                           tabPanel("Feature Selection",
                                    selectInput("feature", "Select feature", choices = "")),
                           
                           tabPanel("Map", 
                                    textOutput("MapText"), 
                                    leafletOutput("MapPlot")))
               )
        
        )
      )


# Define server logic required to draw a histogram
server <- function(session, input, output) {
  
   observe(
     updateSelectInput(session, "feature",
                       choices = unique(subset(CAdata$feature_class, 
                                              CAdata$county == paste("", input$county,sep = ""))))
   )
  
  output$countyselection <- renderText({
    paste ("You can select only one county in California, USA for this study. This tab confirms that you have selected to study", paste("", input$county, sep = ""), "county. Please proceed to the next page to see all the features present in this county.")
  })
  
  
  output$summarytext <- renderText({
    paste ("This tab summarizes the type and number of features available to study in", paste ("", input$county, sep =""), "county.
           In the next tab, please select the feature in", paste ("", input$county, sep =""), "county you are most interested in.")
  })
  
  output$summarytable <- renderTable(
    CAdata %>% filter(county == paste("", input$county, sep = "")) %>% count(feature_class, sort = TRUE)
  )
  
  output$featureplot <- renderPlot(
    ggplot(CAdata %>% filter(county == paste("", input$county, sep = "")) %>% 
        count(feature_class, sort = TRUE), 
      aes(x=feature_class, y=n))+
      geom_col(col = "navyblue")+
      theme_minimal()+
      labs(x = "Feature Type", y= "Number of features")+
      theme(axis.text.x=element_text(angle = -90, hjust = 0))+
      scale_x_discrete()
  )

  
  
  output$MapPlot <- renderLeaflet({
    data <- subset(CAdata, county == paste("", input$county, sep = "") & feature_class == paste ("", input$feature, sep =""))
                   
    leaflet(data) %>%
      addTiles()%>%
      addMarkers(lng = data$primary_longitude, 
                 lat = data$primary_latitude,
                 popup = data$feature_name,
                 clusterOptions = markerClusterOptions())
  })
  
  output$MapText <- renderText ({
    paste("This interactive map shows the location of", paste ("", input$feature, sep =""), "in", paste ("", input$county, sep =""), "county, CA. You can zoom into the area of interest. Clicking on indiviual points will tell you the name of the", paste ("", input$feature, sep =""))
    })
}


# Run the application 
shinyApp(ui = ui, server = server)

