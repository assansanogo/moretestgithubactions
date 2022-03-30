FROM alpine:3.14  as streaml1
RUN apk update && apk add git && git clone https://github.com/assansanogo/moretestgithubactions.git

FROM rocker/tidyverse:latest as streaml2
WORKDIR /app
COPY --from=streaml1 /moretestgithubactions/Rscripts/*.r /app/
COPY --from=streaml1 /moretestgithubactions/dockeractions/entrypoint.sh ./entrypoint.sh

# Install R packages (official packages)
RUN install2.r --error testthat

# Install R packages (devtools packages)
RUN mkdir ./temp && mkdir ./out && Rscript --vanilla requirements.r && chmod a+x *.sh

# Execute summarizing script
ENTRYPOINT ./entrypoint.sh 
