FROM texlive/texlive:latest

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y tzdata gdebi-core
RUN apt-get install -y file libcurl4-openssl-dev libxml2-dev libssl-dev libfontconfig1-dev
RUN apt-get install -y pandoc r-base r-cran-systemfonts

RUN ARCH=$(dpkg --print-architecture) && echo $ARCH >/tmp/arch.txt
RUN curl -LO https://quarto.org/download/latest/quarto-linux-$(cat /tmp/arch.txt).deb && \
    gdebi --non-interactive quarto-linux-$(cat /tmp/arch.txt).deb && \
    rm quarto-linux-$(cat /tmp/arch.txt).deb

RUN quarto check

WORKDIR /Rinit
COPY Rpackages.txt .

RUN Rscript -e 'install.packages(readLines("Rpackages.txt"))'

RUN useradd -ms /bin/bash rmalapan
USER rmalapan
WORKDIR /home/rmalapan

CMD ["bash"]
# CMD cat /tmp/arch.txt

