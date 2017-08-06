library("ElemStatLearn")
library("class")
library("plotrix")
train <- mixture.example$x
trainclass <- mixture.example$y
test <- mixture.example$xnew
pts1 <- mixture.example$px1
pts2 <- mixture.example$px2


shinyServer(function(input, output, session) {
  
  idx  <- NULL
  dmat <- NULL
  ## ID the point clicked on 
  xy  <- reactive(c(input$click_plot$x, input$click_plot$y))
  id <- observe({
    if (!is.null(xy())) {
      dmat <- as.matrix(dist(rbind(xy(), train)))
      idx <<- which.min(dmat[1, -1])
      dmat <<- dmat[-1, -1]
    }
  })
  
  
  output$plot1 <- renderPlot({
    xy()
    ## Fit model
    fit <- knn(train = train, test = test, cl = trainclass, k = input$k, prob = TRUE)
    probs <- matrix(fit, length(pts1), length(pts2))
    
    ## Plot create empty plot
    plot(train, asp = 1, type = "n", xlab = "x1", ylab = "x2", 
         xlim = range(pts2), ylim = range(pts2), main =  paste0(input$k, "-Nearest Neighbours"))
    

    
    ## Plot the grid
    grid <- expand.grid(x = pts1, y = pts2)
    points(grid, pch = 20, cex = 0.2, col = ifelse(probs > 0.5, "coral", "cornflowerblue"))
    points(train, col = ifelse(trainclass == 1, "coral", "cornflowerblue"), cex = 1.5, pch = 21, lwd = 2)
    
    ## Add decision boundary
    contour(pts1, pts2, probs, levels = 0.5, labels = "", lwd = 1.5, add = TRUE)
    

    
  })
  
})