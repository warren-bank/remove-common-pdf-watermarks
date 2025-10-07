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
my $pattern_filter = qr/\(https?:\/\/oceanofpdf\.com\/\)/;

my $stream                      = 0;
my $pattern_stream_start        = qr/^stream$/;
my $pattern_stream_end          = qr/^endstream$/;
my @pattern_stream_text_filters = (
  qr/\<0032004600480044005100520049003300270029\>/,  # "OceanofPDF"
  qr/\<0011004600520050\>/                           # ".com"
);

while (my $line = <FH_IN>) {
  if ($buffer){

    # process stream (if appropriate)
    if ($stream) {
      if ($line =~ m/$pattern_stream_end/){
        $stream = 0;
      }
      else {
        # filter text in stream
        foreach my $pattern_stream_text_filter (@pattern_stream_text_filters) {
          $line =~ s/$pattern_stream_text_filter/<>/g;
        }
      }
    }
    elsif ( $line =~ m/$pattern_stream_start/ ){
      $stream = 1;
    }

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
