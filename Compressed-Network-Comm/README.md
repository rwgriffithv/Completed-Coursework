# Compressed Network Communication
**CS 111: Operating Systems Principles**
*1 February 2018*

This project required the use of pipes and sockets to create a multi-process telnet-like client and server. Input and output are passed over a TCP socket and given a --compress option to both programs will compress communication between the client and server using the zlib API and requires the zlib library to be installed. The two programs communicate over the localhost, using a passed port number.


The specific requirements of the final report are found in spec.pdf, and some additional information about the two source code files can be found in the README file. A test script provided by the TAs of the class is found in P1B_check.sh which requires functions.sh.
