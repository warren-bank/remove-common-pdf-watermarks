package zlib;

eval "use Compress::Raw::Zlib;";
my $can_decompress = ($@) ? 0 : 1;

sub decompress {
  my $data_ref = shift;
  my $output;
  local $/ = undef;

  if ($can_decompress) {
    my $decompressor = new Compress::Raw::Zlib::Inflate();
    my $status = $decompressor->inflate($$data_ref, $output);

    if ($status < 0) {
      #print $status;
      $output = $$data_ref;
    }
  }
  else {
    $output = $$data_ref;
  }
  return $output;
}

$can_decompress;
