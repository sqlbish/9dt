# importing the requests library
import requests
import json

# api-endpoint
# loop iterator to infinite number until an empty array is resulted from the get http request
n = [1]
for pageNum in n:
    n.append(pageNum + 1)
    URL = "https://x37sv76kth.execute-api.us-west-1.amazonaws.com/prod/users?page=" + str(pageNum)
    print(URL)


# sending get request and saving the response as response object
    r = requests.get(url = URL)

# extracting data in json format
    data = r.json()
    print(data)
    if not data:
        print('a is an empty list')
        break

# writing the output to a local file on the server
    with open('c:/temp/player_profile.json', 'a') as outfile:
        json.dump(data, outfile)
