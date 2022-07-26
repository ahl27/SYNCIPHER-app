library(DECIPHER)
library(SynExtend)
source('global.R')

SeqSet <- NULL
AliSet <- NULL
DBPATH <- 'data/SeqsDB.sqlite'
dbConn <- dbConnect(SQLite(), DBPATH)

function(input, output, session){
  seqfile <- reactive({
    req(input$SeqsUpload)
    return(input$SeqsUpload)
  })
  
  numSeqs <- reactive({
    f <- seqfile()
    fpath <- f$datapath
    fname <- tools::file_path_sans_ext(f$name)
    Seqs2DB(fpath, 'FASTA', dbConn, fname, replaceTbl=TRUE)  
  })
  
  observeEvent(numSeqs(), {
    SeqSet <<- SearchDB(dbConn)
    BrowseSeqs(SeqSet, 'www/seqvis.html', openURL=FALSE)
    BrowseDB(dbConn, 'www/dbvis.html', openURL=FALSE)
    output$dbvis <- renderUI({
      req(!is.null(SeqSet))
      HTML(readLines('www/dbvis.html'))
    })
    output$seqvis <- renderUI({
      req(!is.null(SeqSet))
      htmllines <- readLines('www/seqvis.html')
      # <pre> block starts at the 3rd entry and ends at end
      for ( i in 4:length(htmllines) )
        htmllines[i] <- paste0(htmllines[i], '<br>')
      HTML(htmllines)
    })
  })
  
  observeEvent(input$alignseqs, {
      if (is.null(SeqSet)){
        showNotification("No sequences loaded.", type='warning')
      }
      req(!is.null(SeqSet))
      req(max(width(SeqSet)) < MAX_WIDTH_SEQS)
      showNotification("Aligning sequences...", type='warning')
      AliSet <<- AlignSeqs(SeqSet)
      BrowseSeqs(AliSet, 'www/alivis.html', FALSE)
      output$alivis <- renderUI({
        htmllines <- readLines('www/alivis.html')
        # <pre> block starts at the 3rd entry and ends at end
        for ( i in 4:length(htmllines) )
          htmllines[i] <- paste0(htmllines[i], '<br>')
        HTML(htmllines)
      })
      showNotification("Alignment completed!", type='message')
    })
  
  observeEvent(input$findsyn, {
    showNotification("This doesn't work yet", type='error')
    if (is.null(SeqSet)){
      showNotification("No sequences loaded!", type='error')
    }
    req(!is.null(SeqSet))
    showNotification("Finding synteny...", type='warning')
    #syn <- FindSynteny(dbConn)
    #output$synvis <- renderPlot(plot(syn))
    showNotification("Synteny completed!", type='message')
  })
  observeEvent(input$findtree, {
    if (is.null(AliSet)){
      showNotification('Sequences are not aligned!', type='warning')
    }
    req(!is.null(AliSet))
    showNotification("Building tree...", type='warning')
    tree <- TreeLine(AliSet, method='MP')
    output$treevis <- renderPlot(plot(tree))
    showNotification('Finished building tree!', type='message')
  })
}