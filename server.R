library(shiny)
library(maps)
library(ggplot2)

shinyServer(function(input, output) {
    # Get data from state dataset
    data(state)
    state_data <- data.frame(state.x77)
    state_data$State <- row.names(state_data)
    
    # Get map data
    states_map <- map_data("state")
    state_data$region <- tolower(rownames(state_data))
    state_data$State <- rownames(state_data)
    choro <- merge(states_map, state_data, sort = FALSE, by = "region")
    
    # Create a binding of state names with latitude, longitude coordinates
    state_names <- aggregate(cbind(long, lat) ~ region, data=states_map, FUN=function(x)mean(range(x)))
    state_names$region <- toupper(state_names$region)
    
    output$odataset_selected <- renderPrint({input$select})
    
    # Compute correlation coefficient as per chosen pair of variables
    output$corr <- renderText({
        if (input$first == 'Life Expectancy') {
            var1 <- 'Life.Exp'
        }
        else {
            var1 <- as.character(input$first)
        }
        if (input$second == 'Life Expectancy') {
            var2 <- 'Life.Exp'
        }
        else {
            var2 <- as.character(input$second)
        }
        paste("The correlation coefficient is", format(round(cor(state_data[, var1], state_data[, var2]), 2), nsmall = 2))
    })
    
    # Show data table as per variable chosen
    output$mytable <- renderDataTable({
        if (input$select == 'Population'){
            subset(state_data, select = c(State,Population))
        }
        else if (input$select == 'Income'){
            subset(state_data, select = c(State,Income))    
        }
        else if (input$select == 'Illiteracy'){
            subset(state_data, select = c(State,Illiteracy))    
        }
        else if (input$select == 'Life Expectancy'){
            subset(state_data, select = c(State,Life.Exp))    
        }
        else if (input$select == 'Murder'){
            subset(state_data, select = c(State,Murder))    
        }
    }, options = list(iDisplayLength = 5))
    
    # Create appropriate plot as per chosen variable
    output$mapPlot <- renderPlot({
        if (input$select == 'Population'){
            p <- ggplot(state_data, aes(map_id = region)) +
                      geom_map(aes(fill = Population), map = states_map) +
                      expand_limits(x = states_map$long, y = states_map$lat) + 
                      scale_fill_gradient(low="yellow", high="darkred") +
                      xlab("Longitude") +
                      ylab("Latitude")
            if (input$names == TRUE) {
                p <- p + geom_text(aes(x = long, y = lat, label=region), data=state_names, size=2)
            }
            print(p)
        }
        else if (input$select == 'Income'){
            p <- ggplot(state_data, aes(map_id = region)) +
                      geom_map(aes(fill = Income), map = states_map) +
                      expand_limits(x = states_map$long, y = states_map$lat) + 
                      scale_fill_gradient(low="lightgreen", high="darkgreen") +
                      xlab("Longitude") +
                      ylab("Latitude")
            if (input$names == TRUE) {
                p <- p + geom_text(aes(x = long, y = lat, label=region), data=state_names, size=2)
            }
            print(p)
            
        }
        else if (input$select == 'Illiteracy'){
            p <- ggplot(state_data, aes(map_id = region)) +
                      geom_map(aes(fill = Illiteracy), map = states_map) +
                      expand_limits(x = states_map$long, y = states_map$lat) + 
                      scale_fill_gradient(low="white", high="black") +
                      xlab("Longitude") +
                      ylab("Latitude")
            if (input$names == TRUE) {
                p <- p + geom_text(aes(x = long, y = lat, label=region), data=state_names, size=2)
            }
            print(p)
        }
        else if (input$select == 'Life Expectancy'){
            p <- ggplot(state_data, aes(map_id = region)) +
                      geom_map(aes(fill = Life.Exp), map = states_map) +
                      expand_limits(x = states_map$long, y = states_map$lat) +
                      xlab("Longitude") +
                      ylab("Latitude")
            if (input$names == TRUE) {
                p <- p + geom_text(aes(x = long, y = lat, label=region), data=state_names, size=2)
            }
            print(p)
        }
        else if (input$select == 'Murder'){
            p <- ggplot(state_data, aes(map_id = region)) +
                      geom_map(aes(fill = Murder), map = states_map) +
                      expand_limits(x = states_map$long, y = states_map$lat) + 
                      scale_fill_gradient(low="red", high="darkred") +
                      xlab("Longitude") +
                      ylab("Latitude")
            if (input$names == TRUE) {
                p <- p + geom_text(aes(x = long, y = lat, label=region), data=state_names, size=2)
            }
            print(p)
        }
    })
})