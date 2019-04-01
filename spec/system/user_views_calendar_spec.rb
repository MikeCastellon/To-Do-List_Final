require "rails_helper"
 
RSpec.describe "viewing calendar", type: :system, js: true do
  let(:user){ User.create(email: "some@guy.com", password: "password") }
  before do
    user.tasks.create(description: "Last Month", due_date: 1.month.ago.to_date)
    user.tasks.create(description: "This Month", due_date: Date.today)
    user.tasks.create(description: "Next Month", due_date: 1.month.from_now.to_date)
    sign_in(user)
    visit calendar_path
  end
  context "when the user requests this month's tasks" do
    it "only shows this month's tasks" do
      expect(page).to have_text Date::MONTHNAMES[Date.today.month]
      expect(page).to have_text "This Month"
      expect(page).to_not have_text "Last Month"
      expect(page).to_not have_text "Next Month"
    end
  end
  context "when the user requests last month's tasks" do
    it "only shows last month's tasks" do
      find('#prev-month').click
 
      expect(page).to have_text Date::MONTHNAMES[1.month.ago.month]
      expect(page).to have_text "Last Month"
 
      expect(page).to_not have_text "This Month"
      expect(page).to_not have_text "Next Month"
    end
  end
  context "when the user requests next month's tasks" do
    it "only shows next month's tasks" do
      find('#next-month').click
 
      expect(page).to have_text Date::MONTHNAMES[1.month.from_now.month]
      expect(page).to have_text "Next Month"
 
      expect(page).to_not have_text "This Month"
      expect(page).to_not have_text "Last Month"
    end
  end
end
