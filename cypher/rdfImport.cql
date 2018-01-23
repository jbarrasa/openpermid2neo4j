CREATE INDEX ON :Resource(uri);

//set the namespaces

CREATE (n:NamespacePrefixDefinition {
  `http://ont.thomsonreuters.com/mdaas/`: "ns1",
  `http://permid.org/ontology/person/`: "ns7",
  `http://permid.org/ontology/trbc/`: "ns10",
  `http://permid.org/ontology/organization/`: "ns3",
  `http://www.w3.org/2006/vcard/ns#`: "ns2",
  `http://www.w3.org/2004/02/skos/core#`: "ns6",
  `http://permid.org/ontology/vcard/#`: "ns8",
  `http://permid.org/ontology/common/`: "ns0",
  `http://www.w3.org/2000/01/rdf-schema#`: "ns9",
  `http://permid.org/ontology/currency/`: "ns11",
  `http://www.omg.org/spec/EDMC-FIBO/BE/LegalEntities/CorporateBodies/`: "ns4",
  `http://permid.org/ontology/financial/`: "ns5"
})

// Adapt paths to you example. Note that importRDF stored proc takes an absolute 
// path while the LOAD CSV takes a path relative to the <neo4j_home>/import directory.
CALL semantics.importRDF("file:///Users/jesusbarrasa/APPS/neo4j-enterprise-3.3.1/import/OpenPermID/OpenPermID-bulk-organization-20180107_070346.ntriples","N-Triples", {});
CALL semantics.importRDF("file:///Users/jesusbarrasa/APPS/neo4j-enterprise-3.3.1/import/OpenPermID/OpenPermID-bulk-person-20180107_070346.ntriples","N-Triples", {});
CALL semantics.importRDF("file:///Users/jesusbarrasa/APPS/neo4j-enterprise-3.3.1/import/OpenPermID/OpenPermID-bulk-industry-20180107_070346.ntriples","N-Triples", {});
CALL semantics.importRDF("file:///Users/jesusbarrasa/APPS/neo4j-enterprise-3.3.1/import/OpenPermID/OpenPermID-bulk-assetClass-20180107_070346.ntriples","N-Triples", {});
CALL semantics.importRDF("file:///Users/jesusbarrasa/APPS/neo4j-enterprise-3.3.1/import/OpenPermID/OpenPermID-bulk-currency-20180107_070346.ntriples","N-Triples", {});
CALL semantics.importRDF("file:///Users/jesusbarrasa/APPS/neo4j-enterprise-3.3.1/import/OpenPermID/OpenPermID-bulk-instrument-20180107_070346.ntriples","N-Triples", {});

// Download the file from http://download.geonames.org/export/dump/countryInfo.txt and 
// remove the commented lines from the head
LOAD CSV WITH HEADERS from "file:///OpenPermID/countryInfo.txt" as row fieldterminator '\t'
MATCH (r:Resource { uri: "http://sws.geonames.org/" + row.geonameid + "/" } )
SET r+= row, r:Country;

CREATE INDEX ON :ns7__Person(`ns2__family-name`);
CREATE INDEX ON :ns3__Organization(`ns2__organization-name`);