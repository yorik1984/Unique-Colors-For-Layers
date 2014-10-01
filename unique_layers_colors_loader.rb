# Loader for unique_layers_colors/unique_layers_colors.rb

require 'sketchup.rb'
require 'extensions.rb'

version_required = 14

if Sketchup.version.to_f >= version_required
  unique_layers_colors = SketchupExtension.new "Unique Layers Colors", "unique_layers_colors/unique_layers_colors.rb"
  unique_layers_colors.copyright= "Copyright 2014 by Yurij Kulchevich"
  unique_layers_colors.creator= "Yurij Kulchevich"
  unique_layers_colors.version = "0.1"
  unique_layers_colors.description = "Plugin makes unique all colors of layers in model"
  Sketchup.register_extension unique_layers_colors, true
else
  UI.messagebox("Plugin \"Unique Layers Colors\" doesn't work in this version of Sketchup. Please, install Sketchup version 20#{version_required.to_s} to run this plugin. Visit sketchup.com to upgrade.")
end
