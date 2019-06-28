numfile=$1

if [ "X$numfile" = "X" ]; then
   echo "Usage: clusterSurfaceHPhob.sh file.num"
   echo "       Takes a numbering file and generates clusters of surface hydrophobics"
   exit 0
fi

stem=`basename $numfile .num`

./hydrophibicity.pl $numfile > /tmp/$stem.hyd
./clusterResidues.pl -d=4.0 -m=3 distmat_all.dat access.dat '>20' /tmp/$stem.hyd '>0.2'
