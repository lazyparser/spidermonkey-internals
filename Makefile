book: preface.md FAQ.md authors.md 00.Intro.md  01.HandsOn.md  02.GatheringData.md  03.DiveIntoCode.md OpenProjects.md res.md
	pandoc preface.md authors.md 00.Intro.md  01.HandsOn.md  02.GatheringData.md  03.DiveIntoCode.md FAQ.md OpenProjects.md res.md \
	-o book.pdf \
	--toc \
	--latex-engine=xelatex \
	-V mainfont="WenQuanYi Micro Hei"

README: README.md
	pandoc README.md -o README.pdf --latex-engine=xelatex -V mainfont="WenQuanYi Micro Hei"

