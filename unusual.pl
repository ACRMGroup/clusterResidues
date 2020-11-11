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
#   Copyright:  (c) Prof. Andrew C. R. Martin, UCL, 2020
#   Author:     Prof. Andrew C. R. Martin
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
#use FindBin;
#use lib $FindBin::Bin;
# Or if we have a bin directory and a lib directory
#use Cwd qw(abs_path);
use FindBin;
#use lib abs_path("$FindBin::Bin/../lib");

#*************************************************************************
%throneHash = (
    'ALA' => 'A',
    'CYS' => 'C',
    'ASP' => 'D',
    'GLU' => 'E',
    'PHE' => 'F',
    'GLY' => 'G',
    'HIS' => 'H',
    'ILE' => 'I',
    'LYS' => 'K',
    'LEU' => 'L',
    'MET' => 'M',
    'ASN' => 'N',
    'PRO' => 'P',
    'GLN' => 'Q',
    'ARG' => 'R',
    'SER' => 'S',
    'THR' => 'T',
    'VAL' => 'V',
    'TRP' => 'W',
    'TYR' => 'Y'
    );

my $species  = defined($::s)?$::s:"Human";
my $dataDir  = $FindBin::Bin;
my $dataFile = "${dataDir}/${species}Chothia.freq";

my %freqData = ReadFreqData($dataFile);
if(defined($freqData{'ERROR'}))
{
    print "$freqData{'ERROR'}";
    exit 1;
}

WriteResults(%freqData);

#*************************************************************************
sub throne
{
    my($three) = @_;
    return($three) if(length($three) == 1); # 1-letter code already

    if(defined($throneHash{$three}))
    {
        return($throneHash{$three});
    }

    return('X');
}

#*************************************************************************
sub WriteResults
{
    my(%freqData) = @_;
    
    while(<>)
    {
        chomp;
        my($resid, $resnam) = split;
        $resnam = throne($resnam);
        my $key = "${resid}:${resnam}";
        my $freq = defined($freqData{$key})?$freqData{$key}:0.0;
        print "$resid $freq\n";
    }
}

#*************************************************************************
sub ReadFreqData
{
    my($dataFile) = @_;
    my %freqData = ();

    if(open(my $fp, '<', $dataFile))
    {
        while(<$fp>)
        {
            chomp;
            my @fields = split;
            my $key = "$fields[0]:$fields[1]";
            $freqData{$key} = $fields[2];
        }
        close($fp);
    }
    else
    {
        $freqData{'ERROR'} = <<__EOF;
Error - residue frequency file cannot be read:
        $dataFile
__EOF
    }

    return(%freqData);
}

