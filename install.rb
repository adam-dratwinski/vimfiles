#!/usr/bin/ruby

PATH = File.expand_path('../rcs',  __FILE__) 

%w(bash_lfsps1 bashrc gvimrc inputrc irbrc railsrc vimrc.local gitconfig).each do |name|
  if name == "vimrc.local"
    to = "vimrc"
  else
    to = name
  end

  if system "ln -s #{PATH}/#{name} ~/.#{to} 2> /dev/null"
    puts "Linked #{name}"
  else
    puts ".#{to} already exists"
  end
end

