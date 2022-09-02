SELECT *
FROM
 (
   SELECT
     '2021 Google Hiring' AS data_source,
     race_asian,
     race_black,
     race_hispanic_latinx,
     race_native_american,
     race_white,
     gender_us_women,
     gender_us_men
   FROM `bigquery-public-data.google_dei.dar_non_intersectional_hiring`
   WHERE
     workforce = 'overall'
     AND report_year = 2022
 )
UNION ALL  (
   SELECT
     '2021 Google Workforce Representation' AS data_source,
     race_asian,
     race_black,
     race_hispanic_latinx,
     race_native_american,
     race_white,
     gender_us_women,
     gender_us_men
   FROM
     `bigquery-public-data.google_dei.dar_non_intersectional_representation`
   WHERE
     workforce = 'overall'
     AND report_year = 2022
 )
UNION ALL
 (
   SELECT
     CONCAT("2021 BLS Industry - ",IFNULL(industry_group, subsector)) AS data_source,
     percent_asian AS race_asian,
     percent_black_or_african_american AS race_black,
     percent_hispanic_or_latino AS race_hispanic_latinx,
     NULL AS race_native_american,
     percent_white AS race_white,
     percent_women AS gender_us_women,
     1-percent_women AS gender_us_men
 
   FROM `bigquery-public-data.bls.cpsaat18`
   WHERE year = 2021
         AND ((subsector IN (
                 'Internet publishing and broadcasting and web search portals',
                 'Software publishers',
                 'Data processing, hosting, and related services')
               AND industry_group IS NULL
               AND industry IS NULL)
             OR (industry_group = 'Computer systems design and related services'
               AND industry IS NULL)
         )
 )
