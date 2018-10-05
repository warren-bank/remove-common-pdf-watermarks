#!/usr/bin/env perl

$/ = "\n";
$\ = "";
$, = "";

open(FH_IN,  "<in.pdf");
open(FH_OUT, ">out.pdf");
binmode(FH_IN);
binmode(FH_OUT);

my $buffer              = '';
my $pattern_start       = qr/^\d+\s+\d+\s+obj/;
my $pattern_end         = qr/endobj\b/;
my $pattern_filter      = qr/(?:\/Private\s+\/Watermark|[Pp]df-[Xx]change)/;

my $try_to_decompress   = ($ARGV[0] eq '--unzip') ? 1 : 0;
my $can_decompress      = 0;
my $pattern_compressed;

if ($try_to_decompress) {
  eval "use zlib;";
  $can_decompress       = ($@) ? 0 : 1;

  if ($can_decompress) {
    $pattern_compressed = qr/\/FlateDecode[\w\W]*>>[\w\W]*stream[\r\n]*([\w\W]*?)[\r\n]*endstream/;
  }
  else {
    print 'WARNING: --unzip is not supported' . "\n" . 'perl module not found: "Compress::Raw::Zlib"' . "\n\n";
  }
}

my $debug = 0;
my $data;

while (my $line = <FH_IN>) {
  if ($buffer){
    $buffer = $buffer . $line;

    if ($line =~ m/$pattern_end/){

      if ($can_decompress && $buffer =~ m/$pattern_compressed/) {
        $data  = $1;
        $data  = zlib::decompress(\$data);  # pass data by reference

        if ( $data =~ m/$pattern_filter/ ){
          $buffer  = '';
        }

        if ($debug) {
          $buffer = '-'x40 . '<data>' . "\n" . ($buffer ? $data : 'matching pattern removed') . "\n" . '-'x40 . '</data>' . "\n";
        }

      }

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
