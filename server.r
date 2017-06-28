# server.R

shinyServer(function(input, output, session) {
  
  #- analytic view
  
  #- it tbl
  create_dtit_wrapper <- reactive({ 
    create_dtit(input, output, session) 
  })
  
  output$dtit <- DT::renderDataTable(
    create_dtit_wrapper()
  )
  
  #- bn tbl
  create_dtbn_wrapper <- reactive({ 
    create_dtbn(input, output, session) 
  })
  
  output$dtbn <- DT::renderDataTable(
    create_dtbn_wrapper()
  )
  
  #- sn tbl
  create_dtsn_wrapper <- eventReactive(
    input$avbt, { 
      create_dtsn(input, output, session) 
    }
  )
  
  output$dtsn <- DT::renderDataTable(
    create_dtsn_wrapper()
  )
  
  #- sn rgl
  create_rgsn_wrapper <- eventReactive(
    input$avvw, {
      create_rgsn(input, output, session)  
    }
  )
  
  output$rgsn <- rgl::renderRglwidget({
    create_rgsn_wrapper()
  })
  
  
  #- download handler
  output$downloadit <- downloadHandler(
    
    filename = function() { "orderListTableTemplate.csv" },
    
    content = function(file) {
      
      write.table(
        x = default_dtit, file = file, quote = TRUE,  sep = ",",
        row.names = FALSE, col.names = TRUE
      )
      
    }
    
  )
  
  output$downloadbn <- downloadHandler(
    
    filename = function() { "binListTableTemplate.csv" },
    
    content = function(file) {
      
      write.table(
        x = default_dtbn, file = file, quote = TRUE,  sep = ",",
        row.names = FALSE, col.names = TRUE
      )
      
    }
    
  )
  
  output$downloadsn <- downloadHandler(
    
    filename = function() { "binPackingSolutionTable.csv" },

    content = function(file) {
      
      if (exists("dtsn")) {
        
        write.table(
          x = dtsn[["it"]], file = file, quote = TRUE,  sep = ",",
          row.names = FALSE, col.names = TRUE
        )
        
      } else {
        
        warning("output$downloadsn: no packing solution found.\n")
        
      }
      
    }
    
  )
  
})