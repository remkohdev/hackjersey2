LOAD DATA LOCAL INFILE "/usr/local/tomcat/webapps/hackjersey/data/crime_2014.csv"
INTO TABLE test.crime
CHARACTER SET 'utf8'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 4 LINES
(@City_by_state,@Population,@Violent_crime,
@"Murder_and_non-negligent_man-slaughter",@Forcible_rape,@Robbery,
@Aggravated_assault,@Property_crime,@Burglary,@"Larceny-theft",
@Motor_vehicle_theft,@Arson1)
SET year1 = '2004', town = @City_by_state, population = replace(@Population, ',',''), violentcrime = @Violent_crime, 
murder = @"Murder_and_non-negligent_man-slaughter", rape = @Forcible_rape, robbery = @Robbery, 
assault = @Aggravated_assault, propertycrime = @Property_crime, burglary = @Burglary, larcenytheft = @"Larceny-theft", 
motorvehicletheft = @Motor_vehicle_theft, arson = @Arson1