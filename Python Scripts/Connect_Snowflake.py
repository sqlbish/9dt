#get the connector
import snowflake.connector
#set some variables.
accountname = 'docusign'
username = 'BISHAL.GUPTA@DOCUSIGN.COM'
MyPassword = 'xxxx' #Free text variable in python, never enter creds...
# Create the connection
ctx = snowflake.connector.connect(
   user=username,
   password=MyPassword,
   account=accountname,
   authenticator='externalbrowser'
   )
cs = ctx.cursor()
try:
   cs.execute("SELECT current_version()")
   one = cs.fetchone()
   print(one[0])

   print('Does the session stay active?')

   cs.execute("<Replace with SnowSQL Script to run against Snowflake database to setup database, schemas, and tables")
   one = cs.fetchone()
   print(one[0])
finally:
   ''' Testing'''
cs.close()