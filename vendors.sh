#!/bin/bash

#git clone https://github.com/puikinsh/gentelella -b 1.4.0 
#copy all vendor reference to priv
JS=`grep script $1/production/*| sort -u | grep vendors | awk -F'"' '{print $2}' | grep "^\.\."`
CSS=`grep style $1/production/*| sort -u | grep vendors | awk -F'"' '{print $2}' | grep "^\.\."`
DIR=priv

for i in $JS
 do
   p=`echo $i|sed "s/^\.\.//"`
   path=$1$p
   n=$DIR$p
   mkdir -p $n
   rmdir $n
   cp $path $n
 done

for i in $CSS
 do
   p=`echo $i|sed "s/^\.\.//"`
   path=$1$p
   n=$DIR$p
   mkdir -p $n
   rmdir $n
   cp $path $n 
 done 

cp -r $1/vendors/bootstrap/dist/fonts/ priv/vendors/bootstrap/dist/fonts/
cp -r $1/vendors/font-awesome/fonts/ priv/vendors/font-awesome/fonts
cp -r $1/vendors/iCheck/skins/ priv/vendors/iCheck/skins/
cp -r $1/production/images/ priv/images
