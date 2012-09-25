## Dart Xml ##
Dart Xml is a lightweight library for parsing and emitting xml.

## What "Lightweight" Means ##
Many programmatic scenarios concerning XML deal with serialization and
deserialization of data, usually for transmission between services). 
The querying of said data in object form is also important.  Typically 
these data are XML fragments and not fully formed XML documents. 

This project focuses the most common scenarios and does not concern itself with 
parsing of fully formed XML documents (with prologues, DOCTYPEs, etc). With the 
exception of comments, the parser expects a single node in the root of the XML
string (see **Limitations** below for more info).

Dart Developers who require more robust XML handling are encouraged to fork the
project and expand as needed.  Pull requests will certainly be welcomed.

## Getting Started ##
See the "getting_started.md" file in the doc/ directory of the project.