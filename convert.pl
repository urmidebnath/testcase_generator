#!/usr/bin/perl

use strict;
use warnings;

# this fixes the order of getting the hashes
# the hash arrays contain actual type definitions
my @size_order    = ( "word", "byte", "halfword", "wword");
my %size_array    = ( "word"     =>  "WORD",
                      "byte"     =>  "BYTE",
                      "halfword" =>  "HALF_WORD",
                      "wword"    =>  "WWORD"
                    );

my @mode_order    = ( "os", "rp_os", "con", "rp_con");
my %mode_array    = ( "os"     =>  ["ONE_SHOT", "0"],
                      "rp_os"  =>  ["REPEATED_ONESHOT", "1"],
                      "con"    =>  ["CONTINUOUS", "0"],
                      "rp_con" =>  ["REPEATED_CONTINUOUS", "0"]
                    );

my @admode_order  = ( "f2f", "f2bi","f2bd","b2fi","b2fd","b2bi","b2bd");
my %admode_array  = ("f2f"  =>  "FIXED_TO_FIXED", 
                     "f2bi" =>  "FIXED_TO_BLOCK_INC", 
                     "f2bd" =>  "FIXED_TO_BLOCK_DEC", 
                     "b2fi" =>  "BLOCK_TO_FIXED_INC", 
                     "b2fd" =>  "BLOCK_TO_FIXED_DEC", 
                     "b2bi" =>  "BLOCK_TO_BLOCK_INC", 
                     "b2bd" =>  "BLOCK_TO_BLOCK_DEC" 
                   );

my $file = "base.sv";
open my $fh, '<', $file;
my @lines = <$fh>;
close $fh;
my $original_str = join "", @lines;

my $includes = "";
my $count = 0;

print "----------------------------------------------------------------------\n";
print "|                      Testcase Generation Start                    |\n";
print "----------------------------------------------------------------------\n";
foreach my $mode (@mode_order) {

  my @mode_list = @{$mode_array{$mode}};
  my $modename = $mode_list[0];
  my $reload   = $mode_list[1];
  #print "$mode : $modename\n";

  foreach my $admode (@admode_order){

    my $admode_name = $admode_array{$admode};
    #print "\t$admode_name\n";

    foreach my $size (@size_order){
      
      # counts the number of file
      $count = $count +1;
      
      #copies the base data to new string to prevent data loss
      my $str = $original_str;

      my $sizename = $size_array{$size};
      #print "\t\t$sizename\n";

      my $tr_name = "dma_".$mode."_".$admode."_".$size;
      
      #replaces the values in place of place holders
      $str =~ s/xname/$tr_name/g;
      $str =~ s/XMODE/$modename/g;
      $str =~ s/XSIZE/$sizename/g;
      $str =~ s/XR/$reload/g;
      $str =~ s/XAD/$admode_name/g;

      #create file name
      my $nfile = "dma_test_".$count."_".$mode."_".$admode."_".$size.".sv";
      
      #create the list of include files
      $includes = $includes."`include \"".$nfile."\"\n";

      # print the code into files
      #print " $count : $nfile :$tr_name\n";
      open my $nfh, ">", $nfile;
      print $nfh $str;
      close $nfh;
      chmod 0775, $nfile;
    }
  }
}

open my $incfh, ">", "includes.sv";
print $incfh "$includes";
close $incfh;

print "                         Files generated : $count\n";
print "----------------------------------------------------------------------\n";
print "|                         Testcases generated                        |\n";
print "----------------------------------------------------------------------\n";
