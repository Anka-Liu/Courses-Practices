
# import necessary packages
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import squarify
from bs4 import BeautifulSoup
from urllib.request import urlopen

# import html

html = urlopen("https://www.nytimes.com/interactive/2020/us/elections/democratic-polls.html")
soup = BeautifulSoup(html)

table = soup.find("table", {"class": "g-candidates-table"})
table

candidate_name = [value.text for value in table.find_all("span", {"class": "g-desktop"})]
candidate_name
rows = table.find_all("tr")

cols = [var.text.replace("\n", "") for var in rows[0].find_all("th")]

# Create an empty dataframe
df = pd.DataFrame()

# Extract all other rows in the data

for i in range(1, len(rows)):
    values = [value.text for value in rows[i].find_all("td")]
    # print(values)
    df = df.append(pd.Series(values), ignore_index=True)

df.columns = cols
df.columns = ["Candidate", "National Polling Average",
              "Individual Contributions", "Weekly News Coverage"]

df
df.drop(17, axis=0, inplace=True)

df['Candidate'] = candidate_name


datavis = df.iloc[0:8, :]  # get the candidates who have at least 2%
datavis
# clean the data
datavis['National Polling Average'] = datavis['National Polling Average'].str.replace("%", "")
datavis['Individual Contributions'] = datavis['Individual Contributions'].str.replace(
    "$", "").str.replace("m", "")
datavis['Weekly News Coverage'] = datavis['Weekly News Coverage'].str.replace("#", "")

# make the data numeric
datavis['National Polling Average'] = pd.to_numeric(datavis['National Polling Average'])
datavis['Individual Contributions'] = pd.to_numeric(datavis['Individual Contributions'])
datavis['Weekly News Coverage'] = pd.to_numeric(datavis['Weekly News Coverage'])

datavis


datavis.sort_values('National Polling Average', inplace=True)

datavis['color'] = ["darkblue" if x >= 10 else "grey" for x in datavis.iloc[:, 1]]

fig = plt.figure(figsize=(3.841, 7.195), dpi=1000)

# add the dots
plt.scatter(x=datavis.iloc[:, 1],
            y=datavis.Candidate,
            color=datavis.color,
            alpha=0.6,
            s=20
            )

# add the lines
ax = plt.gca()
ax.hlines(y=datavis.Candidate,
          xmin=0.5,
          xmax=30,
          linewidth=0.8,
          linestyle="-.",
          color="grey",
          alpha=0.6)

plt.title("Which Democrates Are Leading \n the 2020 Presidential Race?")
plt.xlabel('Polling Average')

# get rid of the y-ticks
ax.yaxis.set_ticks_position('none')

ax.set_xticks(np.arange(0, 31, 5))
ax.set_xticklabels([str(x) + "%" for x in np.arange(0, 31, 5)])
plt.show()

fig.savefig("/Users/abbassalsharif/Documents/GitHub/DSO545/03_Homework/Homework_05/dotplot.png")


datavis

# Tree map

datavis["Contribution Percent"] = datavis.iloc[:, 2]/datavis.iloc[:, 2].sum()
datavis

datavis["Contribution Percent"] = round(datavis.iloc[:, 5], 2)*100

datavis

labels = datavis.apply(lambda x: str(x[0]) + "\n" + "(" + str(round(x[5])) + "%" + ")", axis=1)
colors = plt.get_cmap('Spectral')(np.linspace(0, 1, len(labels)))


plt.figure(figsize=(8, 8))
squarify.plot(sizes=datavis["Contribution Percent"], label=labels, color=colors, alpha=0.8)
plt.title("Who is Leading the Money Race?")
plt.axis("off")
