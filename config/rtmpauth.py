# Source: https://github.com/IRLToolkit/nginx-rtmp-auth

import mysql.connector
from mysql.connector import errorcode
import logging
from aiohttp import web
import sys
from configparser import ConfigParser

configfile = '/opt/config.ini'
config = ConfigParser()
config.read(configfile)
hostName = config.get('main', 'bind_to_ip')
hostPort = config.getint('main', 'bind_to_port')
logfile = config.get('main', 'log_to_file')
logging.basicConfig(level=logging.INFO, handlers=[logging.FileHandler(logfile), logging.StreamHandler()])

# Database Config
config = {
  'user': 'username',
  'password': 'password',
  'host': '127.0.0.1',
  'database': 'database_name',
  'raise_on_warnings': True
}

async def authhandle(request):
    ipaddress = request.remote
    logging.info('------------------------------------------------------------------------------------')
    logging.info('Recieved new auth request from IP: ' + str(ipaddress))
    body = await request.post()
    skey = body['name']
    logging.info('Recieved streamkey request of ' + str(skey))
    
    # Attempt to connect to Database
    try:
       cnx = mysql.connector.connect(**config)
       logging.info('Successfully Connected to Database')
    except mysql.connector.Error as err:
       if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
          logging.warning('Invalid username or password')
       elif err.errno == errorcode.ER_BAD_DB_ERROR:
          logging.warning('Database is invalid')
       else:
         logging.warning(err)
   
    cursor = cnx.cursor(buffered=True)
    query = ("SELECT streamkey FROM auth WHERE streamkey = %s")
    cursor.execute(query, (skey,))
    dbkey = cursor.fetchall()
    if dbkey:
       logging.info('Publish authenticated. (App: {}, Streamname {})'.format(body['app'], body['name']))
       #print('KEY EXISTS')
       return web.Response(status=200)
    else:
       logging.warning('Publish failed to authenticate. (App: {}, Streamname {})'.format(body['app'], body['name']))
       #print(KEY DOES NOT EXIST)
       return web.Response(status=401)

    cursor.close()
    cnx.close()


app = web.Application()
app.add_routes([web.post('/auth/', authhandle)])
web.run_app(app, host=hostName, port=hostPort)
