addjs2pdf.exe -runatopen js-runat-open.txt -runatclose js-runat-close.txt -runbfprint js-runat-before-printing.txt -runafprint js-runat-after-printing.txt -runbfsave js-runat-before-saving.txt -runafsave js-runat-after-saving.txt help.pdf _help_js_embeded.pdf

addjs2pdf.exe -runatopen js-full.txt help.pdf _help_full_js.pdf

addjs2pdf.exe -runatopen js-runat-open-printing-remove-watermark.txt -runbfprint js-runat-before-printing-add-watermark.txt -runafprint js-runat-after-printing-remove-watermark.txt help.pdf _print-with-watermark.pdf

addjs2pdf.exe -runatopen js-runat-open-watermark.txt help.pdf _show-with-watermark.pdf

pause

