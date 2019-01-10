class CreateJourneyTransitions < ActiveRecord::Migration[5.0]
  def change
    create_table :journea_journey_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata, default: "{}"
      t.integer :sort_key, null: false
      t.integer :journey_id, null: false
      t.boolean :most_recent, null: false
      t.timestamps null: false
    end

    add_index(:journea_journey_transitions,
              [:journey_id, :sort_key],
              unique: true,
              name: "index_journey_transitions_parent_sort")
    add_index(:journea_journey_transitions,
              [:journey_id, :most_recent],
              unique: true,
              where: "most_recent",
              name: "index_journey_transitions_parent_most_recent")
  end
end
