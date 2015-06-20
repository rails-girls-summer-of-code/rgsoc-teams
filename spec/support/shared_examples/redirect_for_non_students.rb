RSpec.shared_examples 'redirects for non-users' do
  # OPTIMIZE test actions other than 'index'

  context 'as an admin' do
    skip
  end

  context 'as a guest' do
    it 'redirects to / with an error message' do
      skip
    end
  end

  context 'as a coach' do
    it 'redirects to / with an error message' do
      skip
    end
  end

  context 'as a mentor' do
    it 'redirects to / with an error message' do
      skip
    end
  end

  context 'as a student' do
    context 'who is not poart of an accepted team' do
      it 'redirects to / with an error message' do
        skip
      end
    end

    context 'who is part of an accepted team from last season' do
      it 'redirects to / with an error message' do
        skip
      end
    end
  end

end
