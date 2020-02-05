require_relative 'src/Program.rb'

program = Program.new
program.run()
program.export("output/DatosMarco_v03.csv")