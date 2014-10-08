# Loader for unique_colors_for_layers/unique_colors_for_layers.rb

require 'sketchup.rb'
require 'extensions.rb'

version_required = 14

if Sketchup.version.to_f >= version_required
  unique_colors_for_layers = SketchupExtension.new "Unique colors for layers", "unique_colors_for_layers/unique_colors_for_layers.rb"
  unique_colors_for_layers.copyright= "Copyright 2014 by Yurij Kulchevich"
  unique_colors_for_layers.creator= "Yurij Kulchevich"
  unique_colors_for_layers.version = "1.0"
  unique_colors_for_layers.description = "Plugin makes unique all colors of layers in model"
  Sketchup.register_extension unique_colors_for_layers, true
else
  UI.messagebox("Plugin \"Unique colors for layers\" doesn't work in this version of Sketchup. Please, install Sketchup version 20#{version_required.to_s} to run this plugin. Visit sketchup.com to upgrade.")
end
