class CreateSocialProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :social_profiles do |t|
      t.string :provider
      t.string :uid
      t.string :email
      t.string :url
      t.string :access_token
      t.string :access_secret
      t.references :user, foreign_key: true


      t.timestamps
    end
    add_index :social_profiles, [:provider, :uid], unique: true
  end
end
