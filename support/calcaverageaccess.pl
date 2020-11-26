#!/usr/bin/perl

# Simple script to calculate average solvent accessibilities for the
# Chothia numbered antibodies

use strict;
use lib '.';
use sequtils;

my $abdir='/serv/www/webdata/abdb/NR_LH_Combined_Chothia';

my %sumacc = ();
my %counts = ();

#my $counter = 0;

if(opendir(my $dh, $abdir))
{
    my $tfile = "/var/tmp/caa_" . $$ . time();
    my @abfiles = grep(!/^\./, readdir($dh));
    closedir($dh);

    foreach my $ab (@abfiles)
    {
        my $abfile = "$abdir/$ab";
        print STDERR "$abfile\n";
        `pdbgetchain L,H $abfile | pdbsolv -n -r $tfile`;
        UpdateAccCounts($tfile, \%sumacc, \%counts);

#        last if(++$counter >= 5);
    }

    PrintAverages(\%sumacc, \%counts);
}

sub PrintAverages
{
    my($hSumacc, $hCounts) = @_;
    my @resids = keys %$hSumacc;
    @resids = sequtils::sortResids(@resids);
    
    foreach my $key (@resids)
    {
        my $mean = $$hSumacc{$key} / $$hCounts{$key};
        printf "%-5s %7.3f\n", $key, $mean;
    }
}


sub UpdateAccCounts
{
    my($resFile, $hSumacc, $hCounts) = @_;

    if(open(my $fp, '<', $resFile))
    {
        while(<$fp>)
        {
            if(/^RESACC/)
            {
                my $resnum = substr($_,9,5);
                if($resnum < 120)
                {
                    my $label = substr($_,8,7);
                    $label =~ s/\s//g;
                    my $access = substr($_,30,7);
                    
                    if(defined($$hSumacc{$label}))
                    {
                        $$hSumacc{$label} += $access;
                        $$hCounts{$label}++;
                    }
                    else
                    {
                        $$hSumacc{$label} = $access;
                        $$hCounts{$label} = 1;
                    }
                }
            }
        }
        close $fp;
    }
}
