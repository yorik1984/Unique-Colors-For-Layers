
require "sketchup.rb"
require "extensions.rb"

# Load plugin as extension (so that user can disable it)

my_plugin_loader = SketchupExtension.new "My_Plugin Loader", "my_plugin/my_plugin.rb"
my_plugin_loader.copyright= "Copyright 2010 by Me"
my_plugin_loader.creator= "Me, myself and I"
my_plugin_loader.version = "1.0"
my_plugin_loader.description = "Description of plugin."
Sketchup.register_extension my_plugin_loader, true
