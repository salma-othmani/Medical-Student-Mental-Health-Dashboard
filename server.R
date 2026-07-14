#fichier server

#library utilisées :

library(shiny)
library(ggplot2)
library(DT)
library(plotly)
library(shinythemes)

source("pretraitement.R")

function(input, output, session) {
  
  # thème par défaut pour les graphiques de l'application  
  theme_app <- theme_minimal(base_size = 13) +
    theme(
      axis.title = element_text(size = 11, face="bold"),
      axis.text = element_text(size = 11),
      panel.grid.major = element_line(colour = "#edf2f7"),
      plot.background = element_rect(fill = "white"),
      panel.background = element_rect(fill = "white"),
      legend.position = "top"
    )
  
  # couleur par défaut pour les hommes et les femmes 
  couleurs_sexe <- c("Hommes" = "#2f5fb3", "Femmes" = "#ffae3b")
  
  # sous-ensemble des données selon les filtres choisis par l’utilisateur
  donnees_filtrees <- reactive({
    d <- donnees
    d <- d[d$age >= input$filtre_age[1] & d$age <= input$filtre_age[2], ]
    d <- d[as.numeric(as.character(d$annee_etude)) >= input$filtre_annee[1] &
             as.numeric(as.character(d$annee_etude)) <= input$filtre_annee[2], ]
    d
  })
  
#----------------------------------------------------------------------------------------  
#----------------------------------------------------------------------------------------------   
  # 1. vue générale

  # 1.1. Graphs descriptif : indicateur / année d'étude / heure d'étude par semaine
  
  # % des étudiants avec un indicateur de santé mentale > seuil (le % est calculé à partir de la moyenne de chaque score)
  output$bar_scores_moyens <- renderPlotly({
    tab <- data.frame(score = c(
        "Dépression \nCES-D≥16",
        "Anxiété \nSTAI≥40",
        "Épuisement \nMBI-ex>26",
        "Cynisme \nMBI-cy>9",
        "Empathie \nJSPE>120",
        "Efficacité \nMBI-ea>26"
      ),
      pourcentage = c(
        round(mean(donnees$depression >= 16) * 100, 1),
        round(mean(donnees$anxiete_chronique >= 40) * 100, 1),
        round(mean(donnees$epouisement_emotionnel > 26) * 100, 1),
        round(mean(donnees$cynisme > 9) * 100, 1),
        round(mean(donnees$empathie > 120) * 100, 1),
        round(mean(donnees$efficacite_academique > 26) * 100, 1)
      )
    )
    
    
    ggplotly(
      ggplot(tab, aes(x = pourcentage, y = score, fill = score)) +
        geom_col() +
        
        scale_fill_manual(values = c(
          "#eb8536", "#2f5fb3", "#ffae3b","#002a61", "#89a8e8", "#eb630e"
        )) +
        labs(x = "Pourcentage d'étudiants",y = "") +
        theme_app +
        theme(
          legend.position = "none"
        )
    )
    
  })
  
                    #-------------------------------------------------#
  
  # représentation de la distribution des étudiants selon leurs années d'études
  output$plot_annee <- renderPlotly({
    
    tab <- as.data.frame(table(donnees$annee_etude))
    names(tab) <- c("annee_etude", "effectif")
    
    ggplotly(
      ggplot(tab, aes(x = annee_etude, y = effectif)) +
        geom_col(fill = "#c7d4cc", color = "white", linewidth = 0.3) +
        labs(x = "Année d'étude", y = "Effectif") +
        theme_app
    )
    
  })
  
                        #-------------------------------------------------#
  
  # représentation de la distribution des étudiants selon l'heures d'étude par semaine 
  output$plot_etude_global <- renderPlotly({
    ggplotly(
      ggplot(donnees, aes(x = heure_etude)) +
        geom_histogram(binwidth = 5, fill = "#002a61", color = "white", linewidth = 0.3) +
        labs(x = "Heures d'étude", y = "Effectif") +
        theme_app
    )
  })
                     #-------------------------------------------------#
 
  # 1.2. Commembert descriptif : sexe / partenaire / travail
  # pie sexe
  output$pie_sexe <- renderPlotly({
    tab <- as.data.frame(table(donnees$sexe))
    names(tab) <- c("categorie", "effectif")
    
    plot_ly(
      data=tab,
      labels = ~categorie,
      values = ~effectif,
      type = "pie",
      
      textinfo = "label",
      insidetextorientation = "radial",
      
      marker = list(colors = c("#002a61", "#ffae3b"))
    ) %>%
      layout(showlegend = TRUE)
  })
  
  # pie partenaire
  output$pie_partenaire <- renderPlotly({
    tab <- as.data.frame(table(donnees$partenaire))
    names(tab) <- c("categorie", "effectif")
    
    plot_ly(
      tab,
      labels = ~categorie,
      values = ~effectif,
      type = "pie",
      textinfo = "label",
      insidetextorientation = "radial",
      marker = list(colors = c("#ffae3b", "#002a61"))
    ) %>%
      layout(showlegend = TRUE)
  })
  
  # pie travail
  output$pie_travail <- renderPlotly({
    tab <- as.data.frame(table(donnees$travail))
    names(tab) <- c("categorie", "effectif")
    
    plot_ly(
      tab,
      labels = ~categorie,
      values = ~effectif,
      type = "pie",
      textinfo = "label",
      insidetextorientation = "radial",
      marker = list(colors = c("#002a61", "#ffae3b"))
    ) %>%
      layout(showlegend = TRUE)
  })
 
#---------------------------------------------------------------------------------------------- 
#----------------------------------------------------------------------------------------------   
  
  # 2. tableau donnees
  output$table_donnees <- renderDT({
    
    # renommer le nom des colonnes 
    colnames(donnees) <- c("Âge","Sexe","Année","Partenaire","Travail","Heures d'étude",
                           "Soutien","Empathie","Dépression", "Anxiété","Épuisement","Cynisme","Efficacité")
    
    datatable(donnees,
              options = list(pageLength = 10),
              rownames = FALSE,
              filter = "top"
    )
  })

  #---------------------------------------------------------------------------------------------- 
  #----------------------------------------------------------------------------------------------    
  # 3. profils
  # 3.2. histogramme age 
  output$hist_age <- renderPlotly({
    d <- donnees_filtrees()
    
    # bouton non sélectionné / graph incluant hommes et femmes
    if (!input$sexe_sep) {
      ggplotly(
        ggplot(d, aes(x = age)) +
          geom_histogram(binwidth = 2,fill = "#c7d4cc",color = "white",linewidth = 0.3) +
          labs(x = "Âge", y = "Effectif") +
          theme_app
      )
      
      # bouton sélectionné / graph séparant hommes et femmes 
    } else {
      ggplotly(
        ggplot(d, aes(x = age, fill = sexe)) +
          geom_histogram(binwidth = 2,position = "dodge",color = "white",linewidth = 0.3) +
          scale_fill_manual(values = couleurs_sexe) +
          labs(x = "Âge", y = "Effectif", fill = "Sexe") +
          theme_app
      )
    }
  })
 
                      #-------------------------------------------------# 
  # 3.3. histogramme annee d'etude 
  output$hist_etude <- renderPlotly({
    d <- donnees_filtrees()
    
    # bouton non sélectionné / graph incluant hommes et femmes
    if (!input$sexe_sep) {
      ggplotly(
        ggplot(d, aes(x = heure_etude)) +
          geom_histogram(binwidth = 5,fill = "#c7d4cc",color = "white",linewidth = 0.3) +
          labs(x = "Heures d'étude", y = "Effectif") +
          theme_app
      )
      
      # bouton sélectionné / graph séparant hommes et femmes
    } else {
      ggplotly(
        ggplot(d, aes(x = heure_etude, fill = sexe)) +
          geom_histogram(binwidth = 5,position = "dodge",color = "white",linewidth = 0.3) +
          scale_fill_manual(values = couleurs_sexe) +
          labs(x = "Heures d'étude", y = "Effectif", fill = "Sexe") +
          theme_app
      )
    }
  })
  
  #---------------------------------------------------------------------------------------------- 
  #----------------------------------------------------------------------------------------------
  
  # 4. Relations
  # 4.2. Histogramme score de l'indicateur choisi
  output$hist_score <- renderPlotly({
    ggplotly(
      ggplot(donnees, aes_string(x = input$indicateur)) +
        geom_histogram(binwidth = 3, fill = "#c7d4cc", color = "white", linewidth = 0.3) +
        labs(x = input$indicateur, y = "Effectif") +
        theme_app
    )
  })

                          #-------------------------------------------------# 
  
  # 4.3. Pourcentage / seuil
  output$bar_seuils <- renderUI({
    total <- nrow(donnees)
    
    if (input$indicateur == "depression") {nb <- sum(donnees$depression >= 16)
    label <- "déprimés"} 
    
    else if (input$indicateur == "anxiete_chronique") {
      nb <- sum(donnees$anxiete_chronique >= 40)
      label <- "anxieux"} 
    
    else if (input$indicateur == "epouisement_emotionnel") {
      nb <- sum(donnees$epouisement_emotionnel > 26)
      label <- "épuisés émotionnellement"} 
    
    else if (input$indicateur == "cynisme") {
      nb <- sum(donnees$cynisme > 9)
      label <- "cynique"} 
    
    else if (input$indicateur == "soutien") {
      
      nb <- sum(donnees$soutien < median(donnees$soutien))
      label <- "avec un faible soutien"} 
    
    else if (input$indicateur == "efficacite_academique") {
      nb <- sum(donnees$efficacite_academique > 26)
      label <- "avec une bonne efficacité académique"} 
    
    else {
      nb <- sum(donnees$empathie > 120)
      label <- "très empathiques"}
    
    pourcentage <- round((nb / total) * 100, 1)
 
    wellPanel(p(strong(span(nb, style = "color:#eb630e")), " étudiants sur ",strong(total), " sont ",strong(label)),
      p("Cela représente ",strong(span(pourcentage, style = "color:#eb630e")) ,strong(span("%", style = "color:#eb630e"))," de la population totale."))
  })
 
                          #----------------------------------------------------#
  
  # 4.3. boxplot comparaison entre groupe selon l'indicateur eb8536
  output$box_score <- renderPlotly({
   
    nb_groupes <- length(unique(donnees[[input$groupe]]))
    palette_box <- c("#89a8e8", "#eb8536", "#2f5fb3", "#eb630e", "#c7d4cc", "#ffae3b")
    ggplotly(
      ggplot(donnees, aes_string(x = input$groupe,y = input$indicateur,fill = input$groupe )) +
        geom_boxplot() +
        scale_fill_manual(values = palette_box[1:nb_groupes]) +
        labs(x = NULL, y = noms_var[input$indicateur]) +
        theme_app +
        theme(legend.position = "none")
    )
   
  })
                                  #------------------------------------#et
  #4.4. Interpretation du boxplot 
  
  output$interpretation_txt <- renderText({

    moyennes <- tapply(donnees[[input$indicateur]], donnees[[input$groupe]], mean)
    groupe_max <- names(which.max(moyennes))
    paste0(
      "Le groupe ", groupe_max," présente en moyenne un score plus élevé pour l'indicateur ",
      noms_var[input$indicateur], ". \n",
      "Avec une moyenne de ", round(max(moyennes),1), "contre", round(max(moyennes),2),". \n",
      "Ce qui suggère une plus grande exposition aux",groupe_max, "à cet indicateur."
    )
    
  })
  
  output$interpretation_txt <- renderText({
    moyenne <- tapply(donnees[[input$indicateur]], donnees[[input$groupe]], mean)
    groupe_max <- names(which.max(moyenne))
    groupe_min <- names(which.min(moyenne))
    paste0(
      "Le groupe ", groupe_max, " présente un score plus élevée pour l'indicateur ", noms_var[input$indicateur], ".\n",
      "Avec une moyenne de ", round(max(moyenne), 1), " pour les ", groupe_max, 
      " contre ", round(min(moyenne), 1), " pour les ", groupe_min, ". ",
      "Ce qui suggère une plus grande exposition des ", groupe_max, " à cet indicateur."
    )
    
  })
  
  
  #---------------------------------------------------------------------------------------------- 
  #----------------------------------------------------------------------------------------------  
  
  # 5. Tendances
  
  # 5.1. Nuage de points avec droite de régression
  output$scatter_plot <- renderPlotly({
    
    ggplotly(
      ggplot(donnees, aes_string(x = input$var_x, y = input$var_y)) +
        geom_point(color = "#ffae3b", alpha = 0.3, size = 1.5) +
        geom_smooth(method = "lm", se = FALSE, color = "#002a61") +
        labs(
          x = input$var_x,
          y = input$var_y
        ) +
        theme_app
    )
    
  })
  
  
  # 5.2. Importance simple des variables avec lm()
  modele_importance <- reactive({
    
    variables <- c(
      age = "Âge",
      heure_etude = "Heures d'étude",
      soutien = "Soutien",
      sexe = "Sexe",
      annee_etude = "Année d'étude",
      travail = "Travail",
      partenaire = "Partenaire"
    )
    
    importance <- data.frame(
      variable = unname(variables),
      coefficient = NA
    )
    
    for(i in seq_along(variables)) {
      
      formule <- as.formula(
        paste(input$score_modele, "~", names(variables)[i])
      )
      
      modele <- lm(formule, data = donnees)
      
      importance$coefficient[i] <- abs(coef(modele)[2])
    }
    
    importance
  })
  
  # 5.3. Graphique des variables les plus associées
  output$bar_importance <- renderPlotly({
    
    importance <- modele_importance()
    
    ggplotly(
      ggplot(
        importance,
        aes(
          x = reorder(variable, coefficient),
          y = coefficient
        )
      ) +
        geom_col(fill = "#4f81d9") +
        coord_flip() +
        labs(
          x = "Variable",
          y = "Coefficient"
        ) +
        theme_app
    )
    
  })
}



