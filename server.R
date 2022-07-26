library(DECIPHER)
library(SynExtend)
source('global.R')

#SeqSet <- NULL
#AliSet <- NULL

TABLENAME <- '1111seqs'

function(input, output, session){
  seqfile <- reactive({
    req(input$SeqsUpload)
    return(input$SeqsUpload)
  })
  
  numSeqs <- reactive({
    f <- seqfile()
    fpath <- f$datapath
    fname <- gsub('^([A-z0-9]*)\\..*', '\\1', f$name)
    ids <- as.character(fasta.index(fpath)$recno)
    Seqs2DB(seqs=fpath, type='FASTA', dbFile=dbConn, 
            identifier=ids, replaceTbl=TRUE)  
  })
  
  observeEvent(numSeqs(), {
    x <- seqsHTMLGen(output)
    output$seqvis <- x$seqvis
    output$dbvis <- x$dbvis
    })
  
  ## Alignment
  observeEvent(input$alignseqs, addAliElem(input))
  
  ## Find Synteny
  observeEvent(input$findsyn, addSynElem(input))
  
  ## Build Phylogenies
  observeEvent(input$findtree, addTreeElem(input))
}