require 'rails_helper'

RSpec.describe Matter, type: :model do
  let(:user) { create(:user) }
  let(:matter) { create(:matter, user: user) }

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:state) }
    it { should validate_inclusion_of(:state).in_array(%w[new in_progress completed]) }
  end

  describe 'scopes' do
    let!(:pending_matter) { create(:matter, state: 'new', user: user) }
    let!(:in_progress_matter) { create(:matter, state: 'in_progress', user: user) }
    let!(:completed_matter) { create(:matter, state: 'completed', user: user) }
    let!(:due_today_matter) { create(:matter, due_date: Time.current, user: user) }
    let!(:overdue_matter) { create(:matter, due_date: 1.day.ago, state: 'new', user: user) }

    describe '.pending' do
      it 'returns matters with new state' do
        expect(Matter.pending).to include(pending_matter)
        expect(Matter.pending).not_to include(in_progress_matter, completed_matter)
      end
    end

    describe '.in_progress' do
      it 'returns matters with in_progress state' do
        expect(Matter.in_progress).to include(in_progress_matter)
        expect(Matter.in_progress).not_to include(pending_matter, completed_matter)
      end
    end

    describe '.completed' do
      it 'returns matters with completed state' do
        expect(Matter.completed).to include(completed_matter)
        expect(Matter.completed).not_to include(pending_matter, in_progress_matter)
      end
    end

    describe '.due_today' do
      it 'returns matters due today' do
        expect(Matter.due_today).to include(due_today_matter)
      end
    end

    describe '.overdue' do
      it 'returns matters past due date' do
        expect(Matter.overdue).to include(overdue_matter)
      end
    end
  end

  describe 'instance methods' do
    describe '#pending?' do
      it 'returns true when state is new' do
        matter.state = 'new'
        expect(matter.pending?).to be true
      end

      it 'returns false when state is not new' do
        matter.state = 'completed'
        expect(matter.pending?).to be false
      end
    end

    describe '#in_progress?' do
      it 'returns true when state is in_progress' do
        matter.state = 'in_progress'
        expect(matter.in_progress?).to be true
      end

      it 'returns false when state is not in_progress' do
        matter.state = 'new'
        expect(matter.in_progress?).to be false
      end
    end

    describe '#completed?' do
      it 'returns true when state is completed' do
        matter.state = 'completed'
        expect(matter.completed?).to be true
      end

      it 'returns false when state is not completed' do
        matter.state = 'new'
        expect(matter.completed?).to be false
      end
    end

    describe '#overdue?' do
      it 'returns true when due_date is past and not completed' do
        matter.update(due_date: 1.day.ago, state: 'new')
        expect(matter.overdue?).to be true
      end

      it 'returns false when completed' do
        matter.update(due_date: 1.day.ago, state: 'completed')
        expect(matter.overdue?).to be false
      end

      it 'returns false when no due_date' do
        matter.update(due_date: nil, state: 'new')
        expect(matter.overdue?).to be false
      end
    end

    describe '#mark_in_progress!' do
      it 'updates state to in_progress' do
        matter.mark_in_progress!
        expect(matter.reload.state).to eq('in_progress')
      end
    end

    describe '#mark_completed!' do
      it 'updates state to completed' do
        matter.mark_completed!
        expect(matter.reload.state).to eq('completed')
      end
    end
  end
end
