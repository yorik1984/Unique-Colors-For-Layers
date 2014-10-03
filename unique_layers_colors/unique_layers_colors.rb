# Copyright 2014, Yurij Kulchevich
# All Rights Reserved
# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE.
# ------------------------------------------------------------------------------
# License: GPL V.3
# Author: Yurij Kulchevich
# Organization:
# Name: unique_layers_colors
# Version: 0.1
# SU Version: 2014
# Date: 27.09.2014
# Description: Plugin makes unique all colors of layers in model
# Usage: see README
# History:
# 0.1 27-September-2014 First version
#------------------------------------------------------------------------------

require 'sketchup.rb'
# Main code (start module name with capital letter)

module LayersColors

def layers_color_to_rgb_value(color_of_layer)
  # For example: "Color(000, 111, 222, 255)" => "000, 111, 222"
  color_string = color_of_layer.color.to_s
  rgbR = color_string[6..8]    # => 000
  rgbG = color_string[11..13]  # => 111
  rgbB = color_string[16..18]  # => 222
  result_string = "#{rgbR}, #{rgbG}, #{rgbB}"
end

def all_layers_color_to_rgb_value(layer_with_full_color_value)
  result_layers = Array.new(layer_with_full_color_value.count)
  layer_with_full_color_value.count.times { | i | result_layers[i] = layers_color_to_rgb_value(layer_with_full_color_value[i]) }
  result_layers
end

def random_unique_layers_colors(layers_of_model)
  layers_of_colors = Array.new(layers_of_model.count)
  layers_of_colors = all_layers_color_to_rgb_value(layers_of_model)
    1.step(layers_of_colors.count-1, 1) do |i|
    while layers_of_colors.find_all{ |elem| elem == layers_color_to_rgb_value(layers_of_model[i]) }.size != 0 && layers_of_colors.count(layers_of_colors[i]) > 1
      layers_of_model[i].color = Sketchup::Color.new(rand(0..255), rand(0..255), rand(0..255))
      puts "while"
    end
  end
  layers_of_model
end

def self.check_layers_colors_list
  # button in toolbars
  # Find in model not unique layers.`
  # If NOT find
  #   send message "All layers in model have unique color"
  # If find, send message "Some of layers have same color"
  #   print list of layers groups with same color and print this color with name or RGB pallet.
  #   run "method make_unique_colors" if user want to make unique colors for all layers in this list (manual or random)

  model = Sketchup.active_model
  active_display_color_by_layer = model.rendering_options["DisplayColorByLayer"]
  active_edge_color_mode = model.rendering_options["EdgeColorMode"]
  model.rendering_options["DisplayColorByLayer"] = true
  model.rendering_options["EdgeColorMode"] = 0

  layers = model.layers
  # Compare two arrays
  layers_rgb_colors = Array.new(layers.count)
  layers_rgb_colors = all_layers_color_to_rgb_value(layers)
  if layers_rgb_colors != layers_rgb_colors.uniq
    difference = layers_rgb_colors.size - layers_rgb_colors.uniq.size
    answer = UI.messagebox("Model has #{difference} layer(s) with non-unique color(s). Fix it?", MB_YESNO)
    layers = random_unique_layers_colors(layers) if answer  == IDYES
  else
    UI.messagebox ("All layers in model have unique colors")
  end

  # Reset to active render options settings
  model.rendering_options["DisplayColorByLayer"] = active_display_color_by_layer
  model.rendering_options["EdgeColorMode"] = active_edge_color_mode

end

def self.create_layers_with_unique_colors
  # button in toolbars
  # Method create new layer with unique color.
  # Analyse present in models layers and generate random unique color
end

def self.make_unique_layers_color
  # button in toolbars
  # make unique colors random or manual for all model or some part of layers with not unique colors
end

def self.help_information
  # button in toolbars
  # open README PDF-file  or help content in messagebox
end

end

# Create menu items
unless file_loaded?(__FILE__)
  unique_layers_colors_menu = UI.menu("Plugins").add_submenu("Unique Layers Colors")
  unique_layers_colors_menu.add_item("Check of layers colors") {LayersColors::check_layers_colors_list}
  unique_layers_colors_menu.add_item("Create layer with unique color") {LayersColors::create_layers_with_unique_colors}
  unique_layers_colors_menu.add_item("Make unique layers colors") {LayersColors::make_unique_layers_color}
  unique_layers_colors_menu.add_item("Help") {LayersColors::help_information}
  file_loaded(__FILE__)
end
