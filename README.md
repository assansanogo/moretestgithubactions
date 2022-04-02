# moretestgithubactions


In this repository  you will find the code for the R package
under the `R` folder
the scripts called by the Docker image under `Rscript` folder


# 1. Challenges

I designed the solutions with a stack of tools which are the closest to Streamline stack.<br>
(in contrast to my current mastered stack: Python, AWS)

The challenges (in decreasing priority):

- unfamiliarity with R  (need further training)
- unfamiliarity with GCP (need further training)
- github actions/workflow

The solution has been designed with the focus on the 4 points :

### :toolbox: Target tools:
* GCP
* R
* GitHub actions

### :lock: Security:
* Github secrets
* Federated authentication
* multi steps Docker image

### :rocket: Automation/Customization:
* 3 variants of the same Workflow 
  - daily report (auto)
  - manual trigger
  - custom report (anyday)
 
* Auto email (only tested with gmail)

### :cloud: Reliability/Durability:
* Google cloud storage (upload after each run - to circumvent handling GitHub artifact lifetime/lifecycle)

# 2. Improvements:

* extensive testing (code logic)
  - spelling
  - units
  - outliers

 * package testing
  - unit testing for the workflow
  - functional testing
  
* add logs (even though the logging is done in GitHub actions)

# 3. Further cleaning

* Define an official list all countries - territories (already done for the US by itterating over all values of states
* the format of the data has changed (early 2020 vs current)
* define a policy for handling unconventional data (Princess, Recovered, NA, Unknown, etc.)
* data has counties and burrows
  - match data with a list of identified counties (In progress) 
