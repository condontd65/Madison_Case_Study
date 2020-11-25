---- Joining building inspections to alcohol license locations using ILIKE ----
SELECT DISTINCT bi.case_no AS case_number, /*Selecting just distinct case_no to eliminate duplicates*/
       bi.par_num AS parcel,
       bi.case_date,
       bi.address,
       co.address AS address_co,
       bi.case_type, 
       bi.subtype,
       bi.description,
       co.license_no,
       co.business_name,
       bi.geom8193
  FROM madison.building_inspection_spatial bi
  JOIN madison.clerk_office co
    ON bi.address ILIKE co.address /*using ILIKE from postgresql to ignore case in join*/
 WHERE bi.status = 'Violation' 
   AND EXTRACT(year from CAST(bi.case_date AS date)) = '2018' /*Not necessary, but would be useful with full dataset*/
   ORDER BY bi.case_date DESC;
