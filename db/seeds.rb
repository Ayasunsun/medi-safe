# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Cleaning up start"
TaskTemplate.destroy_all
NurseTask.destroy_all
Patient.destroy_all
Doctor.destroy_all
puts "Cleaning up done"

# ---------------------------------------------
# Doctors
# name contact specialty
require 'faker'

SPECIALTIES = %w( gastroenterologists pulmonologists gynecologists surgeon )
puts "Creating doctors"
6.times do
  params = {}
  params[:name] = Faker::Name.name
  params[:contact] = Faker::PhoneNumber.cell_phone
  params[:specialty] = SPECIALTIES.sample
  new_doctor = Doctor.new(params)
  puts "Created doctor #{new_doctor.id}" if new_doctor.save
end
puts "Finished creating doctors"

# ---------------------------------------------
# Patients
# name gender age severity room bed doctor
GENDERS = %w( male female )
EMERGENCY = ['Low Care', 'Medium Care', 'High Care']
puts "Creating patients"
30.times do
  params = {}
  params[:name] = Faker::Name.name
  params[:gender] = GENDERS.sample
  params[:age] = rand(15..80)
  params[:room] = "#{rand(1..7)}#{rand(0..1)}#{rand(1..9)}"
  params[:bed] = "0#{rand(1..8)}"
  params[:severity] = EMERGENCY.sample
  params[:doctor] = Doctor.all.sample
  new_patient = Patient.new(params)
  puts "Created patient #{new_patient.id}" if new_patient.save
end
puts "Finished creating patients"

# ---------------------------------------------
# Task template
# frequency patient(ref) active task(ref)

puts "Creating task templates"
Patient.all.each do |patient|
  8.times do
    params = {}
    params[:frequency] = rand(1..3)
    params[:patient] = patient
    params[:active] = true
    params[:task] = Task.all.rand
    new_task_template = TaskTemplate.new(params)
    puts "Created task template #{new_task_template.id}" if new_task_template.save
  end
end
puts "Finished creating task templates"

# ---------------------------------------------
# Nurse tasks
# note completed(default false) task_template(ref) user_id(ref)

puts "Creating nurse tasks"
TaskTemplate.all.each do |task_template|
  params = {}
  params[:user] = User.where(:leader? false).sample
  task_template.frequency.times do
    params[:complete] = false
    params[:task_template] = task_template
    new_nurse_task = NurseTask.new(params)
    puts "Created nurse task #{new_nurse_task.id}" if new_nurse_task.save
  end
end
puts "Finished creating nurse tasks"
