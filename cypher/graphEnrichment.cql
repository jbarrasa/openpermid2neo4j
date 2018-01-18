MATCH (n) RETURN count(n) AS nodeCount ;

MATCH ()-[n]-() RETURN count(n) AS relCount ;

MATCH (n)
WITH n, size((n)-[]-()) AS degree
RETURN AVG(degree), MAX(degree), MIN(degree), 
       percentileCont(degree,.99) as `percent.99`, 
       percentileCont(degree,.9999)as `percent.9999`, 
       percentileCont(degree,.99999)as `percent.99999`;

MATCH (n:Country) 
MERGE (c:Continent { name: n.Continent } )
MERGE (n)-[:IN_CONTINENT]->(c)

CALL apoc.periodic.commit("
MATCH (x:ns7__Person)-[r:ns0__hasPublicationStatus]->(v)  
WITH x,r,v LIMIT $limit
SET x.ns0__publicationStatus = substring(v.uri,length('http://permid.org/ontology/common/publicationstatus'))
DELETE r
RETURN COUNT(r)
", { limit : 50000});

CALL apoc.periodic.commit("
MATCH (x:ns7__AcademicQualification)-[r:ns0__hasPublicationStatus]->(v) 
WITH x,r,v LIMIT $limit
SET x.ns0__publicationStatus = substring(v.uri,length('http://permid.org/ontology/common/publicationstatus'))
DELETE r
RETURN COUNT(r)
", { limit : 50000});

CALL apoc.periodic.commit("
MATCH (x:ns7__Officership)-[r:ns0__hasPublicationStatus]->(v) 
WITH x,r,v LIMIT $limit
SET x.ns0__publicationStatus = substring(v.uri,length('http://permid.org/ontology/common/publicationstatus'))
DELETE r
RETURN COUNT(r)
", { limit : 50000});

CALL apoc.periodic.commit("
MATCH (x:ns7__Directorship)-[r:ns0__hasPublicationStatus]->(v) 
WITH x,r,v LIMIT $limit
SET x.ns0__publicationStatus = substring(v.uri,length('http://permid.org/ontology/common/publicationstatus'))
DELETE r
RETURN COUNT(r)
", { limit : 50000});

MATCH (x:Resource) WHERE x.uri STARTS WITH 'http://permid.org/ontology/common/publicationstatus'
DELETE x ;

MATCH (x)-[r]-(n:Resource) WHERE n.uri in ["http://www.w3.org/2006/vcard/ns#male","http://www.w3.org/2006/vcard/ns#female"]
RETURN DISTINCT Labels(x), type(r) ;

call apoc.periodic.commit("
MATCH (x:ns7__Person)-[r:ns2__hasGender]->(g)   
WITH x,r,g LIMIT {limit}
SET x.ns2__gender = substring(g.uri,length('http://www.w3.org/2006/vcard/ns#'))
DELETE r
RETURN COUNT(r)
", { limit : 50000});

MATCH (n:Resource) WHERE n.uri in ["http://www.w3.org/2006/vcard/ns#male","http://www.w3.org/2006/vcard/ns#female"]
DELETE n;

MATCH (x)-[r]-(n:Resource) WHERE n.uri in ["http://permid.org/ontology/organization/statusActive","http://permid.org/ontology/organization/statusInActive"]
RETURN DISTINCT Labels(x), type(r);

call apoc.periodic.commit("
MATCH (x:ns3__Organization)-[r:ns3__hasActivityStatus]-(v)  
WITH x,r,v LIMIT {limit}
SET x.ns3__activityStatus = substring(v.uri,length('http://permid.org/ontology/organization/'))
DELETE r
RETURN COUNT(r)
", { limit : 50000});

MATCH (n:Resource) WHERE n.uri in ["http://permid.org/ontology/organization/statusActive","http://permid.org/ontology/organization/statusInActive"]
DELETE n ;



call apoc.periodic.commit("
MATCH (p)-[:ns7__hasTenureInOrganization|ns7__hasHolder]-(t:ns7__TenureInOrganization)-[:ns7__isTenureIn]->(o)
WITH  p, t, o LIMIT $limit
MERGE (p)-[hpi:HOLDS_POSITION_IN { ns0__hasPermId : t.ns0__hasPermId }]->(o) ON CREATE SET hpi+=t
DETACH DELETE t
RETURN count(hpi)", {limit : 25000}
) ;

call apoc.periodic.commit("
MATCH (p)-[:ns7__holdsPosition|ns7__hasHolder]-(t:ns7__Directorship)-[:ns7__isPositionIn]->(o), (t)-[:ns7__hasPositionType]->(pt)
WITH  p, t, o, pt LIMIT $limit
MERGE (p)-[hpi:HOLDS_POSITION_IN { ns0__hasPermId : t.ns0__hasPermId }]->(o) ON CREATE SET hpi+=t
MERGE (p)-[hdi:HOLDS_DIRECTORSHIP_IN { ns0__hasPermId : t.ns0__hasPermId }]->(o) ON CREATE SET hdi+=t, hdi.ns6__directorRoleLabel = pt.ns6__prefLabel, hdi.ns0__directorRolePermId = pt.ns0__hasPermId
DETACH DELETE t
RETURN count(hpi) ", {limit : 25000}
) ;


call apoc.periodic.commit("
MATCH (p)-[:ns7__holdsPosition|ns7__hasHolder]-(t:ns7__Officership)-[:ns7__isPositionIn]->(o), (t)-[:ns7__hasPositionType]->(pt)
WITH  p, t, o, pt LIMIT $limit
MERGE (p)-[hpi:HOLDS_POSITION_IN { ns0__hasPermId : t.ns0__hasPermId }]->(o) ON CREATE SET hpi+=t
MERGE (p)-[hdi:HOLDS_OFFICERSHIP_IN { ns0__hasPermId : t.ns0__hasPermId }]->(o) ON CREATE SET hdi+=t, hdi.ns6__directorRoleLabel = pt.ns6__prefLabel, hdi.ns0__directorRolePermId = pt.ns0__hasPermId
DETACH DELETE t
RETURN count(hpi) ", {limit : 25000}
) ;

call apoc.periodic.commit("
MATCH (:ns3__Organization)-[:ns2__hasURL]->(url) 
WHERE NOT 'URL' IN labels(url)
WITH url LIMIT $limit
SET url:URL
RETURN count(url)       
", {limit : 50000} ) ;

