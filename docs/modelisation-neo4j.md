# CityFlow — Modélisation Neo4j
**Base :** neo4j Community Edition 5.26.27
**Interface :** Neo4j Browser — http://localhost:7474

---

## 1. Schéma du graphe

```
(:Station {code, name, type})
    -[:CONNECTED_TO {duration_min}]->(:Station)

(:Line {number, color, type})
    -[:SERVES {order}]->(:Station)
```

---

## 2. Labels et propriétés

| Label | Propriétés | Description |
|---|---|---|
| `:Station` | `code, name, type` | Station du réseau (métro, tram, bus) |
| `:Line` | `number, color, type` | Ligne de transport |

| Relation | Propriétés | Description |
|---|---|---|
| `:CONNECTED_TO` | `duration_min` | Connexion directe entre 2 stations |
| `:SERVES` | `order` | Ordre de passage d'une ligne dans une station |

---

## 3. Contraintes d'unicité

```cypher
CREATE CONSTRAINT station_code IF NOT EXISTS
FOR (s:Station) REQUIRE s.code IS UNIQUE;

CREATE CONSTRAINT line_number IF NOT EXISTS
FOR (l:Line) REQUIRE l.number IS UNIQUE;
```

---

## 4. Choix de modélisation justifiés

### CONNECTED_TO bidirectionnel (A→B et B→A)

On crée 2 relations pour chaque connexion physique.
Pourquoi pas une seule relation non orientée ?
- shortestPath et Dijkstra (APOC) fonctionnent mieux avec des relations orientées
- Plus explicite pour le debug et la visualisation
- Permet de modéliser des sens uniques si besoin (ex: escalator)

### :SERVES comme relation avec propriété {order}

Pourquoi pas un nœud intermédiaire :Stop ?
- L'ordre de passage est la seule information nécessaire
- Un nœud :Stop n'aurait pas d'autres relations attachées
- La relation suffit : (:Line)-[:SERVES {order:3}]->(:Station)

Un nœud :Stop ne serait utile que si on devait y rattacher
d'autres entités (horaires par créneau, incidents signalés, etc.)

### :Station vs propriété city

Les stations sont des nœuds car :
- Elles ont leur propre identité (code unique)
- Elles sont des points de départ de traversées
- On veut requêter "toutes les stations directement connectées à X"

---

## 5. Jeu de données

| Dimension | Valeur |
|---|---|
| Stations | 15 (réseau métro lyonnais) |
| Lignes | 4 (A orange, B blue, C red, D green) |
| Connexions | 22 bidirectionnelles = 44 relations CONNECTED_TO |
| Relations SERVES | 25 (lignes → stations) |

**Stations du réseau :**
Perrache, Ampère-Victor Hugo, Bellecour, Cordeliers, Hôtel de Ville,
Foch, Masséna, Part-Dieu, Charpennes, Vaulx-en-Velin La Soie,
Gare de Vaise, Croix-Rousse, Croix-Paquet, Saxe-Gambetta, Place Guichard

---

## 6. Index-free adjacency — pourquoi Neo4j est adapté

Dans une base relationnelle, suivre une relation = lookup d'index (O(log n)).
Dans Neo4j, chaque nœud contient des pointeurs directs vers ses voisins (O(1)).

Conséquence : une traversée à 5 niveaux de profondeur sur 1 milliard de nœuds
prend le même temps que sur 1 000 nœuds. C'est ce qui rend Neo4j
radicalement plus rapide que SQL pour les requêtes relationnelles complexes.

---

## 7. Pourquoi Neo4j pour CityFlow transport

| Besoin | SQL | Neo4j |
|---|---|---|
| Plus court chemin | 3+ jointures récursives | shortestPath() natif |
| Chemin pondéré | Algorithme complexe | apoc.algo.dijkstra() |
| Stations accessibles < N min | Requête très lourde | Dijkstra + filtre weight |
| Hubs du réseau | GROUP BY + COUNT | count(DISTINCT other) |
| Ligne directe | 2 jointures | Pattern MATCH en 1 requête |
