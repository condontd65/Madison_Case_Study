---- Calculate licensed alcohol location density per square mile on block groups with a spatial join. ----
SELECT bd.id,
       SUM(al.datapoint) AS total_alcohol_licenses,
       SUM(al.datapoint) / (st_Area(bd.geom) / 27878400) AS count_per_sqmile,
       /*Created a 1 in each licensed location row and now summing and deviding by square mile*/
       bd.geom 
  FROM madison.alcohol_licenses_spatial al
  JOIN madison.blockgroups_danecounty bd
    ON ST_Within(al.geom, bd.geom) /*Spatially joining on the geometry column*/
 GROUP BY bd.id;


---- Calculate building inspection density per square mile on block groups in 2018 with a spatial join. ----
SELECT bd.id,
       SUM(bi.datapoint) AS total_building_inspection_density,
       SUM(bi.datapoint) / (st_Area(bd.geom) / 27878400) AS count_per_sqmile,
       /*Created a 1 in each inspection location row and now summing and deviding by square mile*/
       bd.geom 
  FROM madison.building_inspection_spatial bi 
  JOIN madison.blockgroups_danecounty bd
    ON ST_Within(bi.geom8193, bd.geom) /*Spatially joining on the geometry column*/
 GROUP BY bd.id;


---- Determine the percentage of licensed alcohol locations that had a building in spection in 2018 with a spatial join. ----
SELECT ld.id,
       (SUM(al.datapoint) / ld.total_alcohol_licenses)*100 AS percent_licensedlocations_inspected,
       /*Summing up all licensed locations inspected after eliminating duplicate business names and calculating the percentage of them per total alcohol license locations*/
       ld.geom 
  FROM madison.alcohol_license_inspections_spatial_individual al
  JOIN madison.blockgroups_license_density ld
    ON ST_Within(al.geom8193, ld.geom) /*Spatially joining on the geometry column*/
 GROUP BY ld.id,
          ld.total_alcohol_licenses,
          ld.geom;
