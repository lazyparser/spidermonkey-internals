book: preface.md toc.md FAQ.md Author.md
	pandoc preface.md Author.md toc.md FAQ.md \
	-o book.pdf \
	--latex-engine=xelatex \
	-V mainfont="WenQuanYi Micro Hei"

README: README.md
	pandoc README.md -o README.pdf --latex-engine=xelatex -V mainfont="WenQuanYi Micro Hei"

