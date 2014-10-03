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
    end
  end
  layers_of_model
end

def random_all_layers_colors(layers_of_model)
  layers_of_colors = Array.new(layers_of_model.count)
  layers_of_colors = all_layers_color_to_rgb_value(layers_of_model)
    1.step(layers_of_colors.count-1, 1) do |i|
    while layers_of_colors.find_all{ |elem| elem == layers_color_to_rgb_value(layers_of_model[i]) }.size != 0
      layers_of_model[i].color = Sketchup::Color.new(rand(0..255), rand(0..255), rand(0..255))
    end
  end
  layers_of_model
end

def self.check_layers_colors
  model = Sketchup.active_model
  layers = model.layers
  active_display_color_by_layer = model.rendering_options["DisplayColorByLayer"]
  active_edge_color_mode = model.rendering_options["EdgeColorMode"]
  model.rendering_options["DisplayColorByLayer"] = true
  model.rendering_options["EdgeColorMode"] = 0
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

def self.make_unique_layers_color
  model = Sketchup.active_model
  layers = model.layers
  answer = UI.messagebox("Do you want to change color of layers in model?", MB_YESNO)
  if answer  == IDYES
    prompts = ["Layers"]
    list = ["Non-unique|All"]
    defaults = ["Non-unique"]
    input = UI.inputbox(prompts, defaults, list, "Random layers colors")
  end
  case input[0]
  when "Non-unique"
    random_unique_layers_colors(layers)
  when "All"
    random_all_layers_colors(layers)
  else
    UI.messagebox("Input Error")
  end
end

def self.create_new_layer_with_unique_color
  model = Sketchup.active_model
  layers = model.layers
  template_name = layers.unique_name "Layer"
  new_layer = layers.add template_name
  random_unique_layers_colors(layers)
end

def self.help_information
  # button in toolbars
  # open README PDF-file  or help content in messagebox
end

end # module LayersColors

# Create menu items
unless file_loaded?(__FILE__)
  unique_layers_colors_menu = UI.menu("Plugins").add_submenu("Unique Layers Colors")
  unique_layers_colors_menu.add_item("Check of layers colors") {LayersColors::check_layers_colors}
  unique_layers_colors_menu.add_item("Make unique layers colors") {LayersColors::make_unique_layers_color}
  unique_layers_colors_menu.add_item("Create new layer with unique color") {LayersColors::create_new_layer_with_unique_color}
  unique_layers_colors_menu.add_item("Help") {LayersColors::help_information}
  file_loaded(__FILE__)
end
