#install.packages(c("shiny","plotly","ggplot2","DT","shinyWidgets"))

library(shiny)
library(ggplot2)
library(DT)
library(plotly)
library(shinythemes)
library(shinyWidgets)

#fichier R séparé qui contient quelques aide et guide line
source("aide_ui.R")

navbarPage(
  
  title = "Santé mental des étudiants en médecine",
  theme = shinytheme("flatly"),
  
  # 1. Vue générale
  tabPanel("Vue générale",
           
           #text introduction 
           h2(span("Présentation de l'application", style = "color:#1f4e8c")),
          
           
           wellPanel(
           p("Cette application a pour objectif d’analyser",strong("la santé mentale post-COVID"), "des étudiants en médecine 
             à travers différents indicateurs tels que la dépression, l’anxiété, l’épuisement émotionnel, 
             le cynisme, l’empathie et l’efficacité académique. 
             
             Elle permet d’explorer les données de manière descriptive :", strong("analyses univariées"), "ainsi que 
             d’identifier les relations entre variables :",strong("analyses multivariées"), "grâce à des visualisations interactives.",
             br(),br(),
             "Utilisez la barre supérieur pour naviguer dans les différentes sections de l'application et utiliser les widget pour explorer les graphiques.")
           
           ),
           
           br(), 
           
          #ligne 1 graphiques
           h2(span("Description générale des variables du jeu de données", style = "color:#1f4e8c")),
           fluidRow(
             column(4,
                    wellPanel(
                      h3(span("% d'étudiants avec un indicateur > seuil", style = "color:#033629")),
                      plotlyOutput("bar_scores_moyens")
                    )
             ),
             column(4,
                    wellPanel(
                      h3(span("Distribution des étudiants selon l'année d'étude", style = "color:#033629")),
                      plotlyOutput("plot_annee")
                    )
             ),
             column(4,
                    wellPanel(
                      h3(span("Distribution selon le temps d'étude par semaine", style = "color:#033629")),
                      plotlyOutput("plot_etude_global")
                    )
             )
           ),
           
          #ligne 2 graph
           fluidRow(
             column(4,
                    wellPanel(
                      h3(span("Répartition des étudiants selon le sexe", style = "color:#033629")),
                      plotlyOutput("pie_sexe"),
                      
                    )
             ),
             column(4,
                    wellPanel(
                      h3(span("Situation amoureuse", style = "color:#033629")),
                      plotlyOutput("pie_partenaire")
                    )
             ),
             column(4,
                    wellPanel(
                      h3(span("Situation professionnelle", style = "color:#033629")),
                      plotlyOutput("pie_travail")
                    )
                    
             )
           )
  ),
  
  
  #  2. Tableau
  tabPanel("Tableau",
           
           h2(span("Tableau de données", style = "color:#1f4e8c")),
           wellPanel(p("Le tableau est intéractif, vous pouvez aplliquer des filtres.")),
           
           wellPanel(
             DTOutput("table_donnees")
           )
  ),
  
  
  # 3. Profils
  tabPanel("Profils",
           
           h2(span("Profils de la population", style = "color:#1f4e8c")),
           
           fluidRow(
             column(3,
                    wellPanel(
                      h3(span("Paramètres :", style = "color:#033629")),
                      br(),
                      p(strong("Séparer les sexes")),
                      materialSwitch(
                        inputId = "sexe_sep",
                        label = "", 
                        value = TRUE,
                        status = "warning"
                      ),
                      sliderInput("filtre_age", "Âge", 15, 50, c(15,50)),
                      sliderInput("filtre_annee", "Année", 1, 6, c(1,6))
                    )
             ),
             #age
             column(5,
                    wellPanel(
                      h3(span("Distribution de l'âge", style = "color:#033629")),
                      plotlyOutput("hist_age")
                    )
             ),
             #année d'étude
             column(4,
                    wellPanel(
                      h3(span("Distribution des heures d'étude", style = "color:#033629")),
                      plotlyOutput("hist_etude")
                    )
             )
           )
  ),
  
  
  # 4. Relations
  tabPanel("Relations",
           
           #ligne 1
           h2(span("Description de l'indicateur", style = "color:#1f4e8c")),
           
           fluidRow(
             column(3,
                    wellPanel(
                      h3(span("Paramètres :", style = "color:#033629")),
                      virtualSelectInput(
                        inputId = "indicateur",
                        label = "Choisir l'indicateur à analyser",
                        choices = c(
                          "Dépression" = "depression",
                          "Anxiété" = "anxiete_chronique",
                          "Épuisement" = "epouisement_emotionnel",
                          "Cynisme" = "cynisme",
                          "Soutien" = "soutien",
                          "Empathie" = "empathie",
                          "Efficacité" = "efficacite_academique"
                        ),
                        selected = "depression",
                        keepAlwaysOpen = TRUE,
                        width = "100%",
                        dropboxWrapper = "body"
                      )
                    )
             ),
             
             column(7,
                    wellPanel(
                      h3(span("Distribution du score", style = "color:#033629")),
                      plotlyOutput("hist_score")
                    )
             ),
             column(2,
                    wellPanel(
                      h3(span("Proportion des étudiants concernés par l'indicateur :", style = "color:#033629")),
                      uiOutput("bar_seuils")
                    )
             )
             
           ),
           
           #ligne 2
           h2(span("Analyse de l'indicateur selon les groupes de la population", style = "color:#1f4e8c")),
           fluidRow(
             column(3,
                    wellPanel(
                      h3(span("Paramètres :", style = "color:#033629")),
                      awesomeRadio(
                        inputId = "groupe",
                        label = "Choisir la variable",
                        choices = c(
                          "Sexe" = "sexe",
                          "Travail" = "travail",
                          "Partenaire" = "partenaire",
                          "Année" = "annee_etude"
                        ),
                        selected = "sexe",
                        status = "warning"
                      )
                    )
             ),
             
             column(5,
                    
                    wellPanel(
                      h3(span("Comparaison selon les classes de la variable choisie", style = "color:#033629")),
                      plotlyOutput("box_score")
                    )
             ),
             
             column(3,
                    wellPanel( style = "background-color:#2C3E50; color:white",
                      h3(span("Interprétation")),
                      uiOutput("interpretation_txt")
                    )
             )
             
            
             
           )
  ),
  
  # 5. Tendances
  tabPanel("Tendances",
           
           h2(span("Relations entre variables", style = "color:#1f4e8c")),
           
           panel(
             p("Cette section permet d'explorer les relations entre variables à l'aide d'un nuage de points 
             et de représenter les varibles les plus influants et associés à l'indicateur choisi.")
           ),
           
           fluidRow(
             column(2,
                    wellPanel(
                      h3(span("Paramètres :", style = "color:#033629")),
                      br(),
                      
                      selectInput(
                        "var_x",
                        "Choisir la variable X",
                        choices = c(
                          "age",
                          "heure_etude",
                          "depression",
                          "anxiete_chronique",
                          "epouisement_emotionnel",
                          "cynisme",
                          "soutien",
                          "empathie",
                          "efficacite_academique"
                        )
                      ),
                      
                      selectInput(
                        "var_y",
                        "Choisir la variable Y",
                        choices = c(
                          "depression",
                          "anxiete_chronique",
                          "epouisement_emotionnel",
                          "cynisme",
                          "soutien",
                          "empathie",
                          "efficacite_academique"
                        )
                      ),
                      
                      hr(),
                      
                      selectInput(
                        "score_modele",
                        "Indicateur à expliquer",
                        choices = c(
                          "depression",
                          "anxiete_chronique",
                          "epouisement_emotionnel",
                          "cynisme",
                          "soutien",
                          "empathie",
                          "efficacite_academique"
                        ),
                        selected = "depression"
                      )
                    )
             ),
             
             column(6,
                    wellPanel(
                      h3(span("Nuage de points avec droite de tendance", style = "color:#033629")),
                      plotlyOutput("scatter_plot")
                    )),
                    
             column(4,
                    wellPanel(
                      h3(span("Variables les plus associées à l'indicateur choisi", style = "color:#033629")),
                      plotlyOutput("bar_importance", height = 360)
                    )
             )
           )
           
           
  ),
  
# 6. Aide à partir de source : fichier R séparé
  tabPanel("Aide", aide_ui())
)







