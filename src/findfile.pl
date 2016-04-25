#   findfile.pl     Finds a file on a path symbol; returns full filename
#                   or an empty string if the file was not found.
#
#   Written:    97/05/01   Pieter Hintjens <ph@imatix.com>
#   Revised:    97/05/02   Pieter Hintjens <ph@imatix.com>
#
#   $name = &findfile (filename, path_symbol);
#
#   e.g.    $filename = &findfile ("myfile.c", "PATH");
#

sub findfile {
    local ($filename, $path) = @_;
    local (@path_table);

    #   Split path differently on MS-DOS and UNIX (ugh!)
    @path_table = split (defined ($ENV {"COMSPEC"})? ";": ":", $ENV {$path});

    #   If file has absolute path, or exists locally, that's fine for us
    return $filename if -f $filename;
    foreach (@path_table) {
        return "$_/$filename" if -f "$_/$filename";
    }
    return "";
}

1;
