#------------------------------------------------------------------------------#
#--------------------------------- shiny apps ---------------------------------#
#------------------------- author: gyang274@gmail.com -------------------------#
#------------------------------------------------------------------------------#

#--------+---------+---------+---------+---------+---------+---------+---------#
#234567890123456789012345678901234567890123456789012345678901234567890123456789#

#------------------------------------------------------------------------------#
#----------------------------- shine color schema -----------------------------#
#------------------------------------------------------------------------------#

#---------------------- color schema on datatable header ----------------------#

# DTHeaderCC <- "function(settings, json) {
#   $(this.api().table().header()).css({'background-color': '#ffd9b3', 'color': '#000000'});
#   $(this.api().table().body()  ).css({'background-color': '#d2d6de', 'color': '#000000'});
# }"

DTHeaderCCInfo <- "function(settings, json) {
  $(this.api().table().header()).css({'background-color': '#d9edf7', 'color': '#000000'});
  $(this.api().table().body()  ).css({'background-color': '#d2d6de', 'color': '#000000'});
}"

DTHeaderCCWarning <- "function(settings, json) {
  $(this.api().table().header()).css({'background-color': '#fcf8e3', 'color': '#000000'});
  $(this.api().table().body()  ).css({'background-color': '#d2d6de', 'color': '#000000'});
}"

DTHeaderCCSuccess <- "function(settings, json) {
  $(this.api().table().header()).css({'background-color': '#dff0d8', 'color': '#000000'});
  $(this.api().table().body()  ).css({'background-color': '#d2d6de', 'color': '#000000'});
}"
#------------------------------------------------------------------------------#


