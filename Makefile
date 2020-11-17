build:
	docker build -t docker2021ml .

run:
	docker run -d --rm -v $(pwd):/home/rstudio/persistent-folder -e PASSWORD=docker2021ml -p 8787:8787 docker2021ml
