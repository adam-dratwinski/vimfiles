require 'rubygems'
 
IRB.conf[:PROMPT_MODE] = :SIMPLE
 
begin
  require 'wirble'
  Wirble.init
  Wirble.colorize
rescue LoadError
end
 
begin
  # http://github.com/michaeldv/awesome_print
  require 'hirb'
  require "ap"
  IRB::Irb.class_eval do
    def output_value
      ap @context.last_value
    end
  end
rescue LoadError
end
 
begin
  require 'hirb'
  Hirb.enable
  extend Hirb::Console
rescue LoadError
end
 
def r!; reload!; end
def pwd; Dir.getwd; end
def ls; Dir['*']; end
def la; Dir.entries('.') - ['.', '..']; end
def cd(directory); Dir.chdir(directory); end
 
if defined? ActiveRecord::Base
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
