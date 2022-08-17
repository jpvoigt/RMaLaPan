FROM texlive/texlive:latest

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y tzdata
RUN apt-get install -y file libcurl4-openssl-dev libxml2-dev libssl-dev libfontconfig1-dev
RUN apt-get install -y pandoc pandoc-citeproc r-base r-cran-systemfonts

WORKDIR /Rinit
COPY Rpackages.txt .

RUN Rscript -e 'install.packages(readLines("Rpackages.txt"))'

RUN useradd -ms /bin/bash rmalapan
USER rmalapan
WORKDIR /home/rmalapan

CMD ["R"]
