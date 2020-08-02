FROM healthvision/chart2

MAINTAINER Bertil Nestorius Baron  "bertil.baron@healthvision.de"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libxml2-dev
# copy the app to the image
RUN apt-get update && apt-get install -y libudunits2-dev \
   libgdal-dev
RUN R -e "install.packages(c('DT','shinythemes', 'rgdal','leaflet','shinydashboard','shinyjs', 'sf', 'rjson'))"
RUN mkdir /root/leykam

COPY ./ /root/leykam
WORKDIR /root/
RUN R CMD build leykam
RUN R CMD INSTALL leykam_*

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/leykam', port = 3838, host= '0.0.0.0')"]
