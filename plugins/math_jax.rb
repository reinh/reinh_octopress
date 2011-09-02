module Jekyll
  class MathJaxBlockTag < Liquid::Tag
    def render(context)
      '<div style="font-size: 120%;"><script type="math/tex; mode=display">'
    end
  end
  class MathJaxEndTag < Liquid::Tag
    def render(context)
      '</script></div>'
    end
  end
  class MathJaxInlineTag < Liquid::Tag
    def render(context)
      '<script type="math/tex">'
    end
  end
  class MathJaxInlineEndTag < Liquid::Tag
    def render(context)
      '</script>'
    end
  end
end

Liquid::Template.register_tag('math', Jekyll::MathJaxBlockTag)
Liquid::Template.register_tag('m', Jekyll::MathJaxInlineTag)
Liquid::Template.register_tag('endmath', Jekyll::MathJaxEndTag)
Liquid::Template.register_tag('em', Jekyll::MathJaxInlineEndTag)
