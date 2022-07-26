dashboardPage(
  dashboardHeader(title = "SynCIPHER"),
  dashboardSidebar(
    tags$style(HTML("
      .main-sidebar{
        position:fixed;
      }
    ")),
    fileInput(inputId='SeqsUpload',
              label='Choose Sequences',
              multiple=FALSE
#              accept=VALID_EXTENSIONS
    ),
    actionButton('alignseqs', "Align Sequences", 
                 class='btn-success', style='width:90%'),
    actionButton('findsyn', "Find Synteny", 
                 class='btn-warning', style='width:90%'),
    actionButton('findtree', "Find Phylogeny", 
                 class='btn-danger', style='width:90%')
  ),
  dashboardBody(
    fluidRow( id='defaultFluidRow',
      box( id='SeqBox',
        width = 8, status = "info", solidHeader = TRUE,
        title = "Sequences",
        htmlOutput('seqvis')
      ),
      box( id="DbBox",
        width = 4, status = "info", solidHeader=TRUE,
        title = "Database info",
        htmlOutput('dbvis')
      ))
  )
)