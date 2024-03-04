module Types
  # User Type
  class UserType < BaseObject
    description 'User Type'

    field :id, ID, null: false, description: 'ID of the user'

    field :confirmed, Boolean, null: false, description: 'User is confirmed or not', method: :confirmed?
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'Date of creation of the user'
    field :email, String, null: false, description: 'Email of the user'
    field :name, String, null: false, description: 'Name of the user'
    field :username, String, null: false, description: 'Username of the user'
  end
end
