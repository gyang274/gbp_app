# ui.R

shinyUI(navbarPage(
  
  title = "gbp: a bin packing problem solver", theme = "css/ygtheme.css", id = "nav",
  
  tabPanel(
    
    title = "Analytic View",
    
    tags$head(
      
      tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css"),
      
      tags$script(src = "js/enter_as_click.js")
      
    ),
    
    tags$div(
      
      class = "main",
      
      #- main analytic view
      sidebarLayout(
        
        sidebarPanel = sidebarPanel(
          
          HTML('<div align="center">'),
          
          h4("Order Packing Inputs"),
          
          HTML('</div>'),
          
          fileInput(
            inputId = "avit", label = "Upload Order List Data"
          ),
          
          HTML('<div align="right">'),
          
          # downloadButton(
          #   outputId = "downloadit", label = "Download Order List Table Template", class = "btn-primary"
          # ),
          tags$a(
            id = "downloadit", class = paste("btn btn-default shiny-download-link", "btn-primary"), 
            href = "", target = "_blank", style = "width: 70%", icon("download"), 
            "Download Order List Table Template"
          ),
          
          HTML('</div>'),
          
          br(),
          
          fileInput(
            inputId = "avbn", label = "Upload Bin List Data"
          ),
          
          HTML('<div align="right">'),
          
          # downloadButton(
          #   outputId = "downloadbn", label = "Download Bin List Table Template", class = "btn-primary"
          # ),
          tags$a(
            id = "downloadbn", class = paste("btn btn-default shiny-download-link", "btn-primary"), 
            href = "", target = "_blank", style = "width: 70%", icon("download"), 
            "Download Bin List Table Template"
          ),
          
          HTML('</div>'),
          
          br(),
          
          HTML('<div align="center">'),
          
          h4("Order Packing doPack"),
          
          shinyBS::bsButton(
            
            inputId = "avbt", label = HTML("&nbsp;&nbsp;Create Packing Solution"), 
            
            icon = icon("dropbox"), 
            
            style = "primary", type = "action", width = "85%"
            
          ),
          
          HTML('</div>'),
          
          br(),
          
          HTML('<div align="center">'),
          
          h4("Order Packing Output"),
          
          HTML('</div>'),
          
          selectInput(
            inputId = "avsn", label = "Select an Order Ticket ID from Packing Solution", 
            choices = c(""), width = "100%"
          ),
          
          HTML('<div align="right">'),
          
          shinyBS::bsButton(
            
            inputId = "avvw", label = HTML("&nbsp;&nbsp;Create Single Ticket 3D View"), 
            
            icon = icon("dropbox"), 
            
            style = "primary", type = "action", width = "85%"
            
          ),
          
          HTML('</div>'),
          
          br(),
          
          HTML('<div align="center">'),
          
          # downloadButton(
          #   outputId = "downloadsn", label = "Download Packing Solution Table", class = "btn-primary"
          # ),
          tags$a(
            id = "downloadsn", class = paste("btn btn-default shiny-download-link", "btn-primary"), 
            href = "", target = "_blank", style = "width: 85%", icon("download"), 
            "Download Packing Solution Table"
          ),
          
          HTML('</div>')
          
        ),
        
        mainPanel = mainPanel(
          
          bsCollapse(
            
            id = "av_main", open = c("av_main_pan_it", "av_main_pan_bn", "av_main_pan_sn"),
            
            multiple = TRUE,
            
            bsCollapsePanel(
              
              title = "Order List Data", value = "av_main_pan_it", style = "info",
              
              shinyBS::bsAlert(anchorId = "fileInputAlertIt"),
                  
              DT::dataTableOutput(outputId = 'dtit')
              
            ),
            
            bsCollapsePanel(
              
              title = "Bin List Data", value = "av_main_pan_bn", style = "warning",
              
              shinyBS::bsAlert(anchorId = "fileInputAlertBn"),
                  
              DT::dataTableOutput(outputId = 'dtbn')
              
            ),
          
            bsCollapsePanel(
              
              title = "Order Packing Solution", value = "av_main_pan_sn", style = "success",
              
              tabsetPanel(
                
                id = "av_sn", selected = "av_sn", type = "tabs", position = "above",
                
                tabPanel(
                  
                  title = "Packing Solution Table", value = "av_sn_tbl", icon = icon("database"),
                  
                  h4(textOutput(outputId = "mssn")),
                  
                  DT::dataTableOutput(outputId = "dtsn")
                  
                ),
                
                tabPanel(
                  
                  title = "Packing Solution Single Ticket 3D View", value = "av_sn_rgl", icon = icon("dropbox"),
                  
                  HTML('<div align="center">'),
                  
                  rgl::rglwidgetOutput(outputId = "rgsn"),
                  
                  HTML('</div>')
                  
                )
                
              )
              
            )
            
          )
          
        ),
        
        position = "right"
        
      ),

      tags$div(
        
        id = "cite", tags$em('gbp - a bin packing solver.'), "Please contact", a(href="mailto:gyang274@gmail.com", "the author"), "for further development."
        
      )
      
    ),
    
    tags$div(
      
      class = "msgs", textOutput(outputId = "msgs")
      
    )
    
  ),
  
  tabPanel(
    
    title = "README",
    
    includeMarkdown("README.md")
    
  )

))
