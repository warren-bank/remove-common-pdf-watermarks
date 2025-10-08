#!/usr/bin/perl

$/ = "\n";
$\ = "";
$, = "";

open(FH_IN,  "<in.pdf");
open(FH_OUT, ">out.pdf");
binmode(FH_IN);
binmode(FH_OUT);

my $pattern_obj_start = qr/^\d+\s+\d+\s+obj/;
my $pattern_obj_end   = qr/endobj\b/;

my $pattern_stream_start = qr/^stream$/;
my $pattern_stream_end   = qr/^endstream$/;

my $pattern_text_start = qr/^BT$/;
my $pattern_text_end   = qr/^ET$/;

my $obj_buffer         = '';
my $obj_filter_pattern = qr/\(https?:\/\/oceanofpdf\.com\/\)/;

my $inspect_stream     = 0;
my $inspect_text       = 0;
my $stream_buffer_pre  = '';
my $stream_sandbox     = '';
my $stream_buffer_post = '';

# the idea is:
#   foreach obj that contains a matching URL {
#     1. remove obj
#     2. process next obj
#        - if it contains a stream with text blocks,
#          then remove the last text block in this stream
#   }

while (my $line = <FH_IN>) {
  if ($obj_buffer) {

    if ($inspect_stream) {

      if ($stream_buffer_pre) {
        if ($line =~ m/$pattern_stream_end/) {
          $obj_buffer = $obj_buffer . $stream_buffer_pre;
          $obj_buffer = $obj_buffer . $stream_buffer_post;
          $obj_buffer = $obj_buffer . $line;

          $inspect_stream     = 0;
          $inspect_text       = 0;
          $stream_buffer_pre  = '';
          $stream_sandbox     = '';
          $stream_buffer_post = '';
        }
        elsif ($line =~ m/$pattern_text_start/) {
          if ($stream_sandbox) {
            $stream_buffer_pre = $stream_buffer_pre . $stream_sandbox;
          }
          if ($stream_buffer_post) {
            $stream_buffer_pre = $stream_buffer_pre . $stream_buffer_post;
          }
          $stream_sandbox = $line;
          $stream_buffer_post = '';
          $inspect_text = 1;
        }
        elsif ($line =~ m/$pattern_text_end/) {
          $stream_sandbox = $stream_sandbox . $line;
          $inspect_text = 0;
        }
        elsif ($inspect_text) {
          $stream_sandbox = $stream_sandbox . $line;
        }
        else {
          $stream_buffer_post = $stream_buffer_post . $line;
        }
      }
      elsif ( $line =~ m/$pattern_stream_start/ ) {
        $stream_buffer_pre = $line;
      }
      else {
        $obj_buffer = $obj_buffer . $line;
      }

    }
    else {
      $obj_buffer = $obj_buffer . $line;

      if ($line =~ m/$pattern_obj_end/) {
        if ( $obj_buffer =~ m/$obj_filter_pattern/ ) {
          $obj_buffer = '';
          $inspect_stream = 1;
        }
        else {
          print FH_OUT $obj_buffer;
          $obj_buffer = '';
        }
      }
    }
  }
  elsif ( $line =~ m/$pattern_obj_start/ ) {
    $obj_buffer = $line;
  }
  else {
    print FH_OUT $line;
  }
}

if ($obj_buffer) {
  if ($stream_buffer_pre) {
    $obj_buffer = $obj_buffer . $stream_buffer_pre;
    $obj_buffer = $obj_buffer . $stream_buffer_post;

    $stream_buffer_pre  = '';
    $stream_sandbox     = '';
    $stream_buffer_post = '';
  }
  print FH_OUT $obj_buffer;
  $obj_buffer = '';
}

close (FH_IN);
close (FH_OUT);
