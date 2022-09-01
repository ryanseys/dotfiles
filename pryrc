Pry.editor = 'vi'

$LOAD_PATH << "~/.gem/ruby/3.1.2/gems/awesome_print-1.9.2/lib/"

require 'awesome_print'
AwesomePrint.irb!

Pry.commands.alias_command 'c', 'continue' rescue nil
Pry.commands.alias_command 's', 'step' rescue nil
Pry.commands.alias_command 'n', 'next' rescue nil

puts "Welcome Ryan! I'm a pry shell. Type 'help' for a list of commands.\n"

if Object.const_defined?("FactoryBot")
  include FactoryBot::Syntax::Methods

  puts "FactoryBot methods (e.g. create / build) are available!"
end
