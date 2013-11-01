#test file for Twitter API

#python wrapper
import twitter
#regex
import re



#ID for testing app, linked to my personal twitter account
#sign in on dev.twitter.com to get your details
#right for READ-ONLY



print "try logging in and check user api"


CKey =  'US5nqYmVCp1GMuA9t2GfDA'
CSecret = 'HQkCTDFaBfZ0eXMvT4Yzy7dDwRneakf3ySX9HwNbNk'
AToken =  '230467079-Ri8fpTsCxGHx880LEGvi1BFNn4V3uhqE1AJPMW0P'
ATokenSecret = 'rVtgvMOp1PvmZ1YsuVjH0hWEIEYqaKiDeUP24sqw'

api = twitter.Api(consumer_key= CKey,
                  consumer_secret= CSecret,
                  access_token_key= AToken,
                  access_token_secret= ATokenSecret)
api2 = twitter.Api()

print api.VerifyCredentials()

print "\n####test retrieve tweets and look for hashtags#####\n"

#users = api2.GetUserByEmail("anis.fehri@gmail.com")
#print [u for u in users]


#tuser to consider 
tname = "edwyplenel"
print api.GetUser(screen_name=tname)
#hashtag pattern
patternHashtag = '[#]+[\w_-]+'

statuses = api.GetUserTimeline(screen_name= tname)
for s in statuses[:]: 
    print re.findall(patternHashtag,s.text.encode('utf-8'))

print type(statuses)

print "\nhoho\n"

