import pandas as pd
import statsmodels.api as sm
from statsmodels.formula.api import ols

# Laad de data
file_path = 'C:/Users/madsb/OneDrive/School/DATA_Cognitie+en+Perceptie+(2023-2024).xlsx'
data = pd.read_excel(file_path, sheet_name=0)

# Hernoem de kolommen voor eenvoud
data.rename(columns={
    "Q8_1: Simple and choice reaction time tasks taak: https://www.psytoolkit.org/lessons/experiment_simple_choice_rts.html\n\nLet op! Bestaat uit twee gedeeltes. - Simple task speed (ms)": "Simple_task_speed",
    "Q8_3: Simple and choice reaction time tasks taak: https://www.psytoolkit.org/lessons/experiment_simple_choice_rts.html\n\nLet op! Bestaat uit twee gedeeltes. - Choice task speed (ms)": "Choice_task_speed",
    "Q38: Hoeveel uur per week speelt u games?": "Uren_per_week",
    "Q39: Speelt u FPS games (First Person Shooter)?": "Speelt_FPS_games"
}, inplace=True)

# Voeg een kolom toe om de groepen te classificeren
data['Groep'] = "Gamen en geen FPS"
data.loc[data['Uren_per_week'] == 0, 'Groep'] = "Geen gamers"
data.loc[data['Speelt_FPS_games'] == "Ja", 'Groep'] = "FPS gamers"

# Verwijder rijen met missende waarden
data.dropna(subset=['Simple_task_speed', 'Choice_task_speed', 'Groep'], inplace=True)

# Bereken de gemiddelde reactietijden per groep
mean_simple = data.groupby('Groep')['Simple_task_speed'].mean()
mean_choice = data.groupby('Groep')['Choice_task_speed'].mean()

print("Gemiddelde reactietijden voor Simple Task per groep:")
print(mean_simple)
print("\nGemiddelde reactietijden voor Choice Task per groep:")
print(mean_choice)

# Voer ANOVA uit voor Simple Task
model_simple = ols('Simple_task_speed ~ C(Groep)', data=data).fit()
anova_simple = sm.stats.anova_lm(model_simple, typ=2)

# Voer ANOVA uit voor Choice Task
model_choice = ols('Choice_task_speed ~ C(Groep)', data=data).fit()
anova_choice = sm.stats.anova_lm(model_choice, typ=2)

print("\nANOVA resultaten voor Simple Task:")
print(anova_simple)
print("\nANOVA resultaten voor Choice Task:")
print(anova_choice)