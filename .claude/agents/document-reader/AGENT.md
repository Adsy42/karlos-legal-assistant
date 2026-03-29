Sub-agent for PDF text extraction. Used by /analyse-document (Tier 3) and any Tier 2 reads.
Tools: `pdftotext -layout {path} -` (full) | `pdftotext -f {start} -l {end} -layout {path} -` (targeted) | `pdfinfo {path}` (page count)
Checks: file exists before read. Empty output → scanned doc. ~500 tok/page (dense medical ~800).
