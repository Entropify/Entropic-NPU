import glob, os, zipfile

print("--- .docx (upload to Google Drive, then Open with Google Docs) ---")
for f in sorted(glob.glob("*.docx")):
    x = zipfile.ZipFile(f).read("word/document.xml")
    hd = x.count(b'w:val="Heading')
    print("%-30s %7.1f KiB   real tables=%2d   headings=%2d"
          % (f, os.path.getsize(f) / 1024, x.count(b"<w:tbl>"), hd))

print("\n--- .html (open in browser, Ctrl+A, Ctrl+C, paste into Docs) ---")
for f in sorted(glob.glob("*.html")):
    h = open(f, encoding="utf-8").read()
    print("%-30s %7.1f KiB   <table>=%2d   <pre>=%2d   literal '| ' rows=%d"
          % (f, os.path.getsize(f) / 1024, h.count("<table>"), h.count("<pre>"), h.count("| ")))

print("\n--- .md (source of truth; also pasteable via Docs' own markdown paste) ---")
for f in sorted(glob.glob("*.md")):
    n = open(f, encoding="utf-8").read()
    print("%-30s %7.1f KiB   lines=%4d   words=%5d"
          % (f, os.path.getsize(f) / 1024, n.count("\n") + 1, len(n.split())))
