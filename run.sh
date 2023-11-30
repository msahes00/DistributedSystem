#!/bin/bash
# asume hadoop is located in /usr/local/hadoop
HADOOP="/usr/local/hadoop"
export PATH="$PATH:$HADOOP/bin"

echo "******************************************************"
echo "****             Build the project                ****"
echo "******************************************************"
mvn package

echo "******************************************************"
echo "****         Deleting output directory            ****"
echo "******************************************************"
rm -R ./output

echo "******************************************************"
echo "****           Running Hadoop in local            ****"
echo "******************************************************"
hadoop jar hadoop-practice.jar -conf ./conf/hadoop-local.xml ./input/ ./output

echo "******************************************************"
echo "****      Execucion result of Hadoop in local     ****"
echo "******************************************************"
cat ./output/*

echo "******************************************************"
echo "****          Set up pseudo-cluster mode          ****"
echo "******************************************************"
hadoop namenode -format
$HADOOP/sbin/start-dfs.sh
$HADOOP/sbin/start-yarn.sh


echo "******************************************************"
echo "****            Creating input in HDFS            ****"
echo "******************************************************"
hadoop fs -rm -R /input
hadoop fs -mkdir /input

echo "******************************************************"
echo "****           Copy input data into HDFS          ****"
echo "******************************************************"
hadoop fs -copyFromLocal ./input/* /input

echo "******************************************************"
echo "****        Deleting output HDFS directory        ****"
echo "******************************************************"
hadoop fs -rm -R /output

echo "******************************************************"
echo "****         Running Hadoop in localhost          ****"
echo "******************************************************"
hadoop jar hadoop-practice.jar -conf ./conf/hadoop-localhost.xml /input /output

echo "******************************************************"
echo "****    Execucion result of Hadoop in localhost   ****"
echo "******************************************************"
hadoop fs -cat /output/*

