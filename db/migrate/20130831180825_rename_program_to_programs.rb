class RenameProgramToPrograms < ActiveRecord::Migration
  def change
    rename_table :program, :programs
  end
end
