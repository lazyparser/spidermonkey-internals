book: preface.md FAQ.md authors.md 01.HandsOn.md OpenProjects.md res.md
	pandoc preface.md authors.md 01.HandsOn.md FAQ.md OpenProjects.md res.md \
	-o book.pdf \
	--toc \
	--latex-engine=xelatex \
	-V mainfont="WenQuanYi Micro Hei"

README: README.md
	pandoc README.md -o README.pdf --latex-engine=xelatex -V mainfont="WenQuanYi Micro Hei"

