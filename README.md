## [Remove common PDF watermarks](https://github.com/warren-bank/remove-common-pdf-watermarks)

### Branches

> Each branch is a variation of the script, customized to remove a particular common PDF watermark.

* ["pdf-xchange-editor"](https://github.com/warren-bank/remove-common-pdf-watermarks/tree/pdf-xchange-editor)
  * generic methodology
    * removes all objects with an element containing the labels: `/Private /Watermark`
  * supports the command-line option: `--unzip`
    * filters are also applied to the zlib compressed data within "FlateDecode" streams
* ["www.finebook.ir"](https://github.com/warren-bank/remove-common-pdf-watermarks/tree/finebook.ir)
* ["www.it-ebooks.info"](https://github.com/warren-bank/remove-common-pdf-watermarks/tree/it-ebooks)
* ["www.wowebook.org"](https://github.com/warren-bank/remove-common-pdf-watermarks/tree/wowebook)
* ["www.wowebook.org"](https://github.com/warren-bank/remove-common-pdf-watermarks/tree/wowebook-compressed) with zlib compressed data within "FlateDecode" streams
* ["www.allitebooks.com"](https://github.com/warren-bank/remove-common-pdf-watermarks/tree/allitebooks-compressed) with zlib compressed data within "FlateDecode" streams
* ["OceanofPDF.com"](https://github.com/warren-bank/remove-common-pdf-watermarks/tree/oceanofpdf-compressed) with zlib compressed data within "FlateDecode" streams

### Notes

* These are perl scripts.
* To run: `perl filter.pl`
* These implementations don't accept any command-line options.
  They assume that:
  * the input file is: `./in.pdf`
  * the output file is: `./out.pdf`

### Additional Notes

* After running a PDF file through the appropriate perl script:
  * a PDF viewer (ex: [_"PDF-XChange Viewer"_](http://portableapps.com/apps/office/pdf-xchange-portable)) should report that:

    ```
    This document "out.pdf" has errors.

    Some problems were detected by application:
    - One or more XREF chunks were not found.

    It is recommended you re-save this document.
    ```
* After following the recommendation given by the viewer and resaving the PDF document (ie: `File > Save As..`):
  * all of the PDF's internal references to the removed `obj` blocks are cleaned out
  * the file size is farther reduce by a significant amount
  * the file won't generate any errors when opened in a PDF viewer

### Legal

* Copyright: [Warren Bank](https://github.com/warren-bank)
* License: [GPL-2.0](http://www.gnu.org/licenses/gpl-2.0.txt)
