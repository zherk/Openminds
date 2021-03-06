class CreateImagenes < ActiveRecord::Migration
  def self.up
    create_table :imagenes do |t|
      t.column :content_type, :string, :null => false
      t.column :archivo, :string, :null => false
      t.column :datos_binarios, :binary, :null => false
      t.column :mensaje_id, :integer
    end
  end

  def self.down
    drop_table :imagenes
  end
end
