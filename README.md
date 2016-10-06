## [Remove common PDF watermarks](https://github.com/warren-bank/remove-common-pdf-watermarks)

### Branches

> Each branch is a variation of the script, customized to remove a particular common PDF watermark.

* ["www.it-ebooks.info"](https://github.com/warren-bank/remove-common-pdf-watermarks/tree/it-ebooks)
* ["www.wowebook.org"](https://github.com/warren-bank/remove-common-pdf-watermarks/tree/wowebook)
  * [decrypted/decompressed (with `qpdf`)](https://github.com/warren-bank/remove-common-pdf-watermarks/tree/wowebook-decrypted-decompressed)

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

### License

> [GPLv2](http://www.gnu.org/licenses/gpl-2.0.txt)

> Copyright (c) 2016, Warren Bank
