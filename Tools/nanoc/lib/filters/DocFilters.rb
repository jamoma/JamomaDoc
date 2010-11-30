class RefLinksFilter < Nanoc3::Filter
identifier :addref

  def run(content, params={})
    content.gsub(/(\s)(jcom.\w+)/,' "(jcom)\2":./components/\2.html')
    content.gsub(/(\s)(jmod.[\w|\.]+)/,' "(jcom)\2":./components/\2.html')
  end
end

class PreTextileFilter < Nanoc3::Filter
  identifier :pretextile
  
  def run(content, params={})
  end
end