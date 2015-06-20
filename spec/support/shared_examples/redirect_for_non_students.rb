RSpec.shared_examples 'redirects for non-users' do
  # OPTIMIZE test actions other than 'index'

  shared_examples_for 'disallows access to students namespace' do
    skip
  end

  context 'as an admin' do
    skip
  end

  context 'as a guest' do
    it_behaves_like 'disallows access to students namespace'
  end

  context 'as a coach' do
    it_behaves_like 'disallows access to students namespace'
  end

  context 'as a mentor' do
    it_behaves_like 'disallows access to students namespace'
  end

  context 'as a student' do
    context 'who is not poart of an accepted team' do
      it_behaves_like 'disallows access to students namespace'
    end

    context 'who is part of an accepted team from last season' do
      it_behaves_like 'disallows access to students namespace'
    end
  end

end
