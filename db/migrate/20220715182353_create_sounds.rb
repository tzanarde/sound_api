class CreateSounds < ActiveRecord::Migration[7.0]
  def change
    create_table :sounds do |t|
      t.string :name
      t.integer :duration
      # t.references :created_by, foreign_key: { to_table: 'users' }
      t.references :user
      t.string :file_url
      t.timestamps
    end
  end
end
