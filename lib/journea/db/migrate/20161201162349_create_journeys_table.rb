class CreateJourneysTable < ActiveRecord::Migration[5.0]
  def change
    create_table :journea_journeys do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
