WITH
  Counts AS (
  SELECT
    System,
    License,
    COUNT(DISTINCT Name) AS NPackages
  FROM
    `bigquery-public-data.deps_dev_v1.PackageVersionsLatest`
  CROSS JOIN
    UNNEST(Licenses) AS License
  GROUP BY
    System,
    License),
  Ranked AS (
  SELECT
    System,
    License,
    NPackages,
    ROW_NUMBER() OVER (PARTITION BY System ORDER BY NPackages DESC) AS LicenseRank
  FROM
    Counts)
SELECT
  System,
  License,
  NPackages
FROM
  Ranked
WHERE
  LicenseRank <= 3
ORDER BY
  System,
  LicenseRank