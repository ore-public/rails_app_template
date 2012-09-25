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
  gem "cucumber-rails", :require => false
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'rr'
  gem 'spork'
end

gem_group :development do
  gem 'growl'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-cucumber'
  gem 'rb-fsevent', :require => false
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
uncomment_lines 'spec/spec_helper.rb', "config.mock_with :rr"
comment_lines 'spec/spec_helper.rb', 'config.fixture_path'
#insert_into_file 'spec/spec_helper.rb', "require 'factory_girl'"
#insert_into_file 'config/application.rb' do
#    config.generators do |g|
#      g.test_framework :rspec, fixture: true, view_specs: false
#      g.fixture_replacement :factory_girl, dir: 'spec/factories'
#    end
#end

#spork
run "bundle exec spork --bootstrap"
# spec_helper.rbを編集して、Spork.preloadのブロックの中に設定を移す
# http://qiita.com/items/7b98fb8ec493ff801029  を参考

#guard
run "bundle exec guard init spork"
run "bundle exec guard init rspec"
run "bundle exec guard init cucumber"
# Guardfileを編集
# http://qiita.com/items/7b98fb8ec493ff801029  を参考


#rails_config
generate 'rails_config:install'

#cucumber
generate "cucumber:install"
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
