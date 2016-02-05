class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :user_id
      t.string :location
      t.string :salary
      t.text :body
      t.boolean :interested
      t.boolean :contacted
      t.datetime :interview_date
      t.text :contacts
      t.text :company_info
      t.text :learn_technical
      t.text :build
      t.string :next_step
    end
  end
end
