#!/bin/bash

# load external scripts and packages into the notebook environment via the notebooks volume mount.

PACKAGE_DIR="/usr/src/notebooks/packages"

wget -O "${PACKAGE_DIR}/pdf-parser.py" \
    https://raw.githubusercontent.com/DidierStevens/DidierStevensSuite/master/pdf-parser.py
wget -O "${PACKAGE_DIR}/pdfid.py" \
    https://raw.githubusercontent.com/DidierStevens/DidierStevensSuite/master/pdfid.py
wget -O "${PACKAGE_DIR}/pymupdf-extract.py" \
    https://raw.githubusercontent.com/pymupdf/PyMuPDF-Utilities/master/examples/extract-imgb.py
