class AddingOperatorIdToConsultas < ActiveRecord::Migration
  def self.up
     add_column :consultas, :operador_id, :integer

  end

  def self.down
     drop_column :consultas, :operador_id
  end
end
