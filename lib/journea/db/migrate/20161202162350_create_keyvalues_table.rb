class CreateKeyvaluesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :journea_keyvalues do |t|
      t.integer :journey_id
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
