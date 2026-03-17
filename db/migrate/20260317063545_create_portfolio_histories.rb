class CreatePortfolioHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolio_histories do |t|
      t.date :date
      t.decimal :amount
      t.references :portfolio, null: false, foreign_key: true

      t.timestamps
    end
  end
end
