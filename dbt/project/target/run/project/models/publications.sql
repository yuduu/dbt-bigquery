

  create or replace view `bt-pp-cus-c84f`.`dbtbigquerytest`.`publications`
  OPTIONS()
  as SELECT * FROM `patents-public-data.google_patents_research.publications_201710` LIMIT 1000;

