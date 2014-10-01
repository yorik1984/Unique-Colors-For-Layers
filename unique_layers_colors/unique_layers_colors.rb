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

def layers_color_to_rgb(color_of_layers)
  # For example Color(000, 111, 222, 255)
  color_string = color_of_layers.to_s
  rgbR = color_string[6...9]    # => 000
  rgbG = color_string[11...14]  # => 111
  rgbB = color_string[16...19]  # => 222
  result_string = "#{rgbR}, #{rgbG}, #{rgbB}"
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
  model_path = File.dirname(model.path)
  if model_path == "."
    UI.messagebox"Please, save this 'Untitled' new model before running this !\nExiting ..."
  end
  active_display_color_by_layer = model.rendering_options["DisplayColorByLayer"]
  if model.rendering_options["DisplayColorByLayer"] == false
    model.rendering_options["DisplayColorByLayer"] = true
  end
  active_edge_color_mode = model.rendering_options["EdgeColorMode"]
  if model.rendering_options["EdgeColorMode"] != 0
    model.rendering_options["EdgeColorMode"] = 0
  end

  layers = model.layers
  # Compare two arrays
  layers_colors = Array.new(layers.count)
  layers.count.times { | i | layers_colors[i] = layers_color_to_rgb(layers[i].color) }
  layers_unique_colors = layers_colors.uniq

  # TEST ----------------------------------------------------------------------
  if layers_unique_colors == layers_colors
    puts "Layers same"
  else
    puts "Layers NOT same"
  end
  # TEST ----------------------------------------------------------------------

  # Reset to active render options settings
  model.rendering_options["DisplayColorByLayer"] = active_display_color_by_layer
  model.rendering_options["EdgeColorMode"] = active_edge_color_mode

end

def self.create_layer_with_unique_color
  # button in toolbars
  # Method create new layer with unique color.
  # Analyse present in models layers and generate random unique color
end

def self.make_unique_layers_colors
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
  unique_layers_colors_menu.add_item("Create layer with unique color") {LayersColors::create_layer_with_unique_color}
  unique_layers_colors_menu.add_item("Make unique layers colors") {LayersColors::make_unique_layers_colors}
  unique_layers_colors_menu.add_item("Help") {LayersColors::help_information}
  file_loaded(__FILE__)
end
