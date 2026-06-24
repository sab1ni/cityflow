// ============================================================
// CityFlow — Neo4j seed script
// 15 stations lyonnaises | 4 lignes | 25 connexions
// ============================================================

// Nettoyage
MATCH (n) DETACH DELETE n;

// Contraintes d'unicité
CREATE CONSTRAINT station_code IF NOT EXISTS
FOR (s:Station) REQUIRE s.code IS UNIQUE;

CREATE CONSTRAINT line_number IF NOT EXISTS
FOR (l:Line) REQUIRE l.number IS UNIQUE;

// 15 stations
CREATE
  (per:Station {code:'PER', name:'Perrache',               type:'metro'}),
  (amp:Station {code:'AMP', name:'Ampère-Victor Hugo',     type:'metro'}),
  (bel:Station {code:'BEL', name:'Bellecour',              type:'metro'}),
  (cor:Station {code:'COR', name:'Cordeliers',             type:'metro'}),
  (hdv:Station {code:'HDV', name:'Hôtel de Ville',         type:'metro'}),
  (foc:Station {code:'FOC', name:'Foch',                   type:'metro'}),
  (mas:Station {code:'MAS', name:'Masséna',                type:'metro'}),
  (pdi:Station {code:'PDI', name:'Part-Dieu',              type:'metro'}),
  (cha:Station {code:'CHA', name:'Charpennes',             type:'metro'}),
  (soi:Station {code:'SOI', name:'Vaulx-en-Velin La Soie', type:'metro'}),
  (vai:Station {code:'VAI', name:'Gare de Vaise',          type:'metro'}),
  (crx:Station {code:'CRX', name:'Croix-Rousse',           type:'metro'}),
  (crp:Station {code:'CRP', name:'Croix-Paquet',           type:'metro'}),
  (sax:Station {code:'SAX', name:'Saxe-Gambetta',          type:'metro'}),
  (gui:Station {code:'GUI', name:'Place Guichard',         type:'metro'});

// 4 lignes
CREATE
  (la:Line {number:'A', color:'orange', type:'metro'}),
  (lb:Line {number:'B', color:'blue',   type:'metro'}),
  (lc:Line {number:'C', color:'red',    type:'metro'}),
  (ld:Line {number:'D', color:'green',  type:'metro'});

// Connexions bidirectionnelles — Ligne A
MATCH (a:Station {code:'PER'}),(b:Station {code:'AMP'})
CREATE (a)-[:CONNECTED_TO {duration_min:2}]->(b),(b)-[:CONNECTED_TO {duration_min:2}]->(a);
MATCH (a:Station {code:'AMP'}),(b:Station {code:'BEL'})
CREATE (a)-[:CONNECTED_TO {duration_min:1}]->(b),(b)-[:CONNECTED_TO {duration_min:1}]->(a);
MATCH (a:Station {code:'BEL'}),(b:Station {code:'COR'})
CREATE (a)-[:CONNECTED_TO {duration_min:2}]->(b),(b)-[:CONNECTED_TO {duration_min:2}]->(a);
MATCH (a:Station {code:'COR'}),(b:Station {code:'HDV'})
CREATE (a)-[:CONNECTED_TO {duration_min:1}]->(b),(b)-[:CONNECTED_TO {duration_min:1}]->(a);
MATCH (a:Station {code:'HDV'}),(b:Station {code:'FOC'})
CREATE (a)-[:CONNECTED_TO {duration_min:2}]->(b),(b)-[:CONNECTED_TO {duration_min:2}]->(a);
MATCH (a:Station {code:'FOC'}),(b:Station {code:'MAS'})
CREATE (a)-[:CONNECTED_TO {duration_min:2}]->(b),(b)-[:CONNECTED_TO {duration_min:2}]->(a);
MATCH (a:Station {code:'MAS'}),(b:Station {code:'PDI'})
CREATE (a)-[:CONNECTED_TO {duration_min:2}]->(b),(b)-[:CONNECTED_TO {duration_min:2}]->(a);
MATCH (a:Station {code:'PDI'}),(b:Station {code:'CHA'})
CREATE (a)-[:CONNECTED_TO {duration_min:3}]->(b),(b)-[:CONNECTED_TO {duration_min:3}]->(a);
MATCH (a:Station {code:'CHA'}),(b:Station {code:'SOI'})
CREATE (a)-[:CONNECTED_TO {duration_min:8}]->(b),(b)-[:CONNECTED_TO {duration_min:8}]->(a);

// Connexions — Ligne B
MATCH (a:Station {code:'BEL'}),(b:Station {code:'SAX'})
CREATE (a)-[:CONNECTED_TO {duration_min:3}]->(b),(b)-[:CONNECTED_TO {duration_min:3}]->(a);
MATCH (a:Station {code:'SAX'}),(b:Station {code:'GUI'})
CREATE (a)-[:CONNECTED_TO {duration_min:2}]->(b),(b)-[:CONNECTED_TO {duration_min:2}]->(a);
MATCH (a:Station {code:'GUI'}),(b:Station {code:'CHA'})
CREATE (a)-[:CONNECTED_TO {duration_min:3}]->(b),(b)-[:CONNECTED_TO {duration_min:3}]->(a);

// Connexions — Ligne C
MATCH (a:Station {code:'HDV'}),(b:Station {code:'CRP'})
CREATE (a)-[:CONNECTED_TO {duration_min:2}]->(b),(b)-[:CONNECTED_TO {duration_min:2}]->(a);
MATCH (a:Station {code:'CRP'}),(b:Station {code:'CRX'})
CREATE (a)-[:CONNECTED_TO {duration_min:3}]->(b),(b)-[:CONNECTED_TO {duration_min:3}]->(a);
MATCH (a:Station {code:'CRX'}),(b:Station {code:'VAI'})
CREATE (a)-[:CONNECTED_TO {duration_min:7}]->(b),(b)-[:CONNECTED_TO {duration_min:7}]->(a);

// Connexions — Ligne D
MATCH (a:Station {code:'VAI'}),(b:Station {code:'BEL'})
CREATE (a)-[:CONNECTED_TO {duration_min:6}]->(b),(b)-[:CONNECTED_TO {duration_min:6}]->(a);
MATCH (a:Station {code:'BEL'}),(b:Station {code:'PDI'})
CREATE (a)-[:CONNECTED_TO {duration_min:4}]->(b),(b)-[:CONNECTED_TO {duration_min:4}]->(a);
MATCH (a:Station {code:'PDI'}),(b:Station {code:'MAS'})
CREATE (a)-[:CONNECTED_TO {duration_min:2}]->(b),(b)-[:CONNECTED_TO {duration_min:2}]->(a);
MATCH (a:Station {code:'MAS'}),(b:Station {code:'SAX'})
CREATE (a)-[:CONNECTED_TO {duration_min:3}]->(b),(b)-[:CONNECTED_TO {duration_min:3}]->(a);

// Connexions supplémentaires
MATCH (a:Station {code:'PDI'}),(b:Station {code:'GUI'})
CREATE (a)-[:CONNECTED_TO {duration_min:2}]->(b),(b)-[:CONNECTED_TO {duration_min:2}]->(a);
MATCH (a:Station {code:'HDV'}),(b:Station {code:'PDI'})
CREATE (a)-[:CONNECTED_TO {duration_min:4}]->(b),(b)-[:CONNECTED_TO {duration_min:4}]->(a);
MATCH (a:Station {code:'CRX'}),(b:Station {code:'HDV'})
CREATE (a)-[:CONNECTED_TO {duration_min:5}]->(b),(b)-[:CONNECTED_TO {duration_min:5}]->(a);

// Relations :SERVES — Ligne A
MATCH (l:Line {number:'A'}),(s:Station {code:'PER'}) CREATE (l)-[:SERVES {order:1}]->(s);
MATCH (l:Line {number:'A'}),(s:Station {code:'AMP'}) CREATE (l)-[:SERVES {order:2}]->(s);
MATCH (l:Line {number:'A'}),(s:Station {code:'BEL'}) CREATE (l)-[:SERVES {order:3}]->(s);
MATCH (l:Line {number:'A'}),(s:Station {code:'COR'}) CREATE (l)-[:SERVES {order:4}]->(s);
MATCH (l:Line {number:'A'}),(s:Station {code:'HDV'}) CREATE (l)-[:SERVES {order:5}]->(s);
MATCH (l:Line {number:'A'}),(s:Station {code:'FOC'}) CREATE (l)-[:SERVES {order:6}]->(s);
MATCH (l:Line {number:'A'}),(s:Station {code:'MAS'}) CREATE (l)-[:SERVES {order:7}]->(s);
MATCH (l:Line {number:'A'}),(s:Station {code:'PDI'}) CREATE (l)-[:SERVES {order:8}]->(s);
MATCH (l:Line {number:'A'}),(s:Station {code:'CHA'}) CREATE (l)-[:SERVES {order:9}]->(s);
MATCH (l:Line {number:'A'}),(s:Station {code:'SOI'}) CREATE (l)-[:SERVES {order:10}]->(s);

// Relations :SERVES — Ligne B
MATCH (l:Line {number:'B'}),(s:Station {code:'PER'}) CREATE (l)-[:SERVES {order:1}]->(s);
MATCH (l:Line {number:'B'}),(s:Station {code:'AMP'}) CREATE (l)-[:SERVES {order:2}]->(s);
MATCH (l:Line {number:'B'}),(s:Station {code:'BEL'}) CREATE (l)-[:SERVES {order:3}]->(s);
MATCH (l:Line {number:'B'}),(s:Station {code:'SAX'}) CREATE (l)-[:SERVES {order:4}]->(s);
MATCH (l:Line {number:'B'}),(s:Station {code:'GUI'}) CREATE (l)-[:SERVES {order:5}]->(s);
MATCH (l:Line {number:'B'}),(s:Station {code:'CHA'}) CREATE (l)-[:SERVES {order:6}]->(s);

// Relations :SERVES — Ligne C
MATCH (l:Line {number:'C'}),(s:Station {code:'HDV'}) CREATE (l)-[:SERVES {order:1}]->(s);
MATCH (l:Line {number:'C'}),(s:Station {code:'CRP'}) CREATE (l)-[:SERVES {order:2}]->(s);
MATCH (l:Line {number:'C'}),(s:Station {code:'CRX'}) CREATE (l)-[:SERVES {order:3}]->(s);
MATCH (l:Line {number:'C'}),(s:Station {code:'VAI'}) CREATE (l)-[:SERVES {order:4}]->(s);

// Relations :SERVES — Ligne D
MATCH (l:Line {number:'D'}),(s:Station {code:'VAI'}) CREATE (l)-[:SERVES {order:1}]->(s);
MATCH (l:Line {number:'D'}),(s:Station {code:'BEL'}) CREATE (l)-[:SERVES {order:2}]->(s);
MATCH (l:Line {number:'D'}),(s:Station {code:'PDI'}) CREATE (l)-[:SERVES {order:3}]->(s);
MATCH (l:Line {number:'D'}),(s:Station {code:'MAS'}) CREATE (l)-[:SERVES {order:4}]->(s);
MATCH (l:Line {number:'D'}),(s:Station {code:'SAX'}) CREATE (l)-[:SERVES {order:5}]->(s);
