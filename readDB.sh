#!/bin/bash
while read line
do
        alias=`echo $line | awk -F "," '{print $1}'| tr -d \"`;
        url=`echo $line | awk -F "," '{print $2}'|tr -d \"`;
        query=`echo "UPDATE REDIRECTS SET URL='$url' where id in(select id from alias where alias='$alias');"`;
        echo $query >>dml.sql
done < algo.txt

#this tiny script creates a list of update orders with the aliases and URLs
