#!/usr/bin/bash
# Takes a PDB file and generates a file listing residue identifiers and 
# relative sidechain accessibility
infile=$1

if [ "X$infile" = "X" ] 
then
   echo "Usage: access.sh in.pdb >out.access"
   exit 0
fi

filebase=`basename $infile .pdb`
filebase=`basename $filebase .ent`
rsafile="/tmp/$filebase.rsa.$$"

pdbsolv -n -r $rsafile $infile
awk '{print $2$3, $8}' $rsafile | tail -n +2
\rm -f $rsafile

