gem 'pg'
gem 'capistrano'
gem 'capistrano_colors'
gem 'capistrano-ext'
gem 'rvm-capistrano'
gem 'twitter-bootstrap-rails'
gem 'kaminari'
gem 'rails_config'
gem 'active_decorator'

gem_group :assets do
  gem 'coffeebeans'
end

gem_group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'headless'
  gem 'factory_girl_rails'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'capybara-webkit'
  gem 'database_cleaner'
end

#comment_lines 'Gemfile', "gem 'sqlite3'"
uncomment_lines 'Gemfile', "gem 'therubyracer'"
uncomment_lines 'Gemfile', "gem 'unicorn'"

if yes?("Would you like to install whenever?")
  gem 'whenever', require: false
end

run "bundle install"

#rspec
generate "rspec:install"

#rails_config
generate 'rails_config:install'

#cucumber
generate "cucumber:install ja capybara"
#insert_into_file "features/support/env.rb", "Capybara.javascript_driver = :webkit"

#twitter bootstrap generareとサンプルビュー作成
remove_file "public/index.html"
generate "bootstrap:install"
generate "bootstrap:layout", "application fluid"
generate "controller", "home index"
route("root :to => 'home#index'")
create_file "app/views/home/index.html.erb" do
  body = <<EOS
<div class="hero-unit">
  <h1>Hello, よろしくな</h1>
</div>
EOS
end

#capistranoのコンフィグレーション実行
capify!

#リポジトリ作成と、初回コミット
git :init
git :add => "."
git :commit => "-m 'First commit!'"
