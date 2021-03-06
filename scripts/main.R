#///////////////////////////////////////////////////////////////////////////////
# PROJECT demoManipulateWidget
#///////////////////////////////////////////////////////////////////////////////
#
#////////
# GOAL:
# Démonstration d'utilitation du package manipulateWidget sur des données 
# Pokemon.
#
#////////
# DATA:
# - Tableau "pokedex" contenant une ligne par pokemon avec les noms, types, 
#   statistique, classement stratégique d'un pokemon.
# - Tableau "resistance" contenant une ligne par pokemon et une colonne par type.
#   Les cases contiennent un indice de résistance allant de -2 à 3: -2 correspond
#   à une forte faiblesses, 3 correspond à une imunité totale.
#
# En plus de ces données deux fonctions sont disponibles:
# - plotPokeStats: prend en argument une ligne de "pokedex" et génère un
#     barchart représentant les statistiques du pokemon correspondant.
# - plotResistance: prend en argument une ligne de "résistance" et crée un
#     barchart représentant les résistances de type d'un pokemon donné.
#
#///////////////////////////////////////////////////////////////////////////////

# devtools::install_github("FrancoisGuillem/project")
library(project)
prStart()

View(pokedex)
View(resistance)

plotPokeStats(pokedex[1, ])
plotResistance(resistance[1, ])

# Composition de graphiques ####################################################

# Combiner les deux graphiques dans une même vue
myPokemon <- pokedex$name[1]

combineWidgets(
  plotPokeStats(pokedex %>% filter(name == myPokemon)),
  plotResistance(resistance %>% filter(name == myPokemon)),
  ncol = 2
)

# Ajouter un titre
combineWidgets(
  plotPokeStats(pokedex %>% filter(name == myPokemon)),
  plotResistance(resistance %>% filter(name == myPokemon)),
  ncol = 2,
  title = myPokemon
)

# Ajouter l'animation du pokemon
combineWidgets(
  plotPokeStats(pokedex %>% filter(name == myPokemon)),
  plotResistance(resistance %>% filter(name == myPokemon)),
  ncol = 2,
  title = myPokemon,
  rightCol = staticImage(sprintf("data/animations/%s.gif", myPokemon))
)

# Lien vers la page du pokemon
combineWidgets(
  plotPokeStats(pokedex %>% filter(name == myPokemon)),
  plotResistance(resistance %>% filter(name == myPokemon)),
  ncol = 2,
  title = tags$a(
    myPokemon,
    href = (pokedex %>% filter(name == myPokemon))$urlPokestrat
  ),
  rightCol = staticImage(sprintf("data/animations/%s.gif", myPokemon))
)

# Version finale
plotPokemon(myPokemon)

# Interface graphique basique ##################################################

manipulateWidget(
  plotPokemon(pkName),
  pkName = mwSelect(pokedex$name)
)

# Afficher le nom français des pokemons plutôt
choices <- pokedex$name
names(choices) <- pokedex$nameFR

manipulateWidget(
  plotPokemon(pkName),
  pkName = mwSelect(choices)
)

# Ajouter un filtre
manipulateWidget(
  plotPokemon(pkName),
  tier = mwSelect(unique(pokedex$tier)),
  pkName = mwSelect(),
  .updateInputs = list(
    pkName = list(choices = choices[pokedex$tier == tier])
  )
)

# Mode comparaison
p <- manipulateWidget(
  plotPokemon(pkName),
  pkName = mwSelect(),
  .updateInputs = list(
    pkName = list(choices = choices)
  ),
  .compare = list(pkName = list("Absol", "Accelgor"))
)

# Exemple plus conséquent ######################################################

prScript("partenaireIdeal")
