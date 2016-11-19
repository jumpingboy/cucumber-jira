module Jira

  def load_routes
    load_secret_variables
    @jira_base_url = @secret_config['JIRA_URL']
    @jira_login_url = @jira_base_url + '/login'
  end

  def load_secret_variables
    @project_root = File.expand_path('../../..', __dir__)
    @secret_config = YAML.load_file(@project_root + '/features/support/secret_config.yml')
  rescue
    puts 'No Titan secret credentials loaded'
  end

  def login
    visit @jira_login_url
    find('#username')
    find('#username').click
    find('#username').send_keys :home, @secret_config['JIRA_USERNAME']
    find('#password')
    find('#password').click
    find('#password').send_keys :home, @secret_config['JIRA_PASSWORD']
    find('#login').click
  end

  def view_tickets
    find('#find_link')
    find('#find_link').click
    filter = @secret_config['JIRA_FILTER']
    find("a[title='#{filter}'")
    find("a[title='#{filter}'").click
  end

  def scrape_all_data
    @tickets = []
    total_tickets = find('.showing').text.sub(/(.* of )/, '').to_i 
    for i in 0...1#total_tickets
      scrape_ticket_data
      click_when_loaded('.icon-page-next')
      until @compare != find('#key-val').text
      end
    end  
  end

  def export_data 

  end

  def click_when_loaded(selector)
    wait_for_selector(selector)
    find(selector).click
  end

  def all_when_loaded(selector)
    wait_for_selector(selector)
    all(selector)
  end

  def wait_for_selector(selector)
    expect(page).to have_selector(selector)
  end

  def scrape_ticket_data
    ticket = Hash.new
    ticket["title"] = find('#summary-val').text
    ticket["number"] = find('#key-val').text
    @compare = ticket["number"]
    ticket["link"] = first('.issue-link')[:href]

    click_when_loaded('#changehistory-tabpanel')
    ticket["created"] = first('.livestamp')[:datetime]

    find('#transitions-summary-tabpanel').click
    using_wait_time 1 do
      begin
        if has_selector?('th', text: 'Transition')
          @has_transitions = true
        elsif has_selector?('.message-container', text: /no workflow transitions/i)
          @has_transitions = false
        else
          raise "Sumting wong"
        end
      end
    end
    transitions = Hash.new
    if @has_transitions
      all_when_loaded('.issue-data-block').each do |transition_row|
        transitions["started"] = transition_row.find('.action-details').find('.livestamp')[:datetime]
        transitions["starting_status"] = transition_row.all('.jira-issue-status-lozenge')[0].text
        transitions["new_status"] = transition_row.all('.jira-issue-status-lozenge')[1].text
        transitions["time_in_starting_status"] = transition_row.find('.changehistory > table > tbody > tr > td:nth-of-type(2)').text
      end
    end
    ticket["transitions"] = transitions
    puts ticket["number"]
    @tickets << ticket
  end
end