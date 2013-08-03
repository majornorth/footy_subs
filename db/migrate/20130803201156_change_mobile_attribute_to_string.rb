class ChangeMobileAttributeToString < ActiveRecord::Migration
  def up
  	change_table :users do |t|
      t.change :mobile, :string
    end
  end

  def down
  	change_table :users do |t|
      t.change :mobile, :integer
    end
  end
end
