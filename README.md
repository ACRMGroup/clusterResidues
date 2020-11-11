clusterResidues
===============

A program for finding clusters of residues matching a set of
criteria. You need:

- a distance matrix to define distances between residues in the PDB file of interest 
- one or more property files describing properties for each residue position

Distance matrices averaged across all antibody structures are provided (see below).

To run the program you give it the distance matrix followed by one or more pairs of property files and cutoffs. Type

    ./clusterResidues.pl -h

for help.

For a quick demo:
    FIRST INSTALL BIOPTOOLS

then type:

    ./clusterSurfaceHPhob.sh test/1yqv.num

This:
- takes a numbered sequence file for an antibody and assigns the hydrophicity scores
- uses the averaged distance data for all atom pairs for antibodies
- clusters residues if they are closer that 4.0A
- requires at least three residues are present in each cluster
- requires that the accessibility (from the accessibility data calculated for antibody 1yqv) is >20%
- requires that the hydrophobicity scores are >0.2


Programs
--------

### clusterResidues.pl
This is the main clustering program

### hydrophibicity.pl
Takes a numbered sequence file and generates a hydrophobicity file

### unusual.pl
Takes a numbered sequence file and generates a file of residue frequencies

### access.sh
Takes a PDB file and generates a file listing residue identifiers and
relative sidechain accessibility

### clusterSurfaceHPhob.sh
Wrapper to hydrophobicity.pl and clusterResidues.pl that finds surface
hydrophobic patches

### clusterSurfaceUnusual.sh
Wrapper to unusual.pl and clusterResidues.pl that finds surface
unusual residue patches

Data files
----------
- `distmat.dat`      - full CA distance matrix from December 2011
- `access.dat`       - residue accessibility file generated from 1yqv

- `distmat_all.dat`  - test all atom distance matrix from 2 PDBs
- `distmat_sc.dat`   - test sidechain atom distance matrix from 2 PDBs

- `1yqv.hyd`         - Output of hydrophobicity.pl on 1yqv.num
- `1yqv.num`         - Numbered 1yqv file
- `1yqv.pdb`         - 1YQV - Fv fragment
- `HumanChothia.dat` - 

The distance matrix files are created using the distmat program from
git@github.com:UCL/abysis.git/abysis/src/c/distmat
or from
git@github.com:ACRMGroup/bioplib.git


Notes
-----

We need to generate average accessibilities using Chothia numbered PDBs.

Need to enforce Chothia numbering throughout

