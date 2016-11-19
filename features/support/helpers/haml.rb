module Jira

  def export_to(file)
    template_file = @project_root + '/features/support/template.haml'
    engine = Haml::Engine.new(IO.read(template_file))
    File.open(file, "w+") do |f|
      f.write(engine.render)
    end
  end

end