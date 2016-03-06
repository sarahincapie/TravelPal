class AddUserRefToFriends < ActiveRecord::Migration
  def change
    add_reference :friends, :user, index: true, foreign_key: true
  end
end
