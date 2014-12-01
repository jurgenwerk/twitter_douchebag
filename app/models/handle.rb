class Handle
  include Mongoid::Document
  include Mongoid::Timestamps

  field :handle, type: String
  field :followed, type: Boolean, default: false
  field :unfollowed, type: Boolean, default: false
  field :followed_at, type: DateTime
  field :unfollowed_at, type: DateTime
end
