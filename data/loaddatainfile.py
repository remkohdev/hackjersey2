__author__ = 'Remko'
 
import datetime
import mysql.connector
from os import listdir
from os.path import isfile, join
import os
 
cnx = mysql.connector.connect(user='', password='', host='127.0.0.1', database='test')
autocommit = 1  # to be sure
 
for path, subdirs, files in os.walk("/Users/User1/Downloads/data/crime/"):
   for filename in files:
     f = os.path.join(path, filename)
     if (isfile(f) and f.endswith(".csv")):
         year2 = str(filename.replace(".csv",""))
         print(year2)
         cursor = cnx.cursor()
         query = "LOAD DATA LOCAL INFILE \"" + f + \
                "\" INTO TABLE test.crime" + " CHARACTER SET \"utf8\"" + " FIELDS TERMINATED BY \',\'" + " OPTIONALLY ENCLOSED BY \'\"\'" + \
                " LINES TERMINATED BY \'\n\'" + " IGNORE 4 LINES" + " (@City_by_state,@Population,@Violent_crime," + "@\"Murder_and_non-negligent_man-slaughter\",@Forcible_rape,@Robbery," +\
                "@Aggravated_assault,@Property_crime,@Burglary,@\"Larceny-theft\"," + "@Motor_vehicle_theft,@Arson1)" + " SET year1 = \"" + year2 + "\", town = @City_by_state, population = replace(@Population, ',',''), violentcrime = @Violent_crime," + \
                "murder = @\"Murder_and_non-negligent_man-slaughter\", rape = @Forcible_rape, robbery = @Robbery,assault = @Aggravated_assault," + \
                " propertycrime = @Property_crime, burglary = @Burglary, larcenytheft = @\"Larceny-theft\"," + \
                " motorvehicletheft = @Motor_vehicle_theft, arson = @Arson1"
         cursor.execute(query)
         cnx.commit()
 
         cursor.close()
 
cnx.close()