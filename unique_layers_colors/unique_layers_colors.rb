=begin
Copyright 2014, Yurij Kulchevich
All Rights Reserved
THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE.
License: GPL V.3
Author: Yurij Kulchevich
Organization:
Name: unique_layers_colors
Version: 0.1
SU Version: 2014
Date: 27.09.2014
Description: Plugin make unique all colors of layers in model
Usage: see README
History:
0.1 27-September-2014 First version
=end

require "sketchup.rb"
# Main code (start module name with capital letter)

module Layers_colors

def self.make_unique_colors
  # do something...
end

def self.layers_colors_list
# do something...
end

end
# Create menu items
unless file_loaded?(__FILE__)
  unique_layers_colors_menu = UI.menu("Plugins").add_submenu("Unique Layers Colors")
  unique_layers_colors_menu.add_item("Make Unique Colors") {Layers_colors::make_unique_colors}
  unique_layers_colors_menu.add_item("List of Colors") {Layers_colors::layers_colors_list}
  file_loaded(__FILE__)
end
