gem 'pg'
gem 'capistrano'
gem 'capistrano_colors'
gem 'capistrano-ext'
gem 'rvm-capistrano'
gem "twitter-bootstrap-rails"
gem 'kaminari'

gem_group :assets do
  gem 'coffeebeans'
end

gem_group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

uncomment_lines 'Gemfile', "gem 'therubyracer'"
uncomment_lines 'Gemfile', "gem 'unicorn'"

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