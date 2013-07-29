ENV["MAHOUT_DIR"] = File.join(File.dirname(__FILE__),"mahout-distribution-0.7")
require "postgresql-9.2-1003.jdbc4.jar"
require "mysql-connector-java-5.1.25-bin.jar"
require "bundler/setup"
require 'jruby_mahout'
require 'benchmark'

puts "\n===== MySQL ================================"
dataSource = com.mysql.jdbc.jdbc2.optional.MysqlDataSource.new;

dataSource.setServerName("127.0.0.1");
dataSource.setUser("root");
dataSource.setPassword(nil);
dataSource.setDatabaseName("recommender-demo_development");
dataModel = org.apache.mahout.cf.taste.impl.model.jdbc.MySQLJDBCDataModel.new(dataSource, "ratings", "user_id", "movie_id", "rate", "created_at");
recommender = JrubyMahout::Recommender.new("TanimotoCoefficientSimilarity", 5, "GenericUserBasedRecommender", false)
recommender.data_model = dataModel

puts Benchmark.measure {
  puts recommender.recommend(2, 10, nil).inspect
}

puts "\n===== User Based ========================="
recommender = JrubyMahout::Recommender.new("TanimotoCoefficientSimilarity", 5, "GenericUserBasedRecommender", false)
recommender.data_model = JrubyMahout::DataModel.new("file", { :file_path => "ratings.csv" }).data_model

# 10 recommendations for user with id = 2
puts Benchmark.measure {
  puts recommender.recommend(2, 10, nil).inspect
}

