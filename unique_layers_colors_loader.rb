# Loader for unique_layers_colors/unique_layers_colors.rb

require "sketchup.rb"
require "extensions.rb"

unique_layers_colors = SketchupExtension.new "Unique Layers Colors", "unique_layers_colors/unique_layers_colors.rb"
unique_layers_colors.copyright= "Copyright 2014 by Yurij Kulchevich"
unique_layers_colors.creator= "Yurij Kulchevich"
unique_layers_colors.version = "0.1"
unique_layers_colors.description = "Plugin make unique all colors of layers in model"
Sketchup.register_extension unique_layers_colors, true
