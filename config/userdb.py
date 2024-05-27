import sqlite3
import logging

#Connect to the sqlite3 database
conn = sqlite3.connect('/opt/user.db')
c = conn.cursor()

#Create the sqlite3 Table
c.execute('''CREATE TABLE IF NOT EXISTS users
                (userid text not null, key text not null)''')

#Create a constraint so dupes cannot be added
c.execute('''CREATE unique index IF NOT EXISTS id on users (userid, key)''')

#Define Logging
logging.basicConfig( filename='userdb.log', level=logging.INFO)

#Demo User
userid = "testuser"
key = 12345

try:
	#Add the request into the Database
	c.execute("INSERT INTO users VALUES (?,?)", (userid, key))
	conn.commit()

#Print current database
for row in c.execute('SELECT * FROM users'):
	print(row)
