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
      menuItem("Database", tabName = "db"),
      menuItem("Sequences", tabName = "seqs"),
      actionButton('alignseqs', "Align Sequences", class='btn-success'),
      menuItem("Alignment", tabName = "ali"),
      actionButton('findsyn', "Find Synteny", class='btn-warning'),
      menuItem("Synteny", tabName = "syn"),
      actionButton('findtree', "Find Phylogeny", class='btn-danger'),
      menuItem("Phylogeny", tabName = "phylo")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("db",
              fluidRow(
               box(
                 width = 8, status = "info", solidHeader=TRUE,
                 title = "Database info",
                 htmlOutput('dbvis')
                ))),
      tabItem("seqs",
               fluidRow(
                 box(
                   width = 8, status = "info", solidHeader = TRUE,
                   title = "Sequences",
                   htmlOutput('seqvis')
                 ))),
      tabItem("ali",
              fluidRow(
                box(
                  width = 8, status = "info", solidHeader = TRUE,
                  title = "Alignment",
                  htmlOutput('alivis')
                ))),
      tabItem("syn",
              fluidRow(
                box(
                  width = 8, status = "info", solidHeader = TRUE,
                  title = "Syntenic Hits",
                  plotOutput("synvis")
                ))),
      tabItem("phylo",
              fluidRow(
                box(
                  width = 8, status = "info", solidHeader = TRUE,
                  title = "Phylogenetic Reconstruction",
                  plotOutput("treevis")
                )))
    )
  )
)