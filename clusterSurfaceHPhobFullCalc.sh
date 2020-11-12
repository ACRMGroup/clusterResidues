numfile=$1
pdbfile=$2

if [ "X$numfile" = "X" ] || [ "X$pdbfile" = "X" ]; then
   echo "Usage: clusterSurfaceHPhobFullCalc.sh file.num file.pdb"
   echo "       Takes a numbering file and a PDB file and generates clusters of surface hydrophobic"
   exit 0
fi

stem=`basename $numfile .num`

echo -n "Applying residue hydrophobicity..."
./hydrophobicity.pl $numfile > /tmp/$stem.hyd
echo "done"

echo -n "Calculating distance matrix..."
distmat -s -p $pdbfile > /tmp/$stem.dist
echo "done"

echo -n "Calculating solvent accessibility..."
./access.sh   $pdbfile > /tmp/$stem.sa
echo "done"

echo "Performing clustering:"
./clusterResidues.pl -d=4.5 -m=3 /tmp/$stem.dist /tmp/$stem.sa '>12' /tmp/$stem.hyd '>0.2'
