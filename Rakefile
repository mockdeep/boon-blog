require 'bridgetown'

Bridgetown.load_tasks

task default: :deploy

desc 'Build the frontend (esbuild) and the static site into output/'
task deploy: [:clean, 'frontend:build'] do
  Bridgetown::Commands::Build.start
end

desc 'Remove the output directory'
task :clean do
  Bridgetown::Commands::Clean.start
end

namespace :frontend do
  desc 'Bundle frontend assets with esbuild'
  task :build do
    sh 'pnpm run esbuild'
  end

  # Invoked by `bridgetown start` (via `bridgetown frontend:dev`) to run the
  # esbuild watcher alongside the dev server.
  desc 'Watch and rebuild frontend assets with esbuild'
  task :dev do
    sh 'pnpm run esbuild-dev'
  rescue Interrupt
  end
end

# Deploy entrypoint kept from the Middleman setup: Heroku and the test suite
# run `rake assets:precompile`, which now performs the full Bridgetown deploy
# build (esbuild frontend bundle + static site).
namespace :assets do
  desc 'Full deploy build (alias of :deploy)'
  task precompile: :deploy
end
