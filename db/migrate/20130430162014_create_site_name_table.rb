class CreateSiteNameTable < ActiveRecord::Migration
  def up
    create_table :site_names do |t|
      t.string :site_name
    end
  end

  def down
    drop_table :site_names
  end
end
