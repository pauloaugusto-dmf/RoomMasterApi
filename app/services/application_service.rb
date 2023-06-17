class ApplicationService
  include ActiveModel::Validations

  Result = Struct.new(:success?, :data, :error)

  def self.call(...)
    new(...).call
  end
end
