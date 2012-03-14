#!/usr/bin/ruby -wKU
require 'yaml'


class YamlToMaxDoc
  require 'rexml/document'
  require 'rexml/formatters/pretty'
  include REXML

  attr :xml, true

  def initialize
    @xml = Document.new
  end


  def makeRefpage filepath
    imagepath = filepath.sub(/(.*jcom.*)\.maxref.yml/, '\1.maxref.png')
    yaml = YAML.load_file(filepath)
    categoryStr  = String.new # adding Jamoma subproject (e.g., DSP) as default cateory ?
    tags = yaml["tags"] # we use the tags info to create the category attribute
    if tags
      tags.each { |tag|
        categoryStr = categoryStr + ", " + tag
      }
      categoryStr[0..1] = '' # removing the first ', ' fom list
    end

    root = Element.new("c74object")
    root.attributes["name"] = filepath.split('/').last.sub(/\.maxref.yml/,'')
    root.attributes["module"] = "Jamoma"
    root.attributes["category"] = categoryStr

    #comment = Comment.new('DIGEST')
    #root.add comment
    e = Element.new("digest")
    e.text = yaml["brief"]
    root.add_element e
    comment = Comment.new('DESCRIPTION')
    root.add comment
    e = Element.new("description")
    e.text = yaml["desc"]
    root.add_element e

    # METADATA ---------------------------------------------------------------------
    #comment = Comment.new('METADATA')
    #root.add comment
    e = Element.new("metadatalist")
    author = yaml["author"]
    if author
      author.each {|author|
      meta = Element.new("metadata")
      meta.attributes["name"] = "author"
      meta.text = author
      e.add_element meta
    }
    end

    tags = yaml["tags"]
    if tags
      tags.each { |tag|
        meta = Element.new("metadata")
        meta.attributes["name"] = "tag"
        meta.text = tag
        e.add_element meta
       }
    end

    root.add_element e
    # INLETS ---------------------------------------------------------------------
    comment = Comment.new('INLETS')
    root.add comment
    e = Element.new("inletlist")
    inlets = yaml["inlets"]
    if inlets
      inlets.each { |a|
        inlet = Element.new("inlet")
        inlet.attributes["id"] = a["id"]
        if (a["type"])
          inlet.attributes["type"] = a["type"]
        else
          inlet.attributes["type"] = "INLET_TYPE"
        end

        inletdig = Element.new("digest")
        inletdig.text = a["desc"]
        inlet.add_element inletdig

        inletdesc = Element.new("desc")
        inletdesc.text = a["desc"]
        inlet.add_element inletdesc

        e.add_element inlet
      }
    end

    root.add_element e
    # OUTLETS ---------------------------------------------------------------------
    comment = Comment.new('OUTLETS')
    root.add comment

    e = Element.new("outletlist")
    outlets = yaml["outlets"]
    if outlets
      outlets.each { |a|
        outlet = Element.new("outlet")
        outlet.attributes["id"] = a["id"]
        if (a["type"])
          outlet.attributes["type"] = a["type"]
        else
          outlet.attributes["type"] = "OUTLET_TYPE"
        end

        outletdig = Element.new("digest")
        outletdig.text = a["desc"]
        outlet.add_element outletdig

        outletdesc = Element.new("desc")
        outletdesc.text = a["desc"]
        outlet.add_element outletdesc

        e.add_element outlet
      }
    end

    root.add_element e

    # ATTRIBUTES ---------------------------------------------------------------------
    comment = Comment.new('ATTRIBUTES')
    root.add comment
    e = Element.new("attributelist")
    attributes = yaml["attributes"]
    if attributes
      attributes.each { |a|
        attribute = Element.new("attribute")
        attribute.attributes["name"] = a["name"]
        attribute.attributes["type"] = a["type"]
        if (a["size"])
          attribute.attributes["size"] = a["size"]
        else
          attribute.attributes["size"] = 1
        end
        attribute.attributes["get"] = 1
        attribute.attributes["set"] = 1

        attrdig = Element.new("digest")
        attrdig.text = a["desc"]
        attribute.add_element attrdig

        attrdesc = Element.new("description")
        attrdesc.text = a["desc"]
        attribute.add_element attrdesc

        e.add_element attribute
      }
    end

    root.add_element e


    # MESSAGES ---------------------------------------------------------------------
    comment = Comment.new('MESSAGES')
    root.add comment
    e = Element.new("methodlist")
    messages = yaml["messages"]
    if messages
      messages.each { |m|
        message = Element.new("method")
        message.attributes["name"] = m["name"]

        messagedig = Element.new("digest")
        messagedig.text = m["desc"]
        message.add_element messagedig

        messagedesc = Element.new("description")
        messagedesc.text = m["desc"]
        message.add_element messagedesc

        e.add_element message
      }
    end

    root.add_element e

    # ARGUMENTS ---------------------------------------------------------------------
    comment = Comment.new('ARGUMENTS')
    root.add comment
    e = Element.new("objarglist")
    args = yaml["args"]
    if args
      args.each { |a|
       arg = Element.new("objarg")
       arg.attributes["name"] = a["name"]
       arg.attributes["optional"] = a["optional"]
      arg.attributes["units"] = a["units"]
       arg.attributes["type"] = a["type"]

       argumentdig = Element.new("digest")
       argumentdig.text = a["desc"]
       arg.add_element argumentdig

       argumentdesc = Element.new("description")
       argumentdesc.text = a["desc"]
       arg.add_element argumentdesc

        e.add_element arg
      }
    end

    root.add_element e


    # IMAGE ---------------------------------------------------------------------
    comment = Comment.new('EXAMPLE')
    root.add comment
    if File.exist? "#{imagepath}"
      imagefilename = imagepath.sub(/.*(jcom.*.maxref.png)/,'\1')
      e = Element.new("examplelist")
      image = Element.new("example")
      image.attributes["img"] = imagefilename
      e.add_element image

      root.add_element e
    end


    # SEEALSO ---------------------------------------------------------------------
    comment = Comment.new('SEE ALSO')
    root.add comment
    e = Element.new("seealsolist")
    seealsos = yaml["seealso"]
    if seealsos
      seealsos.each { |s|
        seealso = Element.new("seealso")
        seealso.attributes["name"] = s
        e.add_element seealso
       }
    end

    root.add_element e

# DISCUSSION ---------------------------------------------------------------------
    e = Element.new("discussion")
    discussion = yaml["discussion"]
    if discussion
      e.text = yaml["discussion"]
    else
      e.text = ["_"]
    end
    root.add_element e

    # MISC ---------------------------------------------------------------------
    comment = Comment.new('MISC')
    root.add comment
    e = Element.new("misc")
    e.attributes["name"] = "Output"

    outputs = yaml["outputs"]
    if outputs
      outputs.each { |o|
        output = Element.new("entry")
        output.attributes["name"] = o["name"]

        outputdesc = Element.new("description")
        if (o["desc"].class == Array)
          ul = Element.new("ul")
          o["desc"].each { |item|
            li = Element.new("li")
            li.text = item
            ul.add_element li
          }
          outputdesc.add_element ul
        else
          outputdesc.text = o["desc"]
        end
        output.add_element outputdesc

        e.add_element output
       }
    end

    root.add_element e

    # FINISH UP ---------------------------------------------------------------------

    @xml.add_element root
  end

  def makeTuto filepath
    # TODO
  end

  def makeVignette filepath
    # TODO
  end

# this creates a file listing all refpages categories (Modular, Foundation, etc.)
  def moduleTOC(docModules)
    root = Element.new("root")

    docModules.each do |moduleName|
    m = Element.new("module")
    m.text = "Jamoma#{moduleName}"
    root.add_element m
    end
  @xml.add_element root

  end

  def refpagesTOC(jcomArray)
#    jcomArray.delete_if {|nonFolder| nonFolder =~ /^\./ || nonFolder =~ /images/} # we remove ".", ".." and "images" entries
    root = Element.new("root")
    jcomArray.each do |j|
      j = j.sub(/.*(jcom.*maxref).yml/,'\1.xml')
      r = Element.new("refpage")
      r.attributes["name"] = j
      root.add_element r
    end
    @xml.add_element root

  end

  def read filepath
    @xml = Document.new(File.open(filepath))
  end


  def write filepath
    f = File.new(filepath, "w")
    formatter = REXML::Formatters::Pretty.new
    s = ""

    @xml << XMLDecl.new("1.0", "UTF-8")

    formatter.write @xml, s
    #puts s

    # todo: investigate the formatters thing to have something cleaner than the following
    s.gsub!(/<\?.*\?>/, '<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<?xml-stylesheet href="./_jdoc_ref.xsl" type="text/xsl"?>')

    # Now that we have the XML, perform additional substitutions
    s.gsub!(/(\s\#)(\S*)/ , ' <o>\2</o>') # Max objects
    s.gsub!(/\s@(.*)@([\s\.])/, ' <m>\1</m>\2') # Max messages
    s.gsub!(/(\s)(jcom\S*)/, ' <jcom>\2</jcom>') #Jamoma objects
    s.gsub!(/(\s)(jmod\S*)/, ' <jmod>\2</jmod>') #Jamoma modules

    # todo Regexp should be non greedy ?
    # Textile related substitutions ≈ pseudo RedCloth
    s.gsub!(/\s_(\s*.*)_/, ' <i>\1</i>') # italic
    s.gsub!(/\s_(\s*.*)_/, ' <b>\1</b>') # bold
    s.gsub!(/\s\+(\s*.*)\+/, ' <u>\1</u>') # underline
    s.gsub!(/\s-(\s*.*)-/, ' <s>\1</s>') # strikethrough
    s.gsub!(/\s\^(.*)\^/, ' <sup>\1</sup>') # superscript
    s.gsub!(/\s~(\s*.*)~/, ' <sub>\1</sub>') # subscript

    f.write(s)
    f.close
  end

end


# usage
# maxref = YamlToMaxref.new
# maxref.makeRefpage source_path
# maxref.write dest_path
