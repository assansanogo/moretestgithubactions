# moretestgithubactions


📈 RStudio Cloud (workspace):
[workspace-RStudio Cloud](https://rstudio.cloud/project/3906034)


🖥️ In this repository :
The code belonging to the developped R package:
* under the `R` folder

The scripts called by the Docker container:
* under `Rscript` folder

The Github actions workflows:

[![JH AutoStreamliner](https://github.com/assansanogo/moretestgithubactions/actions/workflows/JH_auto_streamline.yml/badge.svg)](https://github.com/assansanogo/moretestgithubactions/actions/workflows/JH_auto_streamline.yml)

[![JH Custom Streamline](https://github.com/assansanogo/moretestgithubactions/actions/workflows/JH_custom_streamline.yml/badge.svg)](https://github.com/assansanogo/moretestgithubactions/actions/workflows/JH_custom_streamline.yml)

[![JH timed Streamline](https://github.com/assansanogo/moretestgithubactions/actions/workflows/JH_timed_streamline.yml/badge.svg)](https://github.com/assansanogo/moretestgithubactions/actions/workflows/JH_timed_streamline.yml)

* under `.github`

* There are 3 workflows *(match slightly different use-cases)*
  * JH_timed_streamline.yml *(daily runner - cron job)*
  * JH_auto_streamline.yml  *(current day  - manual trigger)*
  * JH_custom_streamline.yml *(finer-grain customisation - manual trigger)*
    - Params:
     - date (before which the results are queried
     - aggregation (there are 2 url : one with already aggregated data and the other without) (not extensively tested)
     - country (country for which you which to filter)  (currently limited to US)
     - dest email (the recipient email) # only works with gmail
   * the last workflow is to check the functionality of Github scheduled workflow (debug)

* in the root folder you will find streamliner.py
 - attempt to use R for data wrangling and python to interact with APIS and other services (here: SendGrid). 

At tehend of each run, you can download the `consolidated report` (which include previous runs)

# 1. Challenges

I designed the solution with a stack of tools which are the closest to Streamline stack.<br>
(in contrast to my current mastered stack: Python, AWS). 
I added some points like automatic mail sendout.
It allowed me to identify differences in support for such a feature. AWS **natively** supports it when GCP **does not.**

The challenges (in decreasing priority):

- unfamiliarity with R and package building  (needs further training if onboarded)
- unfamiliarity with GCP (need further training if onboarded)
- github actions/workflow
  * the cron job seems not to be 100% reliable: :point_right: [url](https://github.community/t/no-assurance-on-scheduled-jobs/133753)


Nevertheless, the solution has been designed with the focus on the 4 points below:

### :toolbox: Target tools:
* stack:
 - GCP
 - R
 - GitHub actions

### :lock: Security:
* Good practices:
 - Github secrets
 - Federated authentication
 - multi steps Docker image

### :rocket: Automation/Customization:
* 3 variants of the same Workflow 
  - daily report (auto)
  - manual trigger
  - custom report (anyday)
 
* Auto email (only tested with gmail)

### :cloud: Reliability/Durability:
* Google cloud storage (upload after each run - to circumvent handling GitHub artifact lifetime/lifecycle)
:point_right: [url](https://storage.googleapis.com/streamliner-john-hopkins/admin/JH_GCP.png)

# 2. Improvements:


* extensive testing (code logic)
  - spelling/mispellings
  - unit testing
  - filter outliers

* package testing
  - unit testing for the workflow
  - functional testing

* refactoring
  - better errors handling + logging
  - have one subfolder in the repository (with main/branch etc.) 
    to develop with best practices
  - use the workflow to manage branches (need further training)
  
* add logs (even though the logging is done in GitHub actions)

# 3. Further cleaning

* Define an official list all countries - territories (already done for the US by itterating over all values of states
* The format of the data has changed (early 2020 vs current) `Admin2` is absent from some tables
* define a policy for handling unconventional data (Princess, Recovered, NA, Unknown, etc.)
* Define the *level* of averaging: data has `counties` and `burrows`
  - match data with a list of identified counties (In progress) 
