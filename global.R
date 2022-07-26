library(shiny)
library(shinydashboard)

VALID_EXTENSIONS <- c('.fasta', '.fa', '.fas', '.fna', '.fa.gz')

MAX_WIDTH_SEQS <- 5000
# onStop(function() {
#   file.remove('www/dbvis.html')
#   file.remove('www/seqvis.html')
# })

SeqSet <- NULL
AliSet <- NULL
DBPATH <- 'data/SeqsDB.sqlite'
dbConn <- dbConnect(SQLite(), DBPATH)

seqsHTMLGen <- function(output){
  {
    outval <- list()
    SeqSet <<- SearchDB(dbConn)
    BrowseSeqs(SeqSet, 'www/seqvis.html', openURL=FALSE)
    BrowseDB(dbConn, 'www/dbvis.html', openURL=FALSE)
    outval$dbvis <- renderUI({
      req(!is.null(SeqSet))
      HTML(readLines('www/dbvis.html'))
    })
    outval$seqvis <- renderUI({
      req(!is.null(SeqSet))
      htmllines <- readLines('www/seqvis.html')
      # <pre> block starts at the 3rd entry and ends at end
      for ( i in 4:length(htmllines) )
        htmllines[i] <- paste0(htmllines[i], '<br>')
      HTML(htmllines)
    })
  }
  return(outval)
}

addAliElem <- function(input){
  if (is.null(SeqSet)){
    showNotification("No sequences loaded.", type='warning')
  }
  req(!is.null(SeqSet))
  req(max(width(SeqSet)) < MAX_WIDTH_SEQS)
  showNotification("Aligning sequences...", type='warning')
  AliSet <<- AlignSeqs(SeqSet)
  BrowseSeqs(AliSet, 'www/alivis.html', FALSE)
  alivislines <- readLines('www/alivis.html')
  # <pre> block starts at the 3rd entry and ends at end
  for ( i in 4:length(alivislines) )
    alivislines[i] <- paste0(alivislines[i], '<br>')
  uielem <- fluidRow( id='alignFluidRow',
                      box(
                        width = 8, status = "info", solidHeader = TRUE,
                        title = "Alignment",
                        HTML(alivislines),
                        tags$script("$( document ).ready(function() {
                                setTimeout(function() {
                                  window.scrollTo({
                                    left:0,
                                    top:document.getElementById('alignFluidRow').scrollHeight,
                                    behavior: 'smooth'
                                  });
                              }, 200)
                           })"
                        )
                      )
  )
  if (input$alignseqs > 1){
    removeUI(selector='#alignFluidRow', immediate=TRUE)
  }
  if(!is.null(input$findsyn) && input$findsyn > 0)
    loctoadd <- "#synFluidRow"
  else 
    loctoadd <- "#defaultFluidRow"
  insertUI(selector=loctoadd,
           where='afterEnd',
           ui=uielem)
  showNotification("Alignment completed!", type='message')
}

addSynElem <- function(input){
    #showNotification("This doesn't work yet", type='error')
    if (is.null(SeqSet)){
      showNotification("No sequences loaded!", type='error')
    }
    req(!is.null(SeqSet))
    showNotification("Finding synteny...", type='warning')
    syn <- FindSynteny(dbConn)
    #output$synvis <- renderPlot(plot(syn))
    uielem <- fluidRow( id='synFluidRow',
                        box(
                          width = 8, status = "info", solidHeader = TRUE,
                          title = "Syntenic Hits",
                          renderPlot(plot(syn)),
                          tags$script("$( document ).ready(function() {
                                setTimeout(function() {
                                  window.scrollTo({
                                    left:0,
                                    top:document.getElementById('synFluidRow').scrollHeight,
                                    behavior: 'smooth'
                                  });
                              }, 200)
                           })"
                          )
                        )
    )
    if (input$findsyn > 1){
      removeUI(selector='#synFluidRow', immediate=TRUE)
    }
    insertUI(selector="#defaultFluidRow",
             where='afterEnd',
             ui=uielem)
    showNotification("Synteny completed!", type='message')
}

addTreeElem <- function(input){
  if (is.null(AliSet)){
    showNotification('Sequences are not aligned!', type='warning')
  }
  req(!is.null(AliSet))
  showNotification("Building tree...", type='warning')
  tree <- TreeLine(AliSet, method='MP')
  #output$treevis <- renderPlot(plot(tree))
  uielem <- fluidRow( id='treeFluidRow',
                      box(
                        width = 8, status = "info", solidHeader = TRUE,
                        title = "Phylogenetic Reconstruction",
                        renderPlot(plot(tree)),
                        tags$script("$( document ).ready(function() {
                                setTimeout(function() {
                                  window.scrollTo({
                                    left:0,
                                    top:document.body.scrollHeight,
                                    behavior: 'smooth'
                                  });
                              }, 200)
                           })"
                        )
                      )
  )
  if (input$findtree > 1){
    removeUI(selector='#treeFluidRow', immediate=TRUE)
  }
  insertUI(selector="#alignFluidRow",
           where='afterEnd',
           ui=uielem)
  showNotification('Finished building tree!', type='message')
}