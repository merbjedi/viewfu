require "view_fu/tag_helper"
require "view_fu/meta_helper"

require "browser_detect/helper"
require "headliner/helper"

# make sure we're running inside Merb
if defined?(Merb::Plugins)

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:viewfu] = {}
  
  Merb::BootLoader.before_app_loads do
    Merb::Controller.send(:include, ViewFu::MetaHelper)
    Merb::Controller.send(:include, ViewFu::TagHelper)
    Merb::Controller.send(:include, Headliner::Helper)
    Merb::Controller.send(:include, BrowserDetect::Helper)
  end
end