# Laad de benodigde libraries
library(readxl)
library(ggplot2)

# Laad de data
file_path <- "C:/Users/madsb/OneDrive/School/DATA_Cognitie+en+Perceptie+(2023-2024).xlsx"
data <- read_excel(file_path, sheet = 1)

# Hernoem de kolommen voor eenvoud
colnames(data)[grep("Simple task speed", colnames(data))] <- "Simple_task_speed"
colnames(data)[grep("Choice task speed", colnames(data))] <- "Choice_task_speed"
colnames(data)[grep("Hoeveel uur per week speelt u games", colnames(data))] <- "Uren_per_week"
colnames(data)[grep("Speelt u FPS games", colnames(data))] <- "Speelt_FPS_games"

# Filter de data voor FPS gamers
fps_gamers <- data[data$Speelt_FPS_games == "Ja", ]

# Bereken de IQR (interquartile range) om outliers te identificeren
Q1 <- quantile(fps_gamers$Simple_task_speed, 0.25)
Q3 <- quantile(fps_gamers$Simple_task_speed, 0.75)
IQR <- Q3 - Q1

# Definieer de grenzen voor outliers
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

# Verwijder de outliers
fps_gamers_no_outliers <- fps_gamers[fps_gamers$Simple_task_speed >= lower_bound & fps_gamers$Simple_task_speed <= upper_bound, ]

# Simple task scatterplot zonder outliers
ggplot(fps_gamers_no_outliers, aes(x = Uren_per_week, y = Simple_task_speed)) +
  geom_point(color = "red", alpha = 0.7) +
  labs(title = "Verband tussen FPS gamen en reactietijd (Simple Task) zonder outliers", x = "Aantal uren per week gespeeld", y = "Reactietijd (ms)") +
  theme_minimal()

ggplot(fps_gamers, aes(x = Uren_per_week, y = Choice_task_speed)) +
  geom_point(color = "blue", alpha = 0.7) +
  labs(title = "Verband tussen FPS gamen en reactietijd (Choice Task)", x = "Aantal uren per week gespeeld", y = "Reactietijd (ms)") +
  theme_minimal()


data$Groep <- "Gamen en geen FPS"
data$Groep[data$Uren_per_week == 0] <- "Geen gamers"
data$Groep[data$Speelt_FPS_games == "Ja"] <- "FPS gamers"

# Bereken de gemiddelde reactietijd voor elke groep (Simple Task)
gem_reactietijd_simple <- aggregate(Simple_task_speed ~ Groep, data, mean)

ggplot(gem_reactietijd_simple, aes(x = Groep, y = Simple_task_speed, fill = Groep)) +
  geom_bar(stat = "identity", alpha = 0.7, width = 0.6) +
  labs(title = "Gemiddelde Reactietijd per Groep (Simple Task)", x = "Groep", y = "Gemiddelde Reactietijd (ms)") +
  theme_minimal() +
  scale_fill_manual(values = c("Geen gamers" = "red", "Gamen en geen FPS" = "blue", "FPS gamers" = "green")) +
  geom_text(aes(label = round(Simple_task_speed, 2)), vjust = -0.5)


# Bereken de gemiddelde reactietijd voor elke groep (Choice Task)
gem_reactietijd_choice <- aggregate(Choice_task_speed ~ Groep, data, mean)

# Choice task bar chart zonder aangepaste y-as maar met bredere balken
ggplot(gem_reactietijd_choice, aes(x = Groep, y = Choice_task_speed, fill = Groep)) +
  geom_bar(stat = "identity", alpha = 0.7, width = 0.6) +
  labs(title = "Gemiddelde Reactietijd per Groep (Choice Task)", x = "Groep", y = "Gemiddelde Reactietijd (ms)") +
  theme_minimal() +
  scale_fill_manual(values = c("Geen gamers" = "red", "Gamen en geen FPS" = "blue", "FPS gamers" = "green")) +
  geom_text(aes(label = round(Choice_task_speed, 2)), vjust = -0.5)











data <- na.omit(data)

# Controleer de verdeling van de groepen
table(data$Groep)

# Voer ANOVA uit voor Simple Task
anova_simple <- aov(Simple_task_speed ~ Groep, data = data)
summary(anova_simple)

# Voer ANOVA uit voor Choice Task
anova_choice <- aov(Choice_task_speed ~ Groep, data = data)
summary(anova_choice)

# Bereken de gemiddelde reactietijden voor elke groep
aggregate(Simple_task_speed ~ Groep, data, mean)
aggregate(Choice_task_speed ~ Groep, data, mean)




