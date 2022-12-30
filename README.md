# BinaryDoc, Binary code is the best Document

`BinaryDoc` generates Documents with rich diagrams from Binary files directly for Java.

This docker image needs to work together with `mysql` database with specified [mysql.cnf](https://github.com/fuiny/binarydoc-docker/blob/master/etc/mysql/conf.d/mysql.cnf) configurations. An sample [docker-compose.yml](https://github.com/fuiny/binarydoc-docker/blob/master/docker-compose.yml "Pre-configured BinaryDoc Docker Compose file") file has been provided.


Sample Diagrams in Generated documents:

- `Control Flow Graph` for Java method bytecode
[![Control Flow Graph for method java.net.Inet6Address.getByAddress](https://github.com/fuiny/binarydoc-help/raw/master/samples/cfg_java_method_java.net.Inet6Address_getByAddress.png)](https://github.com/fuiny/binarydoc-help/blob/master/samples/cfg_java_method_java.net.Inet6Address_getByAddress.pdf)

- `UML Sequence Diagram` for Java method bytecode
[![UML Sequence Diagram for method java.net.Inet6Address.getByAddress](https://github.com/fuiny/binarydoc-help/raw/master/samples/uml_sequence_java_method_java.net.Inet6Address_getByAddress.png)](https://github.com/fuiny/binarydoc-help/blob/master/samples/uml_sequence_java_method_java.net.Inet6Address_getByAddress.pdf)

- `UML Hierarchy Diagram` for Java Class
[![UML Hierarchy Diagram for class java.nio.channels.FileChannel](https://github.com/fuiny/binarydoc-help/raw/master/samples/uml_java_java.nio.channels.FileChannel_hierarchy.png)](https://github.com/fuiny/binarydoc-help/blob/master/samples/uml_java_java.nio.channels.FileChannel_hierarchy.pdf)
[![UML Hierarchy Diagram for class java.lang.Class](https://github.com/fuiny/binarydoc-help/raw/master/samples/uml_java_java.lang.Class_hierarchy.png)](https://github.com/fuiny/binarydoc-help/raw/master/samples/uml_java_java.lang.Class_hierarchy.pdf)
[![UML Hierarchy Diagram for class javax.swing.JTable](https://github.com/fuiny/binarydoc-help/raw/master/samples/uml_java_javax.swing.JTable_hierarchy.png)](https://github.com/fuiny/binarydoc-help/raw/master/samples/uml_java_javax.swing.JTable_hierarchy.pdf)

- `Dependency Network` diagram for Java package
[![Dependency Network Diagram for package java.beans](https://github.com/fuiny/binarydoc-help/raw/master/samples/dn_java_package_java.beans.png)](https://github.com/fuiny/binarydoc-help/raw/master/samples/dn_java_package_java.beans.pdf)

- `Jar,Jmod` files Dependency Network Diagram (`sfdp` layout)
[![Dependency Network Diagram for OpenJDK 13](https://github.com/fuiny/binarydoc-help/raw/master/samples/dn_files_gav_openjdk-net.java-openjdk-13.0_sfdp.png)](https://github.com/fuiny/binarydoc-help/blob/master/samples/dn_files_gav_openjdk-net.java-openjdk-13.0_sfdp.pdf)


There are web sites containing the documentes and diagrams generated by `BinaryDoc`:
- [BinaryDoc for OpenJDK](https://openjdk.binarydoc.org/)
- [BinaryDoc for Android](https://android.binarydoc.org/)
- [BinaryDoc for Kotlin](https://kotlin.binarydoc.org/)
- [BinaryDoc for Groovy](https://groovy.binarydoc.org/)
- [BinaryDoc for Scala](https://scala.binarydoc.org/)
- [BinaryDoc for Spring framework](https://spring.binarydoc.org/)
- [BinaryDoc for Apache Cassandra](https://apache-cassandra.binarydoc.org/)
- [BinaryDoc for Apache Tomcat](https://apache-tomcat.binarydoc.org/)
- [BinaryDoc for Eclipse Jetty](https://eclipse-jetty.binarydoc.org/)


# BinaryDoc Docker Compose User Guide

This is an sample docker compose setup for `BinaryDoc`, which generates Documents with rich diagrams from Binary files directly for Java.

- [docker-compose.yml](https://github.com/fuiny/binarydoc-docker/blob/master/docker-compose.yml)

Warning
- This docker compose setup is designed for none-production environment, better for evaluation or testing box
- Password is set in [.env](https://github.com/fuiny/binarydoc-docker/blob/master/.env), while `password vault` could be used in production
- Default RAM in [mysql.cnf](https://github.com/fuiny/binarydoc-docker/blob/master/etc/mysql/conf.d/mysql.cnf) is small, while `128 GB` or more RAM is available in production

## Hardware Requirement

BinaryDoc is a compute-intensive software which needs powerful hardware.

Here we list the suggested minimal hardware requirements:

- CPU: `8` or more threads
- RAM: `24 GB` minimal,  `64 GB` is suggested for better performance, based on the size of the Java application to be parsed
- Disk type: `SSD` Drive is suggested, `M.2 SSD` or `NVMe SSD` are preferred
- Disk size: `20 GB` or more avialbe disk space is suggested
  - The size is based on the binary data to be parsed.
  - Example: OpenJDK 11 binary data size is `387.9 MB`, and the current corresponding DB size is `7 GB`.

## Steps

Customize the config files
- [.env](https://github.com/fuiny/binarydoc-docker/blob/master/.env)
  - Change the DB password (default=`123456`) when needed
  - Change the TCP ports when needed
- [mysql.cnf](https://github.com/fuiny/binarydoc-docker/blob/master/etc/mysql/conf.d/mysql.cnf)
  - Change `innodb_buffer_pool_size` based on avabile RAM hardware and the size of application to be parsed
  - Change `innodb_buffer_pool_instances` based on parallel workloads

If running Docker on Windows
- If running on other system, ignore this step
- Change the file `etc/mysql/conf.d/mysql.cnf` permission as read only, or else the mysql file will not load it

Start the Docker Instances
- `docker-compose up -d`

Run the Parser for current OpenJDK for demo:
- [`./run-parse-demo.sh`](https://github.com/fuiny/binarydoc-docker/blob/master/run-parse-demo.sh)
  - Note. the parser execution takes about `1 hour` on `M.2 SSD` disk, and needs up to `24 GB` RAM

Run the Parser for your application:
- Put your Java Application to be Parsed to the `app-to-parse` folder
  - Example: Copy the application `.jmod` or `.jar` files to this folder
- Start the parser
  - [`./run-parse-app.sh`](https://github.com/fuiny/binarydoc-docker/blob/master/run-parse-app.sh)

Access the Web Site
- http://127.0.0.1:10180/

(Optional) Access the Backend DB if interested
- http://127.0.0.1:10190/
  - System: `MySQL`
  - Server: `binarydoc-db`
  - Username: `root`
  - Password: `123456`, or the password set in the [.env](https://github.com/fuiny/binarydoc-docker/blob/master/.env) file
  - Database: `binarydocjvmadm`
- MySQL Workbench, or Other DB Access Tools
  - Server: `localhost`
  - Port: `13306`

## Other commands

When we want to Delete Existing Docker Instances, and to Start over again
- [`./rebuild.sh`](https://github.com/fuiny/binarydoc-docker/blob/master/rebuild.sh)

When we want login to the Running Docker container
- `sudo docker-compose exec binarydoc /bin/bash`

TCP Ports Mapping
- We may change the ports `10180`, `10190`, `13306` in [.env](https://github.com/fuiny/binarydoc-docker/blob/master/.env) when necessary


# Community

- Support: [Report Issues in Github](https://github.com/fuiny/binarydoc-docker/issues)
- License: [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)

