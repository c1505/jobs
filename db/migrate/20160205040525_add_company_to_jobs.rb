class AddCompanyToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :company, :text
  end
end
