require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user){ User.create!(email: "test@mail.com", password: "password") }
  describe ".completed" do
    it "returns only Current User's completed tasks" do
      completed = Task.create(description: "completed", completed: true, user: user)
      incomplete = Task.create(description: "incomplete", completed: false, user: user)

      expect(user.tasks.completed).to match_array([completed])
    end
  end
  describe ".pending" do
    it "returns only incomplete tasks" do
      completed = Task.create(description: "completed", completed: true, user: user)
      incomplete = Task.create(description: "incomplete", completed: false, user: user)

      expect(user.tasks.pending).to match_array([incomplete])
    end
  end
end
