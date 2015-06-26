class CreatePinnings < ActiveRecord::Migration
  def change
    create_table :pinnings do |t|
      t.references :user, index: true
      t.references :pin, index: true

      t.timestamps null: false
    end
    add_foreign_key :pinnings, :users
    add_foreign_key :pinnings, :pins

    Pin.where("user_id IS NOT NULL").each do |pin|
        puts "user present: #{User.find(pin.user_id)}"
        pin.pinnings.create(user: User.find(pin.user_id))
    end
  end
end
