# HTMLPP

HTMLPP is a HTML pre-processor which translates a marked up text file
into one or more HTML files (typically one file per section).  It was
used to generate much of the documentaton for early iMatix Corporation 
open source releases.

HTMLPP was originally released in 1996, and updated throughout 1998.
It was later incorporated into other iMatix Corporation products, but
eventually was replaced by other documentation tools.  HTMLPP was 
written in Perl (Perl 4, to be precise; it appears not to run as-is
under modern Perl 5).

At this point HTMLPP is only of historic interest; there are much better
open source tools for generating documentation, including those based on
Markdown and XML.

This repository contains the last HTMLPP source, binaries,and documentation
released in a stand alone version, retrieved from:

*  http://legacy.imatix.com/pub/tools/htmlp*

*  http://legacy.imatix.com/html/htmlpp

on 2016-04-25.

For more information see the [HTMLPP
Documentation](https://imatix-legacy.github.io/htmlpp/).

Originally the source code was licensed under the GPL v2, a copy of which can
be found in `src/copying`. (`src/copying` was not included in the 
original archive, only incorporated by reference, but a copy of the GPL
v2 is included for completeness.)

On [2016-04-29 it was also released under the
MPLv2](https://github.com/imatix-legacy/license) ([license
text](https://www.mozilla.org/en-US/MPL/2.0/)), so `htmlpp` can
be used under either GPLv2 or MPLv2.

The *source* of the *documentation* is in `src/htmlpp.txt`.

## `pub`

The `pub` directory contains the released artefacts which are still 
retrievable.  Due to their small size (about 100KB each), and the fact 
that development ceased many years ago (so there will not be growth 
in the archive), these are added directly into the git repository.

## `src`

The `src` directory was created from the unpacked contents of
`pub/htmlp42a.tgz`, for ease of reference.

The code is licensed under the GPL v2, a copy of which can be found
in `src/copying`. (`src/copying` was not included in the original
archive, only incorporated by reference, but a copy of the GPL v2
is included for completeness.)

## `website`

The `website` directory contains the *rendered* documentation, ie
produced by running `htmlpp` on `htmlpp.txt`.  (`src/htmlpp.txt` being
the source of the documentation.)
