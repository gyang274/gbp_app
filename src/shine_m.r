#------------------------------------------------------------------------------#
#--------------------------------- shiny apps ---------------------------------#
#------------------------- author: gyang274@gmail.com -------------------------#
#------------------------------------------------------------------------------#

#--------+---------+---------+---------+---------+---------+---------+---------#
#234567890123456789012345678901234567890123456789012345678901234567890123456789#

#------------------------------------------------------------------------------#
#------------------------------------ main ------------------------------------#
#------------------------------------------------------------------------------#

#' create_dtit
create_dtit <- function(input, output, session) {
  
  dtit <<- NULL
  
  if (!is.null(input$avit)) {
      
    dtit <<- data.table::as.data.table(
      x = read.csv(input$avit$datapath)
    )
    
    if (!(
      dim(dtit)[2] == 6L && all(colnames(dtit)) == c("oid", "sku", "l", "d", "h", "w")
    )) {
      
      shinyBS::createAlert(
        session, anchorId = "fileInputAlertIt", alertId = "create_dtit_fileInputAlertIt",
        title = "gbp", content = paste0(
          'The order list data should have 6 columns named as oid, sku, l, d, h, w. Try download and modify the order list table template?'
        ),
        style = "info"
      )
      
      dtit <<- NULL
      
    } else {
      
      dtitsm <- dtit[ , .(n = .N), by = "oid"]
      
      if (max(dtitsm[["n"]], na.rm = TRUE) > 89L || nrow(dtitsm) > 144L) {
        
        shinyBS::createAlert(
          session, anchorId = "fileInputAlertIt", alertId = "create_dtit_fileInputAlertIt",
          title = "gbp", content = paste0(
            'This is a demo site. The order list data should have at most 89 items in a single order, and at most 144 orders in total.'
          ),
          style = "info"
        )
        
        dtit <<- NULL
        
      }
      
    }
       
  }
  
  if (is.null(dtit)) {
      
    dtit <<- default_dtit
        
  }
  
  #- render 
  dtitDT <- dtit %>%
    # mutate(
    #   colname = enc2utf8(colname)
    # ) %>%
    DT::datatable(
      # extensions = c("Buttons", "FixedHeader", "FixedColumns"),
      options = list(
        # dom = "lBfrtip", 
        dom = "ltp",
        # buttons = c('copy', 'csv', 'excel', 'pdf', 'print', 'colvis'),
        # fixedHeader = TRUE,
        # scrollX = TRUE,
        # fixedColumns = list(leftColumns = 1L, rightColumns = 0L),
        pageLength = 10L,
        lengthMenu = c(10L, 20L, 30L, 50L),
        initComplete = JS(
          DTHeaderCCInfo
        )
      ), 
      rownames = TRUE,
      colnames = c(
        "Order ID" = "oid",
        "SKU" = "sku",
        "Length" = "l",
        "Depth"  = "d",
        "Height" = "h",
        "Weight" = "w"
      ),
      escape = FALSE
    ) %>%
    DT::formatRound(
      columns = c("Length", "Depth", "Height", "Weight"), digits = 2L
    )
  
  return(dtitDT)
  
}

#' create_dtbn
create_dtbn <- function(input, output, session) {
  
  dtbn <<- NULL
  
  if (!is.null(input$avbn)) {
    
    dtbn <<- data.table::as.data.table(
      x = read.csv(input$avbn$datapath)
    )
    
    if (!(
      dim(dtbn)[2] == 4L && all(colnames(dtbn)) == c("id", "l", "d", "h")
    )) {
      
      shinyBS::createAlert(
        session, anchorId = "fileInputAlertBn", alertId = "create_dtbn_fileInputAlertBn",
        title = "gbp", content = paste0(
          'The bin list data should have 4 columns named as id, l, d, h. Try download and modify the bin list table template?'
        ),
        style = "info"
      )
      
      dtbn <<- NULL
      
    } else {
      
      dtbnsm <- dtbn[ , .(n = .N), by = "id"]
      
      if (max(dtbnsm[["n"]], na.rm = TRUE) > 1L || nrow(dtbnsm) > 10L) {
        
        shinyBS::createAlert(
          session, anchorId = "fileInputAlertBn", alertId = "create_dtbn_fileInputAlertBn",
          title = "gbp", content = paste0(
            'This is a demo site. The bin list data should have at most 10 bins in total, and also each bin must be uniquely identified by `id`.'
          ),
          style = "info"
        )
        
        dtbn <<- NULL
        
      }
      
    }
    
  }
  
  if (is.null(dtbn)) {
    
    dtbn <<- default_dtbn
    
  }
  
  #- render 
  dtbnDT <- dtbn %>%
    # mutate(
    #   colname = enc2utf8(colname)
    # ) %>%
    DT::datatable(
      # extensions = c("Buttons", "FixedHeader", "FixedColumns"),
      options = list(
        # dom = "lBfrtip", 
        dom = "tp",
        # buttons = c('copy', 'csv', 'excel', 'pdf', 'print', 'colvis'),
        # fixedHeader = TRUE,
        # scrollX = TRUE,
        # fixedColumns = list(leftColumns = 1L, rightColumns = 0L),
        pageLength = 10L,
        # lengthMenu = c(10L, 20L, 30L, 50L),
        lengthMenu = "",
        initComplete = JS(
          DTHeaderCCWarning
        )
      ), 
      rownames = TRUE,
      colnames = c(
        "Bin ID" = "id",
        "Length" = "l",
        "Depth"  = "d",
        "Height" = "h",
        "Weight Limit" = "w"
      ),
      escape = FALSE
    ) %>%
    DT::formatRound(
      columns = c("Length", "Depth", "Height", "Weight Limit"), digits = 2L
    )
  
  return(dtbnDT)
  
}

#' create_dtsn
create_dtsn <- function(input, output, session) {
  
  .ptc <- proc.time()
  
  dtsn <<- bpp_solver(it = dtit, bn = dtbn)
  
  .ptd <- proc.time() - .ptc
  
  #- sn msg
  output$mssn <- shiny::renderText(
    paste0(
      "bpp_solver: find packing solution on ", length(unique(dtit[["oid"]])), " orders ", 
      nrow(dtit), " items in ", round(.ptd[3], 2L), " seconds."
    )
  )
  
  #- sn tbl
  dtsnDT <- dtsn[["it"]] %>%
    # mutate(
    #   colname = enc2utf8(colname)
    # ) %>%
    DT::datatable(
      # extensions = c("Buttons", "FixedHeader", "FixedColumns"),
      options = list(
        # dom = "lBfrtip", 
        dom = "ltp",
        # buttons = c('copy', 'csv', 'excel', 'pdf', 'print', 'colvis'),
        # fixedHeader = TRUE,
        # scrollX = TRUE,
        # fixedColumns = list(leftColumns = 1L, rightColumns = 0L),
        pageLength = 10L,
        lengthMenu = c(10L, 20L, 30L, 50L),
        initComplete = JS(
          DTHeaderCCSuccess
        )
      ), 
      rownames = TRUE,
      colnames = c(
        "Order ID" = "oid",
        "SKU" = "sku",
        "Ticket ID" = "tid",
        "OrderTicket ID" = "otid",
        "X" = "x",
        "Y" = "y",
        "Z" = "z",
        "Length" = "l",
        "Depth"  = "d",
        "Height" = "h",
        "Weight" = "w"
      ),
      escape = FALSE
    ) %>%
    DT::formatRound(
      columns = c("X", "Y", "Z", "Length", "Depth", "Height", "Weight"), digits = 2L
    )
  
  #- sn rgl ui
  updateSelectInput(
    session, inputId = "avsn", choices = unique(dtsn$it[["otid"]])
  )
  
  return(dtsnDT)
  
}

#' create_rgsn
create_rgsn <- function(input, output, session) {
  
  # try(rgl::rgl.close())
  
  if (input$avsn == "" || !(exists("dtsn"))) {
    rgl::open3d()
    rgl::bg3d("#f0f2f4")
    rgl::rglwidget()
    return(NULL)
  }

  lkit <- dtsn[["it"]][otid == input$avsn]

  lkbn <- dtsn[["bn"]][id == unique(lkit[["bid"]])]

  bpp_viewer_single(
    it = lkit, bn = lkbn, title = NULL, subtitle = NULL
  )

  rgl::rglwidget()
 
}

#------------------------------------------------------------------------------#