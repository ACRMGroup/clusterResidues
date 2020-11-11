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

# Get the filename
my $hphobFile = defined($::c)?$::c:"consensus.hpb";

# Read the hydrophobicity data
my $fh = OpenFile($hphobFile);
die "Can't read $hphobFile" if(!$fh);
my %hphob = ReadHPhob($fh);
close($fh);

# Loop through the file getting and printing the hydrophobicity for each
# residue
while(<>)
{
    chomp;
    my @fields = split;
    my $hphob = GetHPhob($fields[1], %hphob);

    print "$fields[0] $hphob\n";
}

#*************************************************************************
# Get the hydrophobicity for an amino acid specified using either 3-letter
# or 1-letter code
#
# 06.05.15 Original   By: ACRM
sub GetHPhob
{
    my ($aa, %hphob) = @_;
    chomp $aa;
    $aa = "\U$aa";
    if(length($aa) == 1)
    {
        $aa = $::onethr{$aa};
    }
    return $hphob{$aa} if(defined($hphob{$aa}));

    return(-9999);
}

#*************************************************************************
# Reads a hydrophobicity file specified in the file handle and returns
# a hash of hydrophobicity values using 3-letter code as the key.
#
# 06.05.15 Original   By: ACRM
sub ReadHPhob
{
    my($fh) = @_;
    my %hphob = ();

    # Skip first line
    <$fh>;

    while(<$fh>)
    {
        chomp;
        s/\#.*//;               # Remove comments
        s/^\s+//;               # Remove leading whitespace
        s/\s+$//;               # Remove trailiing whitespace
        if(length())
        {
            my @fields = split;
            my $aa = $fields[0];
            $aa = "\U$aa";
            $hphob{$aa} = $fields[1] * 1.0; # Force to number
        }
    }

    return(%hphob);
}


#*************************************************************************
# Opens a file for reading. Tries first with the filename as specified,
# then tries prepending the path to the program and finally tries
# prepending the DATADIR environment variable. 
# Returns the filehandle
#
# 06.05.15 Original   By: ACRM
sub OpenFile
{
    my($filename) = @_;
    my $fh;

    # First try the filename as given
    return($fh) if(open($fh, '<', $filename));

    # Now try prepending the binary path onto the filename
    my $fullfilename = "$FindBin::Bin/$filename";
    return($fh) if(open($fh, '<', $fullfilename));

    # Now try prepending the DATADIR enbironment variable onto the filename
    if(defined($ENV{'DATADIR'}))
    {
        $fullfilename = "$ENV{'DATADIR'}/$filename";
        return($fh) if(open($fh, '<', $fullfilename));
    }

    # Give up!
    return(0);
}

#*************************************************************************
# 06.05.15 Original   By: ACRM
sub UsageDie
{
    print <<__EOF;

Usage: hydrophobicity [-c hphobFile] [in.num] > out.hyd
       -c specify hydrophobicity file (default: consensus.hpb)

Takes a numbered sequence file (in .seq format) and outputs the residue
numbers together with hydrophobicities.

__EOF

    exit 0;    
}
