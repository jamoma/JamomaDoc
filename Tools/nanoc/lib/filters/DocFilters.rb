class RefLinksFilter < Nanoc3::Filter
identifier :addref

  def run(content, params={})
    content.gsub(/(\s)(jcom.\w+)/,' "(jcom)\2":./components/\2.html')
    content.gsub(/(\s)(jmod.[\w|\.]+)/,' "(jcom)\2":./modules/\2.html')
  end
end

class PreTextileFilter < Nanoc3::Filter
  identifier :pretextile
# TODO turn these rules in a class extenting Redcloth -> should be more easily usable in non-nanoc generated html
  def run(content, params={})
    content.gsub(/(\()(\d+)(\))/,'\1<span class="figurePointer">\2</span>\3')
    content.gsub(/(!)(\S+)(!)/,'<div class="imageZoom"><a href="\2" class="image" target="_blank" rel="lightbox[modular]"><img src="\2"></a></div>')
  end
end

# class ZoomboxFilter < Nanoc3::Filter
# identifier :zoomify
#   def run(content, params={})
#     nil
#     # content.gsub(/(!)(\S+)(!)/,'<div class="imageZoom"><a href="\2" class="image" target="_blank" rel="lightbox[modular]"><img src="\2"></a></div>')
#   end
# end
