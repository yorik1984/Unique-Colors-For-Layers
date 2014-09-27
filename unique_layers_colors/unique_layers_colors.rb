=begin
Copyright 2010, Author
All Rights Reserved
THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE.
License: AuthorsLicenseStatement
Author: AuthorName
Organization: AuthorAffiliationOrOrganizationIfAny
Name: ScriptName
Version: ScriptVersion
SU Version: MinimumSketchUpVersion
Date: Date
Description: ScriptDescription
Usage: ScriptUsageInstructions
History:
1.000 YYYY-MM-DD Description of changes
=end

require "sketchup.rb"
# Main code (start module name with capital letter)

module My_module

def self.my_method
  # do something...
end

def self.my_second_method
# do something...
end

end
# Create menu items
unless file_loaded?(__FILE__)
  mymenu = UI.menu("Plugins").add_submenu("My Plugin Collection")
  mymenu.add_item("My Tool 1") {My_module::my_method}
  mymenu.add_item("My Tool 2") {My_module::my_second_method}
  file_loaded(__FILE__)
end
