Abandoned project intended to view Jira tickets and the amount of time they spent in given statuses (in order to highlight abnormal tickets that either took too long or went back and forth between statuses too often or both etc., with the ultimate goal of having a team conversation about those tickets at a retro)

# View Jira ticket transitions data

## Setup
Same as cucumber-titan

Create a file called secret_config.yml at the same level as the secret_config.yml-example and fill it in

Save a search in Jira as a Filter of the tickets you want to scrape

Run `cucumber` in your terminal
