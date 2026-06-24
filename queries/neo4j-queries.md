# CityFlow — Neo4j Queries
## Graphe : 15 stations | 4 lignes | Relations CONNECTED_TO + SERVES

---

## US-N1 — Plus court chemin entre deux stations

> En tant qu'utilisateur, je veux calculer le plus court chemin entre deux stations.

### Plus court chemin en nombre de stations (shortestPath)

**Requête**
```cypher
MATCH path = shortestPath(
    (a:Station {name:'Perrache'})-[:CONNECTED_TO*]-(b:Station {name:'Croix-Rousse'})
)
RETURN [n IN nodes(path) | n.name] AS chemin,
       length(path) AS nb_stations
```

**Réponse**
```
chemin                                                              | nb_stations
["Perrache","Ampère-Victor Hugo","Bellecour","Cordeliers",
 "Hôtel de Ville","Croix-Paquet","Croix-Rousse"]                   | 6
```

**Justification**
shortestPath utilise BFS (Breadth-First Search) pour trouver le chemin
avec le moins de relations. Il minimise le nombre de sauts (stations),
pas la durée. [n IN nodes(path) | n.name] est une list comprehension
qui extrait le nom de chaque nœud du chemin.

---

### Plus court chemin en durée (Dijkstra APOC)

**Requête**
```cypher
MATCH (start:Station {name:'Perrache'}),
      (end:Station {name:'Croix-Rousse'})
CALL apoc.algo.dijkstra(start, end, 'CONNECTED_TO>', 'duration_min')
YIELD path, weight
RETURN [n IN nodes(path) | n.name] AS chemin,
       weight AS duree_min
```

**Réponse**
```
chemin                                                              | duree_min
["Perrache","Ampère-Victor Hugo","Bellecour","Cordeliers",
 "Hôtel de Ville","Croix-Paquet","Croix-Rousse"]                   | 11.0
```

**Justification**
Dijkstra minimise la SOMME de duration_min sur le chemin.
APOC est nécessaire car shortestPath ne supporte pas les poids.
'CONNECTED_TO>' indique la direction (relation orientée).

---

## US-N2 — Stations accessibles en moins de 15 minutes

> En tant qu'utilisateur, je veux trouver les stations accessibles
> à moins de 15 minutes d'une station donnée.

**Requête**
```cypher
MATCH (start:Station {name:'Bellecour'}), (end:Station)
WHERE start <> end
CALL apoc.algo.dijkstra(start, end, 'CONNECTED_TO>', 'duration_min')
YIELD path, weight
WHERE weight <= 15
RETURN end.name AS station, weight AS duree_min
ORDER BY duree_min ASC
```

**Réponse**
```
station                  | duree_min
Ampère-Victor Hugo       | 1.0
Cordeliers               | 2.0
Saxe-Gambetta            | 3.0
Perrache                 | 3.0
Hôtel de Ville           | 3.0
Part-Dieu                | 4.0
Croix-Paquet             | 5.0
Gare de Vaise            | 6.0
Foch                     | 5.0
...
```

**Justification**
Dijkstra appliqué à chaque station depuis Bellecour.
WHERE weight <= 15 filtre après le YIELD.
Bellecour est un hub central — la majorité des stations
sont accessibles en moins de 15 minutes grâce au réseau dense.

---

## US-N3 — Stations hubs (les plus connectées)

> En tant qu'analyste, je veux identifier les stations hubs
> (les plus connectées) du réseau.

**Requête**
```cypher
MATCH (s:Station)-[:CONNECTED_TO]->(other:Station)
RETURN s.name AS station,
       count(DISTINCT other) AS nb_connexions
ORDER BY nb_connexions DESC
LIMIT 5
```

**Réponse**
```
station           | nb_connexions
Bellecour         | 4
Hôtel de Ville    | 4
Part-Dieu         | 4
Masséna           | 3
Charpennes        | 3
```

**Justification**
count(DISTINCT other) compte les stations voisines directes.
Les hubs sont les nœuds avec le plus de connexions — ici Bellecour,
Hôtel de Ville et Part-Dieu avec 4 connexions chacune.
En analyse de graphe, c'est le "degree centrality".

---

## US-N4 — Itinéraire sans correspondance

> En tant qu'utilisateur, je veux trouver un itinéraire sans
> correspondance entre deux stations (sur une seule ligne).

### Cas 1 — Ligne directe possible

**Requête**
```cypher
MATCH (l:Line)-[:SERVES]->(start:Station {name:'Perrache'}),
      (l)-[:SERVES]->(end:Station {name:'Part-Dieu'})
RETURN l.number AS ligne, l.color AS couleur,
       'Trajet direct sans correspondance' AS info
```

**Réponse**
```
ligne | couleur | info
A     | orange  | Trajet direct sans correspondance
```

**Justification**
On cherche une ligne L qui dessert à la fois la station de départ
ET la station d'arrivée. Si une ligne commune existe → trajet direct.
Perrache et Part-Dieu sont toutes deux sur la Ligne A.

---

### Cas 2 — Correspondance nécessaire

**Requête**
```cypher
MATCH (l:Line)-[:SERVES]->(start:Station {name:'Perrache'}),
      (l2:Line)-[:SERVES]->(end:Station {name:'Croix-Rousse'})
WHERE l <> l2
WITH l, l2
WHERE NOT EXISTS {
    MATCH (l3:Line)-[:SERVES]->(start:Station {name:'Perrache'}),
          (l3)-[:SERVES]->(end:Station {name:'Croix-Rousse'})
}
RETURN 'Correspondance nécessaire' AS info,
       l.number AS ligne_depart,
       l2.number AS ligne_arrivee
LIMIT 1
```

**Réponse**
```
info                       | ligne_depart | ligne_arrivee
Correspondance nécessaire  | A            | C
```

**Justification**
Croix-Rousse est uniquement sur la Ligne C, Perrache sur A et B.
Aucune ligne commune → correspondance obligatoire.
Le trajet optimal : Ligne A jusqu'à Hôtel de Ville,
puis Ligne C jusqu'à Croix-Rousse.

---

## Résumé des tables par US

| User Story | Requête principale | Pattern Cypher |
|---|---|---|
| US-N1 | Plus court chemin | shortestPath + Dijkstra APOC |
| US-N2 | Stations < 15 min | Dijkstra sur toutes les stations |
| US-N3 | Hubs du réseau | count(DISTINCT other) ORDER BY DESC |
| US-N4 | Ligne directe | MATCH (l:Line)-[:SERVES]->(start) + (l)-[:SERVES]->(end) |
