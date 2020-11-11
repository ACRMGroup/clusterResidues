numfile=$1

if [ "X$numfile" = "X" ]; then
   echo "Usage: clusterSurfaceUnusual.sh file.num"
   echo "       Takes a numbering file and generates clusters of unusual surface residues"
   exit 0
fi

stem=`basename $numfile .num`

./unusual.pl $numfile > /tmp/$stem.unu
./clusterResidues.pl -d=4.0 -m=3 distmat_all.dat access.dat '>25' /tmp/$stem.unu '<5'
