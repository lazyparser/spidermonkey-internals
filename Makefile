book: preface.md toc.md
	pandoc preface.md toc.md \
	-o book.pdf \
	--latex-engine=xelatex \
	-V mainfont="WenQuanYi Micro Hei"

README: README.md
	pandoc README.md -o README.pdf --latex-engine=xelatex -V mainfont="WenQuanYi Micro Hei"

