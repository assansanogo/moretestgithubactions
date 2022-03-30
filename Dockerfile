# multi stage build
# for copyright reasons - the package is not distributed with the docker image
# first small footprint image creation with cloned repository
# copy necessary files from small intermediate image to run

FROM alpine:3.14  as streaml1
RUN apk update && apk add git && git clone https://github.com/assansanogo/moretestgithubactions.git

FROM rocker/tidyverse:latest as streaml2
WORKDIR /app

# (R script file)
COPY --from=streaml1 /moretestgithubactions/Rscripts/*.r /app/

# (Entrypoint shell file)
COPY --from=streaml1 /moretestgithubactions/Rscripts/*.sh /app/

# Install R packages (official packages)
RUN install2.r --error testthat

# Install R packages (devtools packages)
RUN mkdir ./temp && mkdir ./out && Rscript --vanilla requirements.r && chmod a+x *.sh

# Execute summarizing script
ENTRYPOINT ./main.sh 
