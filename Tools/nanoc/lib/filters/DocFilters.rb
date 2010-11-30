class RefLinksFilter < Nanoc3::Filter
identifier :addref

  def run(content, params={})
    content.gsub(/(\s)(jcom.\w+)/,' "(jcom)\2":./components/\2.html')
    content.gsub(/(\s)(jmod.[\w|\.]+)/,' "(jcom)\2":./components/\2.html')
  end
end

class PreTextileFilter < Nanoc3::Filter
  identifier :pretextile
# TODO turn these rules in a class extenting Redcloth -> should be usable in non-nanoc generated html
  def run(content, params={})
    content.gsub(/(\()(\d+)(\))/,'\1<span class="figurePointer">\2</span>\3')
  end
end