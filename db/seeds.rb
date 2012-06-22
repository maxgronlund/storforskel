# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create(:email => "max@storforskel.nu" , :name => 'Max Grønlund', :password => 'rosalina', :role => 'super')
User.create(:email => "morten@storforskel.nu" , :name => 'Morten Toft', :password => '123456', :role => 'admin')
User.create(:email => "mariane@tuekeramik.dk" , :name => 'Marianne', :password => '123456', :role => 'admin')

