Boundary MySQL Plugin
---------------------
Collects metrics from a MySQL database instance.

### Prerequisites

|     OS    | Linux | Windows | SmartOS | OS X |
|:----------|:-----:|:-------:|:-------:|:----:|
| Supported |   v   |    v    |    v    |  v   |


|  Runtime | LUA/luvit |
|:---------|:-------:|:------:|:----:|
| Required |    +    |        |      |


### Plugin Setup
None

#### Plugin Configuration Fields

|Field Name |Description                                                                                           |
|:----------|:-----------------------------------------------------------------------------------------------------|
|Hostname   |The hostname of the MySQL Server (Socket Path or Hostname is required)                                |
|Port       |Port to use when accessing the MySQL Server                                                           |
|Username   |Username to access the MySQL database (Username is required)                                          |
|Password   |Password to access the MySQL database (Password is required)                                          |


### Metrics Collected
Tracks the following metrics for [mysql](http://www.mysql.com/)

|Metric Name              |Description                                                                   |
|:------------------------|:-----------------------------------------------------------------------------|
|MySQL Connections        |The number of connection attempts                                             |
|MySQL Aborted Connections|The number of failed connection attempts including those aborted by the client|
|MySQL Bytes In           |bytes in                                                                      |
|MySQL Bytes Out          |bytes out                                                                     |
|MySQL Slow Queries       |The number of queries that have taken more than long_query_time seconds       |
|MySQL Row Modification   |The number of requests to insert/update/delete a row                          |
|MySQL Row Reads          |The number of requests to read a row                                          |
|MySQL Table Locks        |The number of table locks granted                                             |
|MySQL Table Wait Locks   |The number of table locks that required a wait                                |
|MySQL Commits            |The number commits                                                            |
|MySQL Rollback           |The number rollbacks                                                          |
|MySQL Query Memory       |The percentage of used query memory                                           |


