This directory contains postgres database dumps for the Aircloak challenge.

There are five databases, banking, census0, census1, scihub, and taxi. Please see www.aircloak.com/downloads/Aircloak-Challenge.pdf for a description of the databases.

All databases were created using pg_dump. The owner for each database is the name of the database (i.e. the owner for scihub.psql is "scihub", the owner for taxi_link.psql is "taxi").

The dumps labeled <db>.psql are dumps of the corresponding Aircloak protected databases. These may be used for singling out and inference attacks, both to check the attack's effectiveness and in the case of inference attacks, to derive the prior knowledge data.

The dumps labeled <db>_link.psql are dumps of the protected databases for linkability attacks. These may be used to check attack effectiveness.

The dumps labeled <db>_link_pub.psql are used as prior knowledge for linkability attacks. 
