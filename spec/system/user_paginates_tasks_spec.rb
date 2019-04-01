require "rails_helper"

RSpec.describe "paginating tasks", type: :system, js: true do
  let(:user){ User.create!(email: "some@guy.com", password: "password") }
  before do
    (1..10).each{ |n| user.tasks.create(description: "Task #{n}") }
    sign_in user
    visit root_path
  end
  context "when the user visits the root_path" do
    it "displays the first five tasks" do
      expect(page).to have_text("Task 1")
      expect(page).to have_text("Task 2")
      expect(page).to have_text("Task 3")
      expect(page).to have_text("Task 4")
      expect(page).to have_text("Task 5")
      expect(page).to_not have_text("Task 6")
    end
  end
  context "when the user requests the second page" do
    before do
      click_button "Next"
    end
    it "displays the next five tasks" do
      expect(page).to have_text("Task 6")
      expect(page).to have_text("Task 7")
      expect(page).to have_text("Task 8")
      expect(page).to have_text("Task 9")
      expect(page).to have_text("Task 10")
      expect(page).to_not have_text("Task 5")
    end
    context "when the user requests completed tasks" do
      it "displays the second page of completed tasks" do
        (1..10).each{|n| user.tasks.create(description: "Completed Task #{n}", completed: true) }
        (1..10).each{|n| user.tasks.create(description: "Pending Task #{n}", completed: false) }

        visit root_path(status: "completed")
        sleep 1
        click_button "Next"

        expect(page).to have_text "Completed Task 6"
        expect(page).to have_text "Completed Task 7"
        expect(page).to have_text "Completed Task 8"
        expect(page).to have_text "Completed Task 9"
        expect(page).to have_text "Completed Task 10"
        expect(page).to_not have_text "Pending Task"
        expect(page).to_not have_text "Completed Task 5"
      end
      context "and the user requests past_due tasks" do
        it "displays the second page of completed past_due tasks" do
          (1..10).each{|n| user.tasks.create(description: "Past Due Completed Task #{n}", completed: true, due_date: Date.yesterday) }
          (1..10).each{|n| user.tasks.create(description: "Due Soon Completed Task #{n}", completed: true, due_date: Date.tomorrow) }
          (1..10).each{|n| user.tasks.create(description: "Pending Task #{n}", completed: false) }

          visit root_path(status: "completed")
          find('#menu-past-due').click
          sleep 1
          click_button "Next"

          expect(page).to have_text("Past Due Completed Task 6")
          expect(page).to have_text("Past Due Completed Task 7")
          expect(page).to have_text("Past Due Completed Task 8")
          expect(page).to have_text("Past Due Completed Task 9")
          expect(page).to have_text("Past Due Completed Task 10")
          expect(page).to_not have_text("Due Soon Completed Task")
          expect(page).to_not have_text("Pending Task")
        end
      end
    end
  end
end
