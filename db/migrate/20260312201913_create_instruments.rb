class CreateInstruments < ActiveRecord::Migration[7.1]
  def change
    create_table :instruments do |t|
      t.string :isin
      t.integer :instrument_type
      t.string :label
      t.decimal :price
      t.integer :sri

      t.timestamps
    end
  end
end
