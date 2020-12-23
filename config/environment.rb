require "bundler"
Bundler.require

DB = {conn: SQLite3::Database.new("db/twitter.db")}

DB[:conn].results_as_hash = true

require_all "lib"
require_relative "../db/seed"