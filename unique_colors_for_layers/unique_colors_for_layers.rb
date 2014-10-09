# Copyright 2014, Yurij Kulchevich
# All Rights Reserved
# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE.
# ------------------------------------------------------------------------------
# License: GPL V.3
# Author: Yurij Kulchevich
# Organization:
# Name: unique_colors_for_layers.rb
# Version: 1.0
# SU Version: 2014
# Date of begin: 27.09.2014
# Description: Plugin makes unique all colors of layers in model
# Usage: see README
# History:
# 1.0 08-October-2014 Initial release
#------------------------------------------------------------------------------

require 'sketchup.rb'

module LayersColors

def self.colors_of_layers_to_rgb_value(color_of_layer)
  # For example: "Color(000, 111, 222, 255)" => "000, 111, 222"
  color_string = color_of_layer.color.to_s
  rgbR = color_string[6..8]    # => 000
  rgbG = color_string[11..13]  # => 111
  rgbB = color_string[16..18]  # => 222
  result_string = "#{rgbR}, #{rgbG}, #{rgbB}"
end

def self.all_colors_of_layers_to_rgb_value(layer_with_full_color_value)
  # Get RGB colors of all layers in array by method "colors_of_layers_to_rgb_value"
  result_layers = Array.new(layer_with_full_color_value.count)
  layer_with_full_color_value.count.times { | i | result_layers[i] = colors_of_layers_to_rgb_value(layer_with_full_color_value[i]) }
  result_layers
end

def self.random_non_unique_colors_of_layers(layers_of_model)
  # Randomize only non-unique layers colors
  layers_of_colors = Array.new(layers_of_model.count)
  layers_of_colors = all_colors_of_layers_to_rgb_value(layers_of_model)
  1.step(layers_of_colors.count-1, 1) do |i|
    while layers_of_colors.find_all{ |elem| elem == colors_of_layers_to_rgb_value(layers_of_model[i]) }.size != 0 && layers_of_colors.count(layers_of_colors[i]) > 1
      layers_of_model[i].color = Sketchup::Color.new(rand(0..255), rand(0..255), rand(0..255))
    end
  end
  layers_of_model
end

def self.random_all_colors_of_layers(layers_of_model)
  # Randomize all layers colors in model with unique value
  layers_of_colors = Array.new(layers_of_model.count)
  layers_of_colors = all_colors_of_layers_to_rgb_value(layers_of_model)
    1.step(layers_of_colors.count-1, 1) do |i|
    while layers_of_colors.find_all{ |elem| elem == colors_of_layers_to_rgb_value(layers_of_model[i]) }.size != 0
      layers_of_model[i].color = Sketchup::Color.new(rand(0..255), rand(0..255), rand(0..255))
    end
  end
  layers_of_model
end

def self.check_colors_of_layers
  # Check model for non-unique layers colors
  # If not unique, user can fix it
  model = Sketchup.active_model
  layers = model.layers
  active_display_color_by_layer = model.rendering_options["DisplayColorByLayer"]
  active_edge_color_mode = model.rendering_options["EdgeColorMode"]
  model.rendering_options["DisplayColorByLayer"] = true
  model.rendering_options["EdgeColorMode"] = 0
  # Compare two arrays
  layers_rgb_colors = Array.new(layers.count)
  layers_rgb_colors = all_colors_of_layers_to_rgb_value(layers)
  if layers_rgb_colors != layers_rgb_colors.uniq
    difference = layers_rgb_colors.size - layers_rgb_colors.uniq.size
    answer = UI.messagebox("Model has #{difference.to_s} layer(s) with non-unique color(s). Fix it?", MB_YESNO)
    layers = random_non_unique_colors_of_layers(layers) if answer  == IDYES
  else
    UI.messagebox ("All layers in model have unique colors")
  end
  # Reset to active render options settings
  model.rendering_options["DisplayColorByLayer"] = active_display_color_by_layer
  model.rendering_options["EdgeColorMode"] = active_edge_color_mode
end

def self.make_unique_colors_for_layers
  # Make colors of layers unique. For all or non-unique
  model = Sketchup.active_model
  layers = model.layers
  answer = UI.messagebox("Do you want to change colors for layers in model?", MB_YESNO)
  if answer  == IDYES
    prompts = ["Layers"]
    list = ["Non-unique|All"]
    defaults = ["Non-unique"]
    input = UI.inputbox(prompts, defaults, list, "Random layers colors")
  end
  case input[0]
  when "Non-unique"
    random_non_unique_colors_of_layers(layers)
  when "All"
    random_all_colors_of_layers(layers)
  else
    UI.messagebox("Failure")
  end
end

def self.create_new_layer_with_unique_color
  # Make new layer with unique color
  model = Sketchup.active_model
  layers = model.layers
  template_name = layers.unique_name "Layer"
  prompts = ["Layer"]
  defaults = [template_name]
  input = UI.inputbox(prompts, defaults, "New layer with unique color")
  new_layer = layers.add input[0]
  layers_of_colors = Array.new(layers.count)
  layers_of_colors = all_colors_of_layers_to_rgb_value(layers)
  while layers_of_colors.find_all{ |elem| elem == colors_of_layers_to_rgb_value(new_layer) }.size != 0
    new_layer.color = Sketchup::Color.new(rand(0..255), rand(0..255), rand(0..255))
  end
end

def self.help_information
  # open help content in browser
  plugins = Sketchup.find_support_file "Plugins/"
  help_file_folder = "unique_colors_for_layers/help/"
  help_file = File.join(plugins, help_file_folder, "help.html" )
  if (help_file)
    UI.openURL "file://" + help_file
  else
    UI.messagebox "Failure"
  end
end

end # module LayersColors

# Create menu items
unless file_loaded?(__FILE__)
  # Create toolbar
  plugins = Sketchup.find_support_file "Plugins/"
  icons_folder = "unique_colors_for_layers/icons"
  icon_s_check_colors_of_layers = File.join(plugins, icons_folder, "check_colors_of_layers_16.png")
  icon_check_colors_of_layers = File.join(plugins, icons_folder, "check_colors_of_layers_24.png")
  icon_s_make_unique_colors_for_layers = File.join(plugins, icons_folder, "make_unique_colors_for_layers_16.png")
  icon_make_unique_colors_for_layers = File.join(plugins, icons_folder, "make_unique_colors_for_layers_24.png")
  icon_s_create_new_layer_with_unique_color = File.join(plugins, icons_folder, "create_new_layer_with_unique_color_16.png")
  icon_create_new_layer_with_unique_color = File.join(plugins, icons_folder, "create_new_layer_with_unique_color_24.png")
  icon_s_help_information = File.join(plugins, icons_folder, "help_16.png")
  icon_help_information = File.join(plugins, icons_folder, "help_24.png")
  unique_layers_colors_tb = UI::Toolbar.new("Unique colors for layers")

  # Add item "Check colors of layers"
  check_colors_of_layers_cmd = UI::Command.new("Check colors of layers"){ LayersColors::check_colors_of_layers }
  check_colors_of_layers_cmd.small_icon = icon_s_check_colors_of_layers
  check_colors_of_layers_cmd.large_icon = icon_check_colors_of_layers
  check_colors_of_layers_cmd.tooltip = "Check colors of layers"
  check_colors_of_layers_cmd.status_bar_text = "Check colors of layers"
  unique_layers_colors_tb.add_item(check_colors_of_layers_cmd)

  # Add item "Make unique colors for layers"
  make_unique_colors_for_layers_cmd = UI::Command.new("Make unique colors for layers"){ LayersColors::make_unique_colors_for_layers }
  make_unique_colors_for_layers_cmd.small_icon = icon_s_make_unique_colors_for_layers
  make_unique_colors_for_layers_cmd.large_icon = icon_make_unique_colors_for_layers
  make_unique_colors_for_layers_cmd.tooltip = "Make unique colors for layers"
  make_unique_colors_for_layers_cmd.status_bar_text = "Make unique colors for layers"
  unique_layers_colors_tb.add_item(make_unique_colors_for_layers_cmd)

  # Add item "Create new layer with unique color"
  create_new_layer_with_unique_color_cmd = UI::Command.new("Create new layer with unique color"){ LayersColors::create_new_layer_with_unique_color }
  create_new_layer_with_unique_color_cmd.small_icon = icon_s_create_new_layer_with_unique_color
  create_new_layer_with_unique_color_cmd.large_icon = icon_create_new_layer_with_unique_color
  create_new_layer_with_unique_color_cmd.tooltip = "Create new layer with unique color"
  create_new_layer_with_unique_color_cmd.status_bar_text = "Create new layer with unique color"
  unique_layers_colors_tb.add_item(create_new_layer_with_unique_color_cmd)

  # Add item "Help"
  help_cmd = UI::Command.new("Help"){ LayersColors::help_information }
  help_cmd.small_icon = icon_s_help_information
  help_cmd.large_icon = icon_help_information
  help_cmd.tooltip = "Help"
  help_cmd.status_bar_text = "Open in browser"
  unique_layers_colors_tb.add_item(help_cmd)

  # Create menu
  unique_layers_colors_menu = UI.menu("Plugins").add_submenu("Unique colors for layers")
  unique_layers_colors_menu.add_item("Check colors of layers") {LayersColors::check_colors_of_layers}
  unique_layers_colors_menu.add_item("Make unique colors for layers") {LayersColors::make_unique_colors_for_layers}
  unique_layers_colors_menu.add_item("Create new layer with unique color") {LayersColors::create_new_layer_with_unique_color}
  unique_layers_colors_menu.add_item("Help") {LayersColors::help_information}
  file_loaded(__FILE__)
end
