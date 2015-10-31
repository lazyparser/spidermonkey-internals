book: preface.md toc.md FAQ.md authors.md 01.HandsOn.md OpenProjects.md
	pandoc preface.md authors.md toc.md 01.HandsOn.md FAQ.md OpenProjects.md \
	-o book.pdf \
	--latex-engine=xelatex \
	-V mainfont="WenQuanYi Micro Hei"

README: README.md
	pandoc README.md -o README.pdf --latex-engine=xelatex -V mainfont="WenQuanYi Micro Hei"

