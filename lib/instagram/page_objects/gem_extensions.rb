module Watir

  # This should only be necessary until watir-webdriver
  # fixes the problem with underscores in custom element tags...
  class ElementLocator
    def lhs_for(key)
      case key
        when :text, 'text'
          'normalize-space()'
        when :href
          # TODO: change this behaviour?
          'normalize-space(@href)'
        when :type
          # type attributes can be upper case - downcase them
          # https://github.com/watir/watir-webdriver/issues/72
          XpathSupport.downcase('@type')
        else
          if key.to_s.start_with?('data')
            "@#{key.to_s.sub("_", "-")}"
          else
            "@#{key.to_s.gsub("_", "-")}"
          end
      end
    end

    # Adding support for useful custom HTML attributes...
    alias :old_normalize_selector :normalize_selector

    def normalize_selector(how, what)
      case how
        when :photoid
          [how, what]
        # add more needed items as additional "when's" here...
        else
          old_normalize_selector(how, what)
      end
    end

  end

end