class CreateTranslations < ActiveRecord::Migration[6.0]
  def change
    create_table :translations do |t|
      t.string :locale
      t.string :key
      t.text   :value
      t.text   :interpolations
      t.boolean :is_proc, default: false # rubocop: disable Rails/ThreeStateBooleanColumn

      t.timestamps
    end
  end
end
