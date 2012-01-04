# Installation Notes

# Use the existing .war file

Download the .war file from the Downloads page on GitHub:

http://cloud.github.com/downloads/NathanNeff/enrollio/enrollio-0.1.war

# Building the War file from source

See the "Building War File" section in DEVELOPER_NOTES.markdown.


# JNDI Data Source

Put this in your context.xml and smoke it:

<Resource name="jdbc/enrollioDataSource" auth="Container" type="javax.sql.DataSource"
maxActive="100" maxIdle="30" maxWait="10000"
username="yourusernamehere" password="yourpasswordhere" driverClassName="com.mysql.jdbc.Driver" />
~                                                                                                                                     
~                                                                                       


Lucene
