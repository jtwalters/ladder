class GameSerializer < ActiveModel::Serializer
  attributes :id, :tournament_id, :versus, :confirmed_at, :created_at, :updated_at, :image_url

  def image_url
    object.game_ranks.first.user.image_url(64)
  end
end