# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

['Sanah Wills',
 'Alaw Calvert',
 'Hari Ashley',
 'Kira Hawes',
 'Biily Dawe',
 'Devin Senior',
 'Rizwan Shaw',
 'Finn Arias',
 'Zavier Henson',
 'Bodhi Goodwin'].each do |name|
   Member.create(name: name)
 end
