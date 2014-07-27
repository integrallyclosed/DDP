library(shiny)

shinyUI(pageWithSidebar(
    
    headerPanel("US Information by State"),
    
    sidebarPanel(
        tabsetPanel(
            tabPanel("Dataset", 
                     wellPanel(
                        radioButtons("select", h5("Select data set"), choices = list('Population', 'Income', "Illiteracy", "Life Expectancy", "Murder"), selected='Population'),
                        helpText("The map on the right will be color coded by the value of the chosen variable for each state")
                    ),
                    wellPanel(
                        helpText(h5("Compute correlation coefficient between variables")),
                        selectInput("first", "Select first variable", choices = list('Population', 'Income', "Illiteracy", "Life Expectancy", "Murder"), selected='Population'),
                        selectInput("second", "Select second variable", choices = list('Population', 'Income', "Illiteracy", "Life Expectancy", "Murder"), selected='Income'),
                        verbatimTextOutput("corr")
                    )
            ),
            tabPanel("Help", 
                        helpText("The data for this visualization comes from the state dataset. More information can be found here "),
                        helpText(a("http://stat.ethz.ch/R-manual/R-devel/library/datasets/html/state.html", href="http://stat.ethz.ch/R-manual/R-devel/library/datasets/html/state.html", target="blank")),
                        helpText("Population is measured in 1000s and is as per an estimate from July 1, 1975."),
                        helpText("Income is per capita income as of 1974."),
                        helpText("Illiteracy is a percentage of population as of 1970."),
                        helpText("Life expectancy is in years as per 1969-71 data."),
                        helpText("The Murder variable indicates murder and non-negligent manslaughter rate per 100,000 population as of 1976.")
            )
        )
    ),
    
    mainPanel(
        plotOutput("mapPlot"),
        checkboxInput("names", "Show state names", value = FALSE),
        helpText("Note: Search is case sensitive"),
        dataTableOutput('mytable')
    )
))