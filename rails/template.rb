unless yes? "Quick mode?"
  # http://guides.rubyonrails.org/configuring.html#configuring-generators
  # Set default haml
  create_file ".rvmrc", "rvm use 1.9.3@#{app_name} --create"

  copy_file "~/.vim/rails/Guardfile", "Guardfile"
  copy_file "~/.vim/rails/pl.yml", "config/locales/pl.yml"
  copy_file "~/.vim/rails/i18n.rb", "config/initializers/i18n.rb"
  copy_file "~/.vim/rails/quiet_assets.rb", "config/initializers/quiet_assets.rb"

  inject_into_file "config/application.rb", :after => "config.filter_parameters += [:password]" do
    <<-eos

      config.time_zone = 'Warsaw'
      config.i18n.default_locale = :pl
      config.generators do |g|
        g.template_engine = :haml
      end
    eos
  end

  inject_into_file "config/environments/development.rb", :before => "#{app_name.classify}::Application.configure" do
    <<-eos
  require "ruby-debug"
  Debugger.start
    eos
  end

  inject_into_file "app/assets/stylesheets/application.css", after: "*= require_self" do
    <<-eos

   *= require overrides
    eos
  end

  run "rm public/index.html"
  rake "db:create"

  gem 'haml'
  gem 'haml-rails'
  gem 'formtastic'
  gem 'friendly_id'
  gem 'faker'
  gem "anjlab-bootstrap-rails", :require => "bootstrap-rails"

  if devise_and_can_can = yes?("Install Can Can and Devise?")
    gem 'cancan'
    gem 'devise'
  end

  gem_group :development, :test do
    gem 'linecache19', :git => 'git://github.com/mark-moseley/linecache'
    gem 'ruby-debug-base19x', '~> 0.11.30.pre4'
    gem 'ruby-debug19'

    gem 'rspec'
    gem 'rspec-rails'
    gem 'capybara'
    gem 'spork'
    gem 'guard-spork'
    gem 'guard'
    gem 'guard-sass'
    gem 'guard-rspec'
    gem 'guard-livereload'
    gem 'libnotify'
    gem 'mocha'
    gem 'factory_girl_rails'
    gem "nifty-generators"
    gem 'deployer_files'
  end

  system "gem install bundler"
  run 'bundle install'

  generate 'rspec:install'

  run "echo 'config/database.yml' >> .gitignore"
  run 'cp config/database.yml config/database.example.yml'

  # clean up rails defaults
  remove_file 'public/index.html'
  remove_file 'app/assets/images/rails.png'

  remove_file 'spec/spec_helper.rb'
  remove_file 'app/assets/javascripts/application.js'

  copy_file "~/.vim/rails/application.js", "app/assets/javascripts/application.js"
  copy_file "~/.vim/rails/overrides.css.scss", "app/assets/stylesheets/overrides.css.scss"
  copy_file "~/.vim/rails/mailer_macros.rb", "spec/support/mailer_macros.rb"
  copy_file "~/.vim/rails/spec_helper.rb", "spec/spec_helper.rb"

  remove_file 'app/views/layouts/application.html.erb'
  copy_file "~/.vim/rails/application.html.haml", "app/views/layouts/application.html.haml"

  if devise_and_can_can
    # authentication and authorization setup
    generate "cancan:ability"
    generate "devise:install"
    generate "devise User"
    generate "devise:views"
  end

  rake "db:migrate"

  git :init
  git :add => "."
  git :commit => "-a -m 'Initial commit'"
end
