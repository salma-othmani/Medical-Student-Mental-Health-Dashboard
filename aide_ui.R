aide_ui <- function() {
  tagList(
         
         h2(span("Comprendre les indicateurs de santé mentale", style = "color:#1f4e8c")),
         
         wellPanel(
     
           h3(span("Les indicateurs étudiés", style = "color:#1f4e8c")),
           
           p("Plusieurs scores psychologiques sont utilisés dans cette application pour évaluer différents aspects de la santé mentale. 
             Les participants ont répondu à des questions dans un formulaire, puis selon leurs réponse les différents scores sont calculés.
             Chaque score a un seuil connu, à partir duquel on peut dire si la personne souffre ou pas d'un indicateur precis.
             parmi ces indicateurs on trouve :"),
           
           tags$ul(
             tags$li(strong("Dépression (CES-D) : "), "mesure les symptômes dépressifs."),
             tags$li(strong("Anxiété (STAI) : "), "évalue le niveau d’anxiété chronique."),
             tags$li(strong("Épuisement émotionnel (MBI-ex) : "), "représente la fatigue mentale liée aux études."),
             tags$li(strong("Cynisme (MBI-cy) : "), "traduit une attitude détachée ou négative."),
             tags$li(strong("Empathie (JSPE) : "), "mesure la capacité à comprendre les autres."),
             tags$li(strong("Efficacité académique (MBI-ea) : "), "évalue le sentiment de réussite scolaire.")
           ),
           
           h3(span("Interprétation des seuils", style = "color:#1f4e8c")),
          
           tags$ul(
             tags$li(strong("Dépression ≥ 16 : "), "présence probable de symptômes dépressifs."),
             tags$li(strong("Anxiété ≥ 40 : "), "niveau élevé d’anxiété."),
             tags$li(strong("Épuisement > 26 : "), "fatigue émotionnelle importante."),
             tags$li(strong("Cynisme > 9 : "), "détachement marqué."),
             tags$li(strong("Empathie > 120 : "), "niveau élevé d’empathie."),
             tags$li(strong("Efficacité > 26 : "), "bonne perception de ses capacités académiques.")
           ),
           
           h3(span("Comment lire les graphiques", style = "color:#1f4e8c")),
           
           tags$ul(
             tags$li(strong("Histogrammes : "), "montrent la distribution des scores."),
             tags$li(strong("Boxplots : "), "permettent de comparer les groupes."),
             tags$li(strong("Nuages de points : "), "analysent les relations entre variables."),
             tags$li(strong("Barres (%) : "), "montrent la proportion d’étudiants au-dessus des seuils.")
           ),
           
           h3(span("Interprétation générale", style = "color:#1f4e8c")),
           
           p(
             "Un score élevé n’a pas toujours la même signification selon l’indicateur. 
             Certains scores élevés indiquent un", strong("risque (dépression, anxiété), "),
             "tandis que d’autres traduisent un", strong("état positif (efficacité).")
           ),
           
           h3(span("Librairies", style = "color:#1f4e8c")),
          
           p(a("Plotly",href = "https://plotly.com/r/pie-charts/"), " et ",  a("ggplotly",href = "https://plotly.com/ggplot2/bar-charts/"),": pour les graphiques intéractifs", 
             br(),
              a("DT",href = "https://rstudio.github.io/DT/shiny.html"),": pour le tableau dans shiny ",
             br(),
              a("Shinythemes",href = "https://rstudio.github.io/shinythemes/")," et ", a("Thème Flatly",href = "https://bootswatch.com/flatly/"),": pour le thème et les couleurs de l'application ",
             ),
           
           
           h3(span("Références scientifiques", style = "color:#1f4e8c")),
           
           p(a("Carrard et al. (2022)", href="https://pubmed.ncbi.nlm.nih.gov/35830537/"),  " : publication scientifique à l'origine du jeu de données.",
             
             br(),
             
             a("Jefferson Scale of Physician Empathy (JSPE)", href = "https://link.springer.com/article/10.1007/s10459-018-9839-9"),
             " : description et validation de l'échelle d'empathie",
             
             br(),
             
             a("Center for Epidemiologic Studies Depression Scale (CES-D)",
               href = "https://pubmed.ncbi.nlm.nih.gov/28254608/"),
             " : interprétation du score de dépression",
             
             br(),
             
             a("Maslach Burnout Inventory (MBI)",
               href = "https://pubmed.ncbi.nlm.nih.gov/29869142/"),
             " : description des dimensions du burnout",
             
             br(),
             
             a("Maslach Burnout Inventory - Student Survey (MBI-SS)",
               href = "https://onlinelibrary.wiley.com/doi/10.1111/jep.12771"),
             " : validation de la version destinée aux étudiants"
           ),
    
           p("Pour plus de détails sur le jeu de données, les références utilisées et le contexte du projet,", 
             strong("veuillez consulter le rapport et le README"), "accompagnant l'application."),
           
           br(),
           strong(span("Travail réalisé par Selma Othmani",style ="color:#033629"))
         )
)
  
}