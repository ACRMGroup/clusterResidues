#!/usr/bin/perl -s
#*************************************************************************
#
#   Program:    
#   File:       
#   
#   Version:    
#   Date:       
#   Function:   
#   
#   Copyright:  (c) Dr. Andrew C. R. Martin, UCL, 2015
#   Author:     Dr. Andrew C. R. Martin
#   Address:    Institute of Structural and Molecular Biology
#               Division of Biosciences
#               University College
#               Gower Street
#               London
#               WC1E 6BT
#   EMail:      andrew@bioinf.org.uk
#               
#*************************************************************************
#
#   This program is not in the public domain, but it may be copied
#   according to the conditions laid out in the accompanying file
#   COPYING.DOC
#
#   The code may be modified as required, but any modifications must be
#   documented so that the person responsible can be identified. If 
#   someone else breaks this code, I don't want to be blamed for code 
#   that does not work! 
#
#   The code may not be sold commercially or included as part of a 
#   commercial product except as described in the file COPYING.DOC.
#
#*************************************************************************
#
#   Description:
#   ============
#
#*************************************************************************
#
#   Usage:
#   ======
#
#*************************************************************************
#
#   Revision History:
#   =================
#
#*************************************************************************
# Add the path of the executable to the library path
use FindBin;
use lib $FindBin::Bin;
# Or if we have a bin directory and a lib directory
#use Cwd qw(abs_path);
#use FindBin;
#use lib abs_path("$FindBin::Bin/../lib");
use strict;

UsageDie() if(defined($::h));

%::onethr = ('A' => 'ALA',
             'C' => 'CYS',
             'D' => 'ASP',
             'E' => 'GLU',
             'F' => 'PHE',
             'G' => 'GLY',
             'H' => 'HIS',
             'I' => 'ILE',
             'K' => 'LYS',
             'L' => 'LEU',
             'M' => 'MET',
             'N' => 'ASN',
             'P' => 'PRO',
             'Q' => 'GLN',
             'R' => 'ARG',
             'S' => 'SER',
             'T' => 'THR',
             'V' => 'VAL',
             'W' => 'TRP',
             'Y' => 'TYR');

my %charge = ('ALA' => 0,
              'CYS' => 0,
              'ASP' => -1,
              'GLU' => -1,
              'PHE' => 0,
              'GLY' => 0,
              'HIS' => 0.5,
              'ILE' => 0,
              'LYS' => 1,
              'LEU' => 0,
              'MET' => 0,
              'ASN' => 0,
              'PRO' => 0,
              'GLN' => 0,
              'ARG' => 1,
              'SER' => 0,
              'THR' => 0,
              'VAL' => 0,
              'TRP' => 0,
              'TYR' => 0);


# Loop through the file getting and printing the charge for each
# residue
while(<>)
{
    chomp;
    my @fields = split;
    my $charge = GetCharge($fields[1], %charge);

    print "$fields[0] $charge\n";
}

#*************************************************************************
# Get the hydrophobicity for an amino acid specified using either 3-letter
# or 1-letter code
#
# 06.05.15 Original   By: ACRM
sub GetCharge
{
    my ($aa, %charge) = @_;
    chomp $aa;
    $aa = "\U$aa";
    if(length($aa) == 1)
    {
        $aa = $::onethr{$aa};
    }
    return $charge{$aa} if(defined($charge{$aa}));

    return(0);
}

#*************************************************************************
# 06.05.15 Original   By: ACRM
sub UsageDie
{
    print <<__EOF;

Usage: charge [in.num] > out.hyd

Takes a numbered sequence file (in .seq format) and outputs the residue
numbers together with charges.

__EOF

    exit 0;    
}
