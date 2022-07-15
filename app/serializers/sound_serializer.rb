class SoundSerializer < ActiveModel::Serializer
  attributes :id, :name, :user

  def user
    object.user
  end
end
