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
Description: Plugin makes unique all colors of layers in model
Usage: see README
History:
0.1 27-September-2014 First version
=end

require "sketchup.rb"
# Main code (start module name with capital letter)


module Layers_colors

def self.create_layer_with_unique_color
  # Method create new layer with unique color.
  # Analyse present in models layers and generate random unique color
end

def self.check_layers_colors_list
  # do something
end

def self.make_unique_colors
  # do something
end

def self.color_by_material
  # do something
end

def self.color_by_layer
  # do something
end

def self.help_information
  # do something
end

end

# Create menu items
unless file_loaded?(__FILE__)
  unique_layers_colors_menu = UI.menu("Plugins").add_submenu("Unique Layers Colors")
  unique_layers_colors_menu.add_item("Create layer with unique color") {Layers_colors::create_layer_with_unique_color}
  unique_layers_colors_menu.add_item("Check of layers colors") {Layers_colors::check_layers_colors_list}
  unique_layers_colors_menu.add_item("Make Unique colors") {Layers_colors::make_unique_colors}
  unique_layers_colors_menu.add_item("Color by material") {Layers_colors::color_by_material}
  unique_layers_colors_menu.add_item("Color by layer") {Layers_colors::color_by_layer}
  unique_layers_colors_menu.add_item("Help") {Layers_colors::help_information}
  file_loaded(__FILE__)
end
