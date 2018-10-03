#!/usr/bin/perl

$/ = "\n";
$\ = "";
$, = "";

open(FH_IN,  "<in.pdf");
open(FH_OUT, ">out.pdf");
binmode(FH_IN);
binmode(FH_OUT);

my $buffer         = '';
my $pattern_start  = qr/^\d+\s+\d+\s+obj/;
my $pattern_end    = qr/endobj\b/;
my $pattern_filter = qr/\/Private\s+\/Watermark/;

while (my $line = <FH_IN>) {
  if ($buffer){
    $buffer = $buffer . $line;

    if ($line =~ m/$pattern_end/){

      if ( $buffer =~ m/$pattern_filter/ ){
        $buffer = '';
      } else {
        print FH_OUT $buffer;
        $buffer = '';
      }

    }
  }

  else {

    if ( $line =~ m/$pattern_start/ ){
      $buffer = $line;
    } else {
      print FH_OUT $line;
    }

  }

}

if ($buffer){
  print FH_OUT $buffer;
  $buffer = '';
}

close (FH_IN);
close (FH_OUT);
