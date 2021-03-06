ENV["MAHOUT_DIR"] = File.join(File.dirname(__FILE__),"mahout-distribution-0.7")
require "postgresql-9.2-1003.jdbc4.jar"
require "mysql-connector-java-5.1.25-bin.jar"
require "bundler/setup"
require 'jruby_mahout'
require 'benchmark'

puts "\n===== User Based ========================="
recommender = JrubyMahout::Recommender.new("TanimotoCoefficientSimilarity", 5, "GenericUserBasedRecommender", false)
recommender.data_model = JrubyMahout::DataModel.new("file", { :file_path => "ratings.csv" }).data_model

puts Benchmark.measure {
  6000.times do |x|
    puts x+1
    puts recommender.recommend(x+1, 10, nil).inspect
  end
}
