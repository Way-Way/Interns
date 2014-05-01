Installation tips
=================

Tested on Ubuntu 12.04
The code was tested with the latest version of Hadoop available at the time (2.4)

# Resources to install Hadoop

To install Hadoop, just get the tarball from http://www.apache.org/dyn/closer.cgi/hadoop/core and untar it in a folder
The project was made with Hadoop installed in /usr/local/hadoop/, but feel free to change that folder (if you do, you'll have to update the java build path accordingly)

The following resources are for previous versions of Hadoop but are still useful. See [Tips](#tips) below for updated information.
- If you just want to work from Eclipse : http://letsdobigdata.wordpress.com/2013/12/07/running-hadoop-mapreduce-application-from-eclipse-kepler/
- If you also want a full working install of Hadoop on your machine, see also : http://www.michael-noll.com/tutorials/running-hadoop-on-ubuntu-linux-single-node-cluster/

# Editing and running the code with Eclipse
Once you have hadoop installed on your system, open the project in Eclipse,
and you can run one of the test examples by providing two arguments to the main class : the input file and the output folder name
(for instance : `sample.txt output` for the maxtemperature example)

Example input files are provided.

The output folder will contain the results of the computation, it has to be manually deleted before running the example again.

# <a name="tips"></a> Tips
- On Hadoop 2.4, the lib/ folder is replaced by share/hadoop.
You should add all the jars from the common/, yarn/ and mapreduce/ folders, including everything from
their respective lib/ subfolders, to the project build path.
- On Hadoop 2.4, the shell scripts that were in the bin/ folder are located in sbin/

Good luck !

