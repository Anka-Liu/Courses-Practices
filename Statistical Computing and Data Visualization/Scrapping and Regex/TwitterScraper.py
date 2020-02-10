# ! pip install tweepy
# ! pip install textblob

##########
# Part 1 #
###############################################################################################################
### Title:  Streaming Live Tweets
### Link: https://www.youtube.com/watch?v=wlnx-7cm4Gg
### Github code: https://github.com/vprusso/youtube_tutorials/tree/master/twitter_python/part_1_streaming_tweets
###############################################################################################################

# What we will cover:
#   - Create twitter application through twitter
#   - Write python code that interface with this application to stream tweets in real time based on keywords or hashtags


from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream
from tweepy import API
from tweepy import Cursor
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from textblob import TextBlob
import re # regular expressions

# import twittercredentials

# Variables that contain the user credentials to access twitter API
ACCESS_TOKEN = "16893876-PtGLo3MiPcON3p5BgFZi4i5ZGM9NSzHBnBjQBxlTw"
ACCESS_TOKEN_SECRET = "1STlqKHHQtrulB0DdU87ylaeMBxGd2wo7dwXrvQdHKZwF"
CONSUMER_KEY = "dBSUjL8qzGuOm6Typ6OgGKW6G"
CONSUMER_SECRET = "WiJB3quC14DpYexZhYKRFMaO90l8NdBlk9EAY5eZfNStbfuT4r"



# This handles Twitter authetification and the connection to Twitter Streaming API
#listener = StdOutListener(fetched_tweets_filename)
auth = OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
auth.set_access_token(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)
#stream = Stream(auth, listener)


# hash_tag_list = ["donald trump", "hillary clinton", "barack obama", "bernie sanders"]
# fetched_tweets_filename = "tweets.json"
#
# # This line filter Twitter Streams to capture data by the keywords:
# stream.filter(track=hash_tag_list)
#
# with open(fetched_tweets_filename, 'a') as tf:
#     tf.write(data)

##########
# Part 2 #
###############################################################################################################
### Title:  Cursor and Pagination
### Link: https://www.youtube.com/watch?v=rhBZqEWsZU4
### Github code: https://github.com/vprusso/youtube_tutorials/tree/master/twitter_python/part_2_cursor_and_pagination
###############################################################################################################

twitter_client = API(auth)
twitter_user = "uscmarshall"
num_tweets = 20
num_friends = 3

tweets = []
for tweet in Cursor(twitter_client.user_timeline, id= twitter_user).items(num_tweets):
    tweets.append(tweet)
tweets


friend_list = []
for friend in Cursor(twitter_client.friends, id= twitter_user).items(num_friends):
    friend_list.append(friend)
friend_list


home_timeline_tweets = []
for tweet in Cursor(twitter_client.home_timeline, id=twitter_user).items(num_tweets):
    home_timeline_tweets.append(tweet)
home_timeline_tweets


##########
# Part 3 #
###############################################################################################################
### Title:  Analyzing Tweet Data
### Link: https://www.youtube.com/watch?v=WX0MDddgpA4
### Github code: https://github.com/vprusso/youtube_tutorials/tree/master/twitter_python/part_3_analyzing_tweet_data
###############################################################################################################

# print(dir(tweets[0])) # to find out what information we get with tweets

df = pd.DataFrame(data=[tweet.text for tweet in tweets], columns=['tweets'])

df['id'] = pd.Series([tweet.id for tweet in tweets])
df['len'] = pd.Series([len(tweet.text) for tweet in tweets])
df['date'] = pd.Series([tweet.created_at for tweet in tweets])
df['source'] = pd.Series([tweet.source for tweet in tweets])
df['likes'] = pd.Series([tweet.favorite_count for tweet in tweets])
df['retweets'] = pd.Series([tweet.retweet_count for tweet in tweets])


df.head()

##########
# Part 4 #
###############################################################################################################
### Title:  Visualzing Tweet Data
### Link: https://www.youtube.com/watch?v=w9tAoscq3C4
### Github code: https://github.com/vprusso/youtube_tutorials/tree/master/twitter_python/part_4_visualizing_tweet_data
###############################################################################################################

# mean tweet length for uscmarshall account
np.mean(df.len)

# number of likes for the most liked tweet
np.max(df.likes)



### Likes vs. Retweets

plt.figure(figsize = (12, 4))
plt.plot(df['date'], df['likes'], label = "Likes", color = "tab:orange")
plt.plot(df['date'], df['retweets'], label = "Retweets", color = "tab:blue")
plt.legend()
plt.show()


##########
# Part 5 #
###############################################################################################################
### Title:  Sentiment Analysis for Tweet Data
### Link: https://www.youtube.com/watch?v=pdnTPUFF4gA
### Github code: https://github.com/vprusso/youtube_tutorials/tree/master/twitter_python/part_5_sentiment_analysis_tweet_data
###############################################################################################################



# clean the tweet

def removeURL(tweet):
    return ' '.join(re.sub("(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])|(\w+:\/\/\S+)", " ", tweet.text).split())

tweets[0:10]

clean_tweets = [removeURL(tweet) for tweet in tweets]
clean_tweets[0:10]
sentiment_objects = [TextBlob(tweet) for tweet in clean_tweets]

# sentiment_objects[0].polarity, sentiment_objects[0]

sentiment_values = [[tweet.sentiment.polarity, str(tweet)] for tweet in sentiment_objects]

sentiment_df = pd.DataFrame(sentiment_values, columns=["polarity", "tweet"])


fig, ax = plt.subplots(figsize=(8, 6))

Plot histogram of the polarity values
sentiment_df.hist(bins=[-1, -0.75, -0.5, -0.25, 0.25, 0.5, 0.75, 1],
             ax=ax,
             color="purple")

plt.title("Sentiments Distribution")
plt.show()
