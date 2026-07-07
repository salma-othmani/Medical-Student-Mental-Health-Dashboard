# Prétraitement du jeu de données :


# Télécharger le jeu de données
donnees <- read.csv("donnees_mental_health.csv")

# Renommer les variables 
names(donnees)[names(donnees) == "year"] <- "annee_etude"
names(donnees)[names(donnees) == "sex"] <- "sexe"
names(donnees)[names(donnees) == "part"] <- "partenaire"
names(donnees)[names(donnees) == "job"] <- "travail"
names(donnees)[names(donnees) == "stud_h"] <- "heure_etude"
names(donnees)[names(donnees) == "jspe"] <- "empathie"
names(donnees)[names(donnees) == "amsp"] <- "soutien"
names(donnees)[names(donnees) == "cesd"] <- "depression"
names(donnees)[names(donnees) == "stai_t"] <- "anxiete_chronique"
names(donnees)[names(donnees) == "mbi_cy"] <- "cynisme"
names(donnees)[names(donnees) == "mbi_ex"] <- "epouisement_emotionnel"
names(donnees)[names(donnees) == "mbi_ea"] <- "efficacite_academique"


# Supprimer les variables non necessaire 
donnees <- donnees[, c("age", "sexe", "annee_etude", "partenaire",
                       "travail", "heure_etude", "empathie", "soutien", "depression", "anxiete_chronique",
                       "epouisement_emotionnel", "cynisme","efficacite_academique")]

# changer les types de variables 
donnees <- donnees[donnees$sexe != 3, ]  # classe pas assez riche
donnees$sexe <- factor(donnees$sexe, levels = c(1, 2), labels = c("Hommes", "Femmes"))
donnees$annee_etude <- factor(donnees$annee_etude)
donnees$partenaire <- factor(donnees$partenaire, levels = c(0,1), labels = c("Célibatire","En couple"))
donnees$travail <- factor(donnees$travail, levels = c(0,1),labels = c("Employé(e)","Chômeur(se)"))
donnees$heure_etude <- as.numeric(donnees$heure_etude)

noms_var <- c(
  "depression" = "Dépression",
  "anxiete_chronique" = "Anxiété",
  "epouisement_emotionnel" = "Épuisement",
  "cynisme" = "Cynisme",
  "soutien" = "Soutien",
  "empathie" = "Empathie",
  "efficacite_academique" = "Efficacité"
)

noms_varX <- c(
  "age" = "Âge",
  "heure_etude" = "Heure d'étude",
  "depression" = "Dépression",
  "anxiete_chronique" = "Anxiété",
  "epouisement_emotionnel" = "Épuisement",
  "cynisme" = "Cynisme",
  "soutien" = "Soutien",
  "empathie" = "Empathie",
  "efficacite_academique" = "Efficacité"
)


head(donnees)
summary(donnees)




