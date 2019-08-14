#get the connector
import snowflake.connector
#get the file handling module
from codecs import open

#set some variables.
accountname = 'docusign'
username = 'BISHAL.GUPTA@DOCUSIGN.COM'
MyPassword = '' #Free text variable in python, never enter creds...

# Create the connection
ctx = snowflake.connector.connect(
   user=username,
   password=MyPassword,
   account=accountname,
   authenticator='externalbrowser'
   )
cs = ctx.cursor()

#test connectivity to snowflake
try:
   cs.execute("SELECT current_version()")
   one = cs.fetchone()
   print(one[0])

   print('Does the session stay active?')

   cs.execute("SELECT current_version()")
   one = cs.fetchone()
   print(one[0])
finally:
   ''' '''
   
# Now execute sql scripts to setup database, warehouse, schemas, tables, views and permission in Snowflake Cloud 
ret_values_list = []     # Init.:  list for return values of sql execution
with open('/9dt/ANALYTICS_GAME/Script_Create_Database.sql', 'r', encoding='utf-8') as f:
   for cursor in cs.execute_stream(f, remove_comments=False): #execute all sql statements 
      for ret in cursor:
		#save return values from each sql statements
			#print(ret) 
            ret_values_list.append(ret)
with open('/99dt/Warehouse/DT_LARGE.sql', 'r', encoding='utf-8') as f:
   for cursor in cs.execute_stream(f, remove_comments=False): #execute all sql statements 
      for ret in cursor:
		#save return values from each sql statements
			#print(ret) 
            ret_values_list.append(ret)		
with open('/99dt/Warehouse/DT_MEDIUM.sql', 'r', encoding='utf-8') as f:
   for cursor in cs.execute_stream(f, remove_comments=False): #execute all sql statements 
      for ret in cursor:
		#save return values from each sql statements
			#print(ret) 
            ret_values_list.append(ret)
with open('/99dt/Warehouse/DT_SMALL.sql', 'r', encoding='utf-8') as f:
   for cursor in cs.execute_stream(f, remove_comments=False): #execute all sql statements 
      for ret in cursor:
		#save return values from each sql statements
			#print(ret) 
            ret_values_list.append(ret)			
with open('/99dt/Schemas/9dt.sql', 'r', encoding='utf-8') as f:
   for cursor in cs.execute_stream(f, remove_comments=False): #execute all sql statements 
      for ret in cursor:
		#save return values from each sql statements
			#print(ret) 
            ret_values_list.append(ret)
with open('/9dt/ANALYTICS_GAME/Script_Create_Populate_StagingTables.sql', 'r', encoding='utf-8') as f:
   for cursor in cs.execute_stream(f, remove_comments=False): #execute all sql statements 
      for ret in cursor:
		#save return values from each sql statements
			#print(ret) 
            ret_values_list.append(ret)
with open('/9dt/ANALYTICS_GAME/Script_DM_CreateViews_Business_Analysis.sql', 'r', encoding='utf-8') as f:
   for cursor in cs.execute_stream(f, remove_comments=False): #execute all sql statements 
      for ret in cursor:
		#save return values from each sql statements
			#print(ret) 
            ret_values_list.append(ret)			
except snowflake.connector.errors.ProgrammingError as e:
	#error message
	print(e)
cs.close()