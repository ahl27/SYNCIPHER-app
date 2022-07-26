dashboardPage(
  dashboardHeader(title = "SynCIPHER"),
  dashboardSidebar(
    fileInput(inputId='SeqsUpload',
              label='Choose Sequences',
              multiple=FALSE
#              accept=VALID_EXTENSIONS
    ),
    sidebarMenu(
      id='menusel',
      actionButton('alignseqs', "Align Sequences", class='btn-success'),
      actionButton('findsyn', "Find Synteny", class='btn-warning'),
      actionButton('findtree', "Find Phylogeny", class='btn-danger')
    )
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