#Python script to upload the JSON data into AWS S3 bucket
#It will then be imported into a staging table from the S3 bucket

import boto3

s3 = boto3.client(
    's3',
    region_name='us-west-2',
    aws_access_key_id='AKIAI63D7ZTJCJC2XKRA',
    aws_secret_access_key='<Get from AWS>'
)

s3.upload_file('c:/temp/player_profile.json','98point6','player_profile.json')