FROM texlive/texlive:latest

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y tzdata
RUN apt-get install -y file libcurl4-openssl-dev libxml2-dev libssl-dev libfontconfig1-dev
RUN apt-get install -y pandoc pandoc-citeproc r-base r-cran-systemfonts

WORKDIR /Rinit
COPY Rpackages.txt .

RUN Rscript -e 'install.packages(readLines("Rpackages.txt"))'

COPY server-deb.url .
RUN apt-get install -y gdebi-core
RUN wget `cat server-deb.url`
RUN gdebi `cat server-deb.url | sed -n -e 's/.*\/\(rstudio.*deb\).*/\1/gp'`

RUN useradd -ms /bin/bash rmalapan
USER rmalapan
WORKDIR /home/rmalapan

