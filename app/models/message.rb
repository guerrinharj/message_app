class Message < ApplicationRecord
    belongs_to :sender, class_name: "User"
    belongs_to :receiver, class_name: "User"

    has_many_attached :files

    validates :content, presence: true, unless: -> { files.attached? }
end
