#!/opt/local/bin/python2

import sys
import geoip2.database

# print 'Number of arguments:', len(sys.argv), 'arguments.'
# print 'Argument List:', str(sys.argv)

# This creates a Reader object. You should use the same object
# across multiple requests as creation of it is expensive.
reader = geoip2.database.Reader('/Users/matthew.kucenski/Development/opt/share/GeoIP/GeoLite2-City.mmdb')

# Replace "city" with the method corresponding to the database
# that you are using, e.g., "country".
response = reader.city(str(sys.argv[1]))
# print response

print ""
print str(sys.argv[1]) + ":"
print response.country.iso_code
print response.country.name
print response.subdivisions.most_specific.name
print response.subdivisions.most_specific.iso_code
print response.city.name
print response.postal.code
print response.location.latitude
print response.location.longitude

reader.close()
