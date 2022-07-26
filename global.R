library(shiny)
library(shinydashboard)

VALID_EXTENSIONS <- c('.fasta', '.fa', '.fas', '.fna', '.fa.gz')

MAX_WIDTH_SEQS <- 5000
# onStop(function() {
#   file.remove('www/dbvis.html')
#   file.remove('www/seqvis.html')
# })