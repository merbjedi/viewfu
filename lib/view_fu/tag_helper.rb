module ViewFu
  module TagHelper
    # Calls a Merb Partial with a block, 
    # which you can catch content from
    # 
    # Usage Example:
    # <%= partial_block :fieldset, :legend => "Login" do %>
    #   .. inner partial content
    # <% end =%>
    # 
    # Associated Partial (_fieldset.html.erb)
    # <fieldset>
    #   <legend><%= locals[:legend] %></legend>
    #   <%= catch_content %>
    # </fieldset>
    def partial_block(template, options={}, &block)
      throw_content(:for_layout, block_given? ? capture(&block) : "")
      partial(template, options)
    end
    
    # Allows Easy Nested Layouts in Merb
    # 
    # Usage Example:
    # 
    # Parent Layout: layout/application.html.erb
    # -------
    # <html>
    #   <head>
    #     <title>Title</title>
    #   </head>
    #   <body>
    #     <%= catch_content %>
    #   </body>
    # </html>
    #
    # SubLayout: layout/alternate.html.erb
    # --------
    # <%= parent_layout "application" do %>
    #   <div class="inner_layout">
    #     <%= catch_content %>
    #   </div>
    # <% end =%>
    #
    # Now you can use the alternate layout in any of your views as normal 
    # and it will reuse the wrapping html on application.html.erb
    def parent_layout
      render capture(&block), :layout => layout
    end
    
    # Writes a br tag
    def br
      "<br />"
    end

    # Writes an hr tag
    def hr
      "<hr />"
    end
    
    # Writes a nonbreaking space
    def nbsp
      "&nbsp;"
    end
    
    # ported from rails
    def auto_discovery_link_tag(type = :rss, url = nil, tag_options = {})
      
      # theres gotta be a better way of setting mimetype for a file extensionin Merb..
      unless tag_options[:type]
        if type.to_s == "rss"
          tag_options[:type] = "application/rss+xml"
        elsif type.to_s == "atom"
          tag_options[:type] = "application/atom+xml"
        end
      end

      tag(:link, :rel => (tag_options[:rel] || "alternate"),
                  :type  => tag_options[:type].to_s,
                  :title => (tag_options[:title] || type.to_s.upcase),
                  :href  => (url || "#"))
    end
    
    # Writes an hr space tag
    def space
      "<hr class='space' />"
    end
    
    # Writes an anchor tag
    def anchor(anchor_name, options = {})
      tag(:a, options.merge(:name => anchor_name)) do
        ""
      end
    end
    
    # Writes a clear tag
    def clear_tag(tag, direction = nil)
      if tag == :br
        "<br class=\"clear#{direction}\" />"
      else
        "<#{tag} class=\"clear#{direction}\"></#{tag}>"
      end
    end
  
    def current_year
      Time.now.strftime("%Y")
    end

    # Writes a clear div tag
    def clear(direction = nil)
      clear_tag(:div, direction)
    end
  
    # Return some lorem text
    def lorem
      "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    end
  
    # Return a hidden attribute hash (useful in Haml tags - %div{hidden})
    def hidden
      {:style => "display:none"}
    end
    
    # Easily link to an image
    def link_to_image(image_path, label, url, options={})
      # setup vertical alignment
      vert_align = options.delete(:vert)
      if vert_align.nil?
        vert_style = "vertical-align: middle"
      elsif vert_align.blank?
        vert_style = ""
      else
        vert_style = "vertical-align: #{vert_align.to_i}px"
      end

      link_to(image_tag(image_path, :class => "vert-middle", :style => "#{vert_style}"), url, options)+"&nbsp;"+
      link_to(label, url, options)
    end
    
    def add_class_if(css_class, condition)
      if condition
        {:class => css_class}
      else
        {}
      end
    end

    def add_class_unless(css_class, condition)
      add_class_if(css_class, !condition)
    end
  
    # Return a hidden attribute hash if a condition evaluates to true
    def hide_if(condition)
      if condition
        hidden
      else
        {}
      end
    end
    alias :hidden_if :hide_if
    alias :show_unless :hide_if
  
    # Return a hidden attribute hash if a condition evaluates to false
    def hide_unless(condition)
      if !condition
        hidden
      else
        {}
      end
    end
    alias :hidden_unless :hide_unless
    alias :show_if :hide_unless 
  
    # Wrap a delete link
    def delete_link(*args)
      options = {:method => :delete, :confirm => "Are you sure you want to delete this?"}.merge(extract_options_from_args!(args)||{})
      args << options
      link_to(*args)
    end
  
    # Wrap a block with a link
    def link_to_block(*args, &block)
      content = capture(&block)
      return link_to(content, *args)
    end
  
    # Check if we're on production environment
    def production?
      Merb.env == "production"
    end
  
    # Display will_paginate paging links
    def paging(page_data, style = :sabros)
      return unless page_data.is_a? WillPaginate::Collection
      will_paginate(page_data, :class => "pagination #{style}", :inner_window => 3)
    end

    # clearbit icons
    def clearbit_icon(icon, color, options = {})
      image_tag "clearbits/#{icon}.gif", {:class => "clearbits #{color}", :alt => icon}.merge(options)
    end

    # pixel spacing helper
    def pixel(options = {})
      image_tag "pixel.png", options
    end
    
    # check to see if an index is the first item in a collection
    def is_first(i)
      i.to_i.zero? ? {:class => "first"} : {}
    end
    
  end
end