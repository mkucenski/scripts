https://github.com/tesseract-ocr/tesseract/wiki/FAQ

Can I increase speed of OCR?

If you are processing several images, you can run tesseract in parallel with GNU Parallel. E.g. instead of:

find . -maxdepth 1 -name "*.tif" -print0 | while IFS= read -r -d '' n; do 
    tesseract "$n" "$n" -l eng hocr
	     hocr2pdf -i "$n" -n -o "$n.pdf" < "$n.html"
done 
you can run:

parallel "tesseract {} {} -l eng hocr; hocr2pdf -i {} -n -o {}.pdf < {}.html" ::: *.tif
