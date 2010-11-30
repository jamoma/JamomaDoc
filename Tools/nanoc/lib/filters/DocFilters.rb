class RefLinksFilter < Nanoc3::Filter
identifier :addref

  def run(content, params={})
    content.gsub(/(\s)(jcom.\w+)/,' "(jcom)\2":./components/\2.html')
    content.gsub(/(\s)(jmod.+)(\s)/,' "(jcom)\2":./components/\2.html ') # TODO make the regexp more error proof (i.e modules with dot in name)
  end
end
