require "rails_helper"

RSpec.describe "viewing tasks", type: :system, js: true do
  let(:user){ User.create!(email: "some@guy.com", password: "password") }
  before do
    sign_in user
  end
  it "displays the tasks ordered by due date, with tasks without due dates last" do
    not_due   = user.tasks.create(description: "Not Due", due_date: nil)
    due_later = user.tasks.create(description: "Due Later", due_date: 10.days.from_now.to_date)
    due_soon  = user.tasks.create(description: "Due Soon", due_date: 3.days.from_now.to_date)
    past_due  = user.tasks.create(description: "Past Due", due_date: 3.days.ago.to_date)

    visit root_path

    within "tbody tr:nth-child(1)" do
      expect(page).to have_text past_due.description
    end
    within "tbody tr:nth-child(2)" do
      expect(page).to have_text due_soon.description
    end
    within "tbody tr:nth-child(3)" do
      expect(page).to have_text due_later.description
    end
    within "tbody tr:nth-child(4)" do
      expect(page).to have_text not_due.description
    end
  end
  context "when a task is past due" do
    it "displays the due_date in red" do
      task = user.tasks.create(description: "past due", due_date: 1.day.ago.to_date)
      visit root_path
      sleep 1

      color = find("#task_#{task.id} .due_date").native.css_value('background-color')
      expect(color).to eq('rgba(220, 53, 69, 1)')
    end
  end
  context "when a task is due soon" do
    it "displays the due_date in yellow" do
      task = user.tasks.create(description: "due soon", due_date: Date.tomorrow)
      visit root_path
      sleep 1

      color = find("#task_#{task.id} .due_date").native.css_value('background-color')
      expect(color).to eq('rgba(255, 193, 7, 1)')
    end
  end
  context "when a task is due later" do
    it "displays the due_date in green" do
      task = user.tasks.create(description: "due later", due_date: 10.days.from_now.to_date)
      visit root_path
      sleep 1

      color = find("#task_#{task.id} .due_date").native.css_value('background-color')
      expect(color).to eq('rgba(40, 167, 69, 1)')
    end
  end
end
