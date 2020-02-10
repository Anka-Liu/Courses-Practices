from bs4 import BeautifulSoup
from urllib.request import urlopen
import pandas as pd
# Use the following webpage, to scrape all green text
# from it.

# open the webpage
html = urlopen("http://www.pythonscraping.com/pages/warandpeace.html")

# get the html code from the webpage
soup = BeautifulSoup(html)
soup

# find all the tags (span, class = green)
### find_all(tag_name, tag_attributes)

nameList = soup.find_all("span", {"class": "green"})

nameList
# for loop to extract the names
for name in nameList:
    print(name.get_text())

# or using list comprehension

[name.get_text() for name in nameList]


# List of Presidents:

html = urlopen(
    "https://en.wikipedia.org/wiki/List_of_presidents_of_the_United_States")
soup = BeautifulSoup(html)

table = soup.find("table", {"class": "wikitable"})
table

for link in table.find_all("b"):
    print(link.find("a").get_text())

# OR using List Comprehension
[link.find("a").get_text() for link in table.find_all("b")]


# Using the data in https://en.wikipedia.org/wiki/List_of_largest_manufacturing_companies_by_revenue
# Find the total revenue for each industry

html = urlopen(
    "https://en.wikipedia.org/wiki/List_of_largest_manufacturing_companies_by_revenue")
soup = BeautifulSoup(html)


table = soup.find("table", {"class": "wikitable"})

rows = table.find_all("tr")
rows

# extract the column names from the first row
rows[0]
# [var.text for var in rows[0].find_all('th')]
col = [var.get_text().replace("\n", "") for var in rows[0].find_all('th')]

# Create an empty dataframe
df = pd.DataFrame()

# Extract all other rows in the data

for i in range(1, len(rows)):
    values = [value.text.replace("\n", "").replace(
        "\xa0", "") for value in rows[i].find_all("td")]
    # print(values)
    df = df.append(pd.Series(values), ignore_index=True)


df.columns = col
df.columns[3]

df.rename(columns={'Revenue (by US$ million)': 'Revenue'}, inplace=True)

# get rid of the commas
df.Revenue = df['Revenue'].str.replace(",", "")
df.head()

# change the type of Revenue from text to numeric
df.Revenue = pd.to_numeric(df.Revenue)

# Find the total of revenue by industry

df.groupby("Industry")["Revenue"].sum()
