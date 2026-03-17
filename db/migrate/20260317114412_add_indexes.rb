class AddIndexes < ActiveRecord::Migration[7.1]
  def change
    add_index :holdings, [:portfolio_id, :instrument_id], unique: true
    add_index :portfolio_histories, [:portfolio_id, :date]
    add_index :instruments, :isin, unique: true
  end
end
