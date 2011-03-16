require 'digest/sha1'

class Usuario < ActiveRecord::Base
  
  attr_accessor :contrasenia_confirmation
  cattr_reader :per_page
  @@per_page = 10
  
	has_many :consultas	
	has_many :mensajes

	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "El mail ingresado no es correcto"
	validates_uniqueness_of :nomUsuario, :message => "Ya existe el usuario con ese nombre"
	validates_length_of :nombre, :within => 1..20, :message => "La cantidad de caracteres para nombre no puede ser mayor a 21 ni menor a 1"
	validates_length_of :apellido, :within => 1..25, :message => "La cantidad de caracteres para apellido no puede ser mayor a 21 ni menor a 1"
	validates_length_of :nomUsuario, :within => 1..20, :message => "La cantidad de caracteres para nombre de usuario no puede ser mayor a 21 ni menor a 1"
  validates_confirmation_of :contrasenia
  validate :contrasenia_no_vacia

  after_destroy :verificar_no_ultimo
  before_save :actualizar_fecha_ingreso

  private
  
  def muestraFecha(fecha)
    return fecha.strftime("%d/%m/%y %I:%M%p")
  end

  def contrasenia_no_vacia
    errors.add(:contrasenia, "Falta la contrasenia" ) if hashed_password.blank?
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def  verificar_no_ultimo
    if Usuario.count.zero?
      raise "No se puede borrar el ultimo usuario"
    end
  end

  public

  def actualizar_fecha_ingreso
    self.fechaIng=Time.now
  end
  
  def admitir
    if 1 > self.privilegio
      self.privilegio=1
      self.save
    end
  end

  def contrasenia
    @password
  end

  def contrasenia=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = Usuario.encrypted_password(self.contrasenia, self.salt)
  end

  def self.autenticar(name, password)
    user = self.find_by_nombre(name)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end
  
end