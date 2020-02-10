

##############
# Data       #
###############################################################################
# World and Countries GeoJSON files: https://github.com/johan/world.geo.json
# USA, States, and Counties GeoJSON files: https://eric.clst.org/tech/usgeojson/
# Lat Long: https://www.latlong.net/

# Section 1:
# Section 2: gz_2010_us_040_00_500k.json; stormhistory.csv
# Section 3: school_districts.geojson;
# Section 4: uscmarshall.jpeg
# Section 5: countries.geo.json; internet.csv
# Section 6: us_unemployment.csv; us-states.json


##############
# Section 1  #
###############################################################################
#
# First show the 1854 Cholera outbreak in London (600+ deaths) by John Snow
# https://en.wikipedia.org/wiki/John_Snow#/media/File:Snow-cholera-map-1.jpg
#
# Show Napeleon's March to Moscow by Charles Minard
# https://en.wikipedia.org/wiki/French_invasion_of_Russia#/media/File:Minard.png
#
# Install and load necessary packages!
###############################################################################

# IMPORTANT!
# Install the following packages IN ORDER using Conda install!
# (1) RTree; (2) GDAL; (3) Fiona; (4) Shapely; (5) Geopandas; (6) Folium; (7) json


# Load all importance packages

import numpy as np
import pandas as pd
import geopandas as gpd
import folium
import json
from shapely.geometry import Point
import matplotlib.pyplot as plt

##############
# Section 2  #
###############################################################################
# Topic: Show the trace of Hurrican Florence to the East side of the USA
# This example is inspired from a Datacamp article
# Article: Introduction to Geospatial Data in Python
# Author: Doung Vu
# Webpage: https://www.datacamp.com/community/tutorials/geospatial-data-python
###############################################################################


# latitude: east (+) to west (-)
# longtitude: north (+) to south (-)


## Show the map of the USA!

# get the JSON data using geopandas package
usa =gpd.read_file("/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/gz_2010_us_040_00_500k.json")
usa.head()

# We can find the USA GeoJason data here:
# https://eric.clst.org/tech/usgeojson/


type(usa) # GeoDataFrame
type(usa.geometry) # GeoSeries
type(usa.GEO_ID) # Series


## Plot USA!
usa.plot()


# Execlude 'Alaska' and 'Hawaii'

usa = usa[usa['NAME'].isin(['Alaska', 'Hawaii']) == False]
usa.plot(figsize = (9,7), color = "green")


# Where is California
cali = usa.loc[usa.NAME == "California",:]
cali.plot(figsize = (9,7))


# Show the trace of Hurricane Florence

# load the hurricane data
florence = pd.read_csv('/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/stormhistory.csv')
florence.head()

florence.Wind.min()
florence.Wind.max()

# Add "-" in front of the number to correctly plot the data:
florence['Long'] = 0 - florence['Long']
florence.head()

# Combining Lattitude and Longitude to create hurricane coordinates:
florence['coordinates'] = florence[['Long', 'Lat']].values.tolist()

# Change the coordinate to a GeoPoint so you can plot it
# The method Point is applies to all coordinates lists. It came from Shapely package
florence['coordinates'] = florence['coordinates'].apply(Point)

# What is the type of florence?
type(florence)
type(florence.coordinates)

# Convert florence from a DataFrame to a GeoDataFrame

florence = gpd.GeoDataFrame(florence, geometry = "coordinates")
florence.head()

type(florence)
type(florence.coordinates)

# Note that a GeoPandas GeoDataFrame is similar to Pandas DataFrame
florence.groupby('Name').Name.count()

# Finding the mean wind speed of hurrican Florence:
print("Mean wind speed is {} mph and max speeed is {}".format(round(florence.Wind.mean(),4),florence.Wind.max()))

# Visualization

fig, ax = plt.subplots(1, figsize = (10,7))

base = usa.plot(ax = ax, color = "green")
florence.plot(ax = base, marker = "<", column = "Wind", cmap = "Reds", label = "Wind speed (mph)")

ax.axis('off')
plt.legend()
plt.title("Hurricane Florence in US Map", fontsize = 25)

plt.show()


##############
# Section 3  #
###############################################################################
# This example is inspired from a Datacamp course
# Course: Visualizing Geospatial Data in Python
# Author: Mary van Valkenburg
# Webpage: https://www.datacamp.com/courses/visualizing-geospatial-data-in-python
###############################################################################

## GeoSeries attributes and methods

# In this exercise you'll compare a qualitative colormap to a sequential (quantitative)
# colormap using the school districts GeoDataFrame.

school_districts = gpd.read_file(
    "/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/school_districts.geojson")

school_districts.head()

# Set legend style
lgnd_kwds = {'title': 'School Districts',
             'loc': 'upper left', 'bbox_to_anchor': (1, 1.03), 'ncol': 1}

# Plot the school districts using the tab20 colormap (qualitative)
school_districts.plot(column='district', cmap='tab20', legend=True, legend_kwds=lgnd_kwds)
plt.xlabel('Latitude')
plt.ylabel('Longitude')
plt.title('Nashville School Districts')
plt.show()


# Print the first row of school districts GeoDataFrame and the crs
print(school_districts.head(1))

# the following shows you the coordinate reference syste (crs)
print(school_districts.crs)

# Convert the crs to epsg:3857
school_districts.geometry = school_districts.geometry.to_crs(epsg=3857)
print(school_districts.head(1))
print(school_districts.crs)

## The EPSG (European Petrelum Survey Group) is a standard for crs
## EPSG:4325 - units are decimal degrees (used by Google Earth)
## EPSG:3857 - units are in meters (used by Google Map, Bing Maps, Open Street Maps)

# Shapley Attributes and Methods

# GeoSeries.area: returns the area of each geometry in a GeoSeries
# GeoSeries.centroid: returns the center point of each geometry in a GeoSeries
# GeoSeries.distance(other): returns the minimum distance to other

# GeoSeries area
school_districts.geometry.area

# GeoSeries center
center = school_districts.geometry.centroid
center

# GeoSeries Distance

# find the distance between two centroids

ctr1 = school_districts.geometry.to_crs(epsg = 3857).centroid[0]
ctr2 = school_districts.geometry.to_crs(epsg = 3857).centroid[1]

ctr1.distance(ctr2)



##############
# Section 4  #
###############################################################################
# Topic: Folium Maps
# This example is inspired from an example by Brad Traversy
# Article: Python Folium Example
# Author: Brad Traversy
# Webpage: https://github.com/bradtraversy/python_folium_example
###############################################################################

# create a map object
m = folium.Map(location = [42, -71], zoom_start = 12)

import os
import webbrowser
filepath = '/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_10/map.html'

# create the map
m = folium.Map(location=[34.0186834, -118.2860637], zoom_start = 14)

# add a marker if needed
folium.Marker([34.0186834, -118.2860637],
             popup = "<b>USC Marshall</b>",
             icon = folium.Icon(color = "green")).add_to(m)

m.save(filepath)
webbrowser.open('file://' + filepath)


# we can add a custom logo
marshallLogo = '/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/uscmarshall.jpeg'
logoIcon = folium.features.CustomIcon(marshallLogo, icon_size=(50, 50))

# create the map
m = folium.Map(location=[34.0186834, -118.2860637], zoom_start = 14)

# add a marker if needed
folium.Marker([34.0186834, -118.2860637],
             popup = "<b>USC Marshall</b>",
             icon = logoIcon).add_to(m)

m.save(filepath)
webbrowser.open('file://' + filepath)


# Create a circle Marker around USC

# we can add a custom logo
marshallLogo = '/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/uscmarshall.jpeg'
logoIcon = folium.features.CustomIcon(marshallLogo, icon_size=(50, 50))

# create the map
m = folium.Map(location=[34.0186834, -118.2860637], zoom_start = 14)

# add a marker if needed
folium.Marker([34.0186834, -118.2860637],
             popup = "<b>USC Marshall</b>",
             icon = logoIcon).add_to(m)

# Circle marker
folium.CircleMarker(
    location=[34.0186834, -118.2860637],
    radius=150,
    popup='University of Southern California',
    color='#428bca',
    fill=True,
    fill_color='#428bca'
).add_to(m)

m.save(filepath)
webbrowser.open('file://' + filepath)



##############
# Section 5  #
###############################################################################
# Topic: Choropleth Maps
# This example is inspired from an example on ramiro.org
# Article: Creating a Choropleth Map of the World in Python using GeoPandas
# Author: Ramiro Gomez
# Webpage: https://ramiro.org/notebook/geopandas-choropleth/
###############################################################################

# We can read either a JSON file or a shape file to show the maps

# get the JSON data using geopandas package
world =gpd.read_file("/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/countries.geo.json")
world.head()
world.plot()

internet_data = pd.read_csv("/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/internet.csv")
internet_data.head()

# Merge the two datasets

merged_data = world.merge(internet_data,
                          left_on = 'id',
                          right_on = 'Country Code')



# show the data

plt.figure()

merged_data.dropna().plot(column = '2016', cmap = "Blues",
                          scheme = 'equal_interval',
                          figsize = (10,9),
                          legend = True)

ax = plt.gca()
ax.set_title("Individuals using the Internet \n(% of Population) in 2016", fontsize = 14)
ax.set_axis_off()
ax.get_legend().set_bbox_to_anchor((0.12, 0.14))
plt.show()


##############
# Section 6  #
###############################################################################
# Topic: Interactivce Choropleth Folium Maps
# Article: Creating interactive crime maps with Folium
# Author: roos
# Webpage: https://blog.dominodatalab.com/creating-interactive-crime-maps-with-folium/
###############################################################################

###### IMPORTANT #######
### There is a problem with the folium maps.. If we update
### the code for "feature.id" to "feature.properties.id"
### then it shoud work

'feature.properties.id'


import folium
import pandas as pd
import geopandas as gpd


assert 'naturalearth_lowres' in gpd.datasets.available
datapath = gpd.datasets.get_path('naturalearth_lowres')
gdf = gpd.read_file(datapath)

gdf.head()
ax = gdf.plot(figsize=(10, 10))

import pandas as pd


n_periods, n_sample = 48, 40

assert n_sample < n_periods

datetime_index = pd.date_range('2016-1-1', periods=n_periods, freq='M')
dt_index_epochs = datetime_index.astype(int) // 10**9
dt_index = dt_index_epochs.astype('U10')

dt_index
datetime_index


import numpy as np

styledata = {}

for country in gdf.index:
    df = pd.DataFrame(
        {'color': np.random.normal(size=n_periods),
         'opacity': np.random.normal(size=n_periods)},
        index=dt_index
    )
    df = df.cumsum()
    df.sample(n_sample, replace=False).sort_index()
    styledata[country] = df

gdf.plot()


max_color, min_color, max_opacity, min_opacity = 0, 0, 0, 0

for country, data in styledata.items():
    max_color = max(max_color, data['color'].max())
    min_color = min(max_color, data['color'].min())
    max_opacity = max(max_color, data['opacity'].max())
    max_opacity = min(max_color, data['opacity'].max())


from branca.colormap import linear


cmap = linear.PuRd_09.scale(min_color, max_color)


def norm(x):
    return (x - x.min()) / (x.max() - x.min())


for country, data in styledata.items():
    data['color'] = data['color'].apply(cmap)
    data['opacity'] = norm(data['opacity'])

styledict = {
    str(country): data.to_dict(orient='index') for
    country, data in styledata.items()
}

from folium.plugins import TimeSliderChoropleth

m = folium.Map([0, 0], tiles='Stamen Toner', zoom_start=2)

g = TimeSliderChoropleth(
    gdf.to_json(),
    styledict=styledict,

).add_to(m)

#m.save(os.path.join('results', 'TimeSliderChoropleth.html'))

#m
import os
import webbrowser
filepath = '/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_10/map.html'
m.save(filepath)
webbrowser.open('file://' + filepath)
