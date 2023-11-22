class CreateDevices < ActiveRecord::Migration[7.0]
  def change
    create_table :devices do |t|
      t.string :ip
      t.string :url
      t.timestamps
    end
  end
end
