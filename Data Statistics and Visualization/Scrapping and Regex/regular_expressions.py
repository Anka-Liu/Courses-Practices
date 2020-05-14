# Sources: https://www.youtube.com/watch?v=WQlKPdKVXfw
# A regular expression is a set of characters that helps one identify strings of a specific pattern

import re

###########################################################################################
#   *   : preceding character/pattern is repeated zero or more times
#   +   : preceding charatcer/pattern is repeated at least once
#   {}  : preceding character/pattern is repeated as many times as mentioned in brackets
#   .   : represents a single occurance of any character except new line (\n)
#   ?   : preceding character/pattern is optional
#   ^   : specifies that the match must start at the begining of the string
#   $   : specifies that the match must occur at the end of the string
#   []  : matches one out of all the characters within brackets
#   [^..]   : matches any one characters except those not in brackets
#   \d  : matches a digit
#   \w  : matches an alphanumeric charatcer
#   \s  : matches a white space character
###########################################################################################


# Example 1:

mytext = "Abcd 4 computer 765 Python 687"

#######################
pattern = "computer"
re.findall(pattern, mytext)

#######################
pattern = r"[a-z]+"
re.findall(pattern, mytext)

#######################
pattern = r"[a-zA-Z]+"
re.findall(pattern, mytext)

#######################
mytext = "Abcd4computer 765 Python 687"
pattern = r"[a-zA-Z]+"
re.findall(pattern, mytext)

#######################
mytext = "Abcd4computer 765 Python 687"
pattern = r"[0-9]+"
re.findall(pattern, mytext)

#######################
mytext = "Abcd4computer 765 Python 687"
pattern = r"[0-9a-zA-z]+"
re.findall(pattern, mytext)

#######################
mytext = "Abcd4computer 765 Python 687"
pattern = r"[^APy]+"
re.findall(pattern, mytext)

####################################################################
####################################################################

mytext = ['apple', 'banana', 'orange', 'avocado', 'cherries']

#######################
pattern = r'^a.+'
for m in mytext:
    match = re.findall(pattern, m)
    if match != []:
        print(match)

#######################
pattern = r'.+a$'
for m in mytext:
    match = re.findall(pattern, m)
    if match != []:
        print(match)

#######################
pattern = r'.*s'
for m in mytext:
    match = re.findall(pattern, m)
    if match != []:
        print(match)

#######################
pattern = r'\b[aeiou].+\b'
for m in mytext:
    match = re.findall(pattern, m)
    if match != []:
        print(match)

#######################
# search and sub
pattern = r'\b[aeiou].+\b'
for m in mytext:
    match = re.sub(pattern, "****", m)
    if match != []:
        print(match)

#####################################################################
#####################################################################

mytext = ["dso@gmail.com", "dso.545", "dso545@gmail.com", "dso@gmail"]

#######################
pattern = r'[a-z]+[0-9]*[a-z]*@[a-z]+\.[(com)|(edu)]'
for m in mytext:
    match = re.findall(pattern, m)
    if match != []:
        print(match)

#####################################################################
#####################################################################

mytext = ['213-740-4826', '213 740 4826', '2137404826', "(213) 740 4826"]

#######################
pattern = r'[1-9]{3}[-\s]?[0-9]{3}[-\s]?[0-9]{4}'
for m in mytext:
    match = re.findall(pattern, m)
    if match != []:
        print(match)

#####################################################################
#####################################################################

mytext = ['213-740-4826', '213 740 4826', '2137404826', "(213) 740 4826", "9823749327498732"]

#######################
pattern = r'\b[(]?[1-9]{3}[)]?[-\s]?[0-9]{3}[-\s]?[0-9]{4}\b'
for m in mytext:
    match = re.findall(pattern, m)
    if match != []:
        print(match)
