When(/^Do it$/) do
  load_routes
  load_secret_variables
  login
  view_tickets
  scrape_all_data
  export_to(@project_root + '/html/jira-gantt.html')
end