# moretestgithubactions

# 1. Challenges

- unfamiliarity with GCP (need further training)
- unfamiliarity with R  (need further training)
- github actions/workflow

The solution has been designed with the focus on the 4 points :

### Target tools:
* GCP
* R
* GitHub actions

### Security:
* Github secrets
* Federated authentication
* multi steps Docker image

### Automation:
* 3 variants of the same Workflow (daily report, custom report (anyday) and manual trigger)
* Auto email (work only with gmail)

### Reliability:
* GCP (upload after each run - to circumvent handling GitHub artifact lifetime/lifecycle)

# 2. Improvements:

* extensive testing (with US and other countries)
  - package testing
  - unit testing for the workflow
  - functional testing
* add logs (even though the logging is done in GitHub actions)

# 3. Further cleaning
* Define an official list all countries - territories 
* data has counties and burrows
  - match data with a list of identified counties (In progress) 
* define a policy for handling unconventional data (Princess, Recovered, NA)
