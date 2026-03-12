class CreatePortfolios < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolios do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :label
      t.integer :portfolio_type
      t.decimal :amount

      t.timestamps
    end
  end
end
