#!/usr/bin/perl -s
# Usage: ./getfreqdata [-s=species] >SpeciesChothia.freq

use strict;
use LWP::UserAgent;

my $url = "http://www.abysis.org/abysis/ws/resfreq.cgi?quiet=1&residue=";

my $species = defined($::s)?$::s:'Homo sapiens';

$species =~ s/\s/%20/g;
$species = "\L$species";

my @resids = qw/H1 H2 H3 H4 H5 H6 H6A H6B H6C H6D H7 H8 H9 H10 H11
    H12 H13 H14 H15 H16 H17 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27
    H28 H29 H30 H31 H31A H31B H31C H31D H31E H31F H31G H31H H32 H33
    H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49
    H50 H51 H52 H52A H52B H52C H52D H52E H52F H52G H53 H54 H55 H56 H57
    H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73
    H74 H75 H76 H77 H78 H79 H80 H81 H82 H82A H82B H82C H82D H82E H83
    H84 H85 H86 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H97 H98 H99
    H100 H100A H100B H100C H100D H100E H100F H100G H100H H100I H100J
    H100K H100L H100M H100N H100O H100P H100Q H100R H100S H100T H100U
    H100V H100W H100X H100Y H100Z H101 H102 H103 H104 H105 H106 H107
    H108 H109 H110 H111 H112 H113 H114 L1 L2 L3 L4 L5 L6 L7 L8 L9 L10
    L11 L12 L13 L14 L15 L16 L17 L18 L19 L20 L21 L22 L23 L24 L25 L26
    L27 L28 L29 L30 L30A L30B L30C L30D L30E L30F L31 L32 L33 L34 L35
    L36 L37 L38 L39 L39A L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50
    L51 L52 L53 L54 L54A L54B L54C L54D L54E L55 L56 L57 L58 L59 L60
    L61 L62 L63 L64 L65 L66 L66A L66B L66C L66D L66E L66F L66G L66H
    L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82
    L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L95A L95B L95C
    L95D L95E L95F L96 L97 L98 L99 L100 L101 L102 L103 L104 L105 L106
    L106A L107 L108 L109 L110 L111/;

my $ua = CreateUserAgent('');

foreach my $resid (@resids)
{
    my $fullURL = "$url$resid";
    my $req = CreateGetRequest($fullURL);
    my $content = GetContent($ua, $req);
    MassageAndPrintContent($content, $resid);
}


########################################################################
sub MassageAndPrintContent
{
    my($content, $resid) = @_;

    my @lines = split(/\n/, $content);
    foreach my $line (@lines)
    {
        my(@fields) = split(/\s+/, $line);
        printf("%-5s %s %6.2f\n", $resid, $fields[0], $fields[2]);
    }
}


########################################################################
sub GetContent
{
    my($ua, $req) = @_;
    my($res);

    $res = $ua->request($req);
    if($res->is_success)
    {
        return($res->content);
    }
    return(undef);
}

########################################################################
sub CreateGetRequest
{
    my($url) = @_;
    my($req);
    $req = HTTP::Request->new('GET',$url);
    return($req);
}

########################################################################
sub CreatePostRequest
{
    my($url, $params) = @_;
    my($req);
    $req = HTTP::Request->new(POST => $url);
    $req->content_type('application/x-www-form-urlencoded');
    $req->content($params);

    return($req);
}

########################################################################
sub CreateUserAgent
{                               
    my($webproxy) = @_;

    my($ua);
    $ua = LWP::UserAgent->new;
    if(length($webproxy))
    {
        $ua->proxy(['http', 'ftp'] => $webproxy);
    }
    return($ua);
}
