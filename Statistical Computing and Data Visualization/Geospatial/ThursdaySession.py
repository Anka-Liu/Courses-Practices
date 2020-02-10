## import the necessary packages

import numpy as np
import pandas as pd
import geopandas as gpd
import folium
import json
from shapely.geometry import Point
import matplotlib.pyplot as plt

### Example 1: Visualize the path of Hurrican Florence

usa = gpd.read_file("/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/gz_2010_us_040_00_500k.json")

usa.head()

type(usa)
type(usa.geometry)
type(usa.STATE)

usa.plot()


## Exclude both Alaska and Hawaii

usa = usa[usa['NAME'].isin(['Alaska', "Hawaii"]) == False]

usa.plot()

usa[usa.NAME == "California"].plot()

### Overlay the data from the stromhistory file to show the path of the hurrican

florence = pd.read_csv("/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/stormhistory.csv")

florence.head()

## Update the Longtitude column to be come negative because it is on the
## west side of Prime Meridian

florence["Long"] = florence["Long"] * (-1)
florence.head()

## florence is not a geopandas GeoDataFrame, so we need to transform it:

# Step 1: Combine the long and lat in a list, and call it coordinates
florence['coordinate'] = florence[['Long', 'Lat']].values.tolist()
florence.head()

# Step 2: Tranform the coordinate column to a Point data structure.
## Point is a method in Shapely package
florence['coordinate']  = florence['coordinate'].apply(Point)

florence.head()
type(florence)

# Step 3: Tranform the DataFrame from a Pandas DataFrame into a Geopandas GeoDataFrame
florence = gpd.GeoDataFrame(florence, geometry = 'coordinate')

type(florence)
type(florence.coordinate)


florence.plot()

### Visulize the path on the map

fig, ax = plt.subplots(1, figsize= (10, 7))

base = usa.plot(ax = ax, color = "green")
florence.plot(ax = base, column = "Wind", cmap = "Reds", label = "Wind Speed (mpg)")

ax.axis("off")
plt.legend()
plt.title("Hurrican Florence", fontsize = 16)
fig.show()


## Example 2: How to manipulate a legend, and how to find the center, distance, and area

school_districts = gpd.read_file("/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/school_districts.geojson")

type(school_districts)

school_districts.head()

lgnd_kwds = {"title":"School Districts",
             "ncol":2,
             "loc":"upper left",
             "bbox_to_anchor": (1,1.03)}

school_districts.plot(column = "district", legend = True,
                      legend_kwds = lgnd_kwds)

school_districts.head()

## Find the center of all districts
school_districts.centroid

### Find the area of all districts
school_districts.area

### note that the area is in degree square, which is
### not very easy to interpret
### We need to transform from degrees to meters

school_districts.crs

### CRS: Coordinate Refernece System
### EPSG: European Petrolum Survey Group
## EPSG = 4326: units in degrees (used by Google Earth)
## EPSG = 3857: units in meters (used by google maps, bing maps, Open Street Maps)

school_districts_meter = school_districts.to_crs(epsg = 3857)
school_districts_meter.crs

school_districts_meter.area ## this area is in meter square
school_districts.area ## this area is in degree square

## find the distance between the centers of the first two districts
district1 = school_districts_meter.centroid[0]
district2 = school_districts_meter.centroid[1]

district1.distance(district2)

## Example

import folium
import webbrowser

### download the map of USC

m = folium.Map(location = [34.019070, -118.285904], zoom_start = 14)

filepath = "/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/usc_map.html"

m.save(filepath)
webbrowser.open("file://" + filepath)

### add a pin (marker) on the map

m = folium.Map(location = [34.019070, -118.285904], zoom_start = 14)

filepath = "/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/usc_map.html"

folium.Marker(location = [34.019070, -118.285904],
              popup = "<b>USC Marshall</b>",
              icon = folium.Icon(color = "red")).add_to(m)

m.save(filepath)
webbrowser.open("file://" + filepath)


### add a custom icon with using USC Marshall logo

marshallLogo = "/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/uscmarshall.jpeg"
logoIcon = folium.features.CustomIcon(marshallLogo, icon_size = (50, 50))

m = folium.Map(location = [34.019070, -118.285904], zoom_start = 14)

filepath = "/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/usc_map.html"

folium.Marker(location = [34.019070, -118.285904],
              popup = "<b>USC Marshall</b>",
              icon = logoIcon).add_to(m)

m.save(filepath)
webbrowser.open("file://" + filepath)


### add a tranparent circle around USC

marshallLogo = "/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/uscmarshall.jpeg"
logoIcon = folium.features.CustomIcon(marshallLogo, icon_size = (50, 50))

m = folium.Map(location = [34.019070, -118.285904], zoom_start = 14)

filepath = "/Users/abbassalsharif/Documents/GitHub/DSO545/02_Sessions/Week_11/usc_map.html"

folium.Marker(location = [34.019070, -118.285904],
              popup = "<b>USC Marshall</b>",
              icon = logoIcon).add_to(m)

folium.CircleMarker(
                location = [34.019070, -118.285904],
                radius = 150,
                popup = "University of Southern California",
                color = "#428bca",
                fill = True,
                fill_color = "#428bca"
).add_to(m)

m.save(filepath)
webbrowser.open("file://" + filepath)
