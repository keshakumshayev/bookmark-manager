require './app/app'

feature 'Viewing links' do

  scenario 'I can see existing links on the links page' do
    Link.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')
    visit '/links'
    expect(page.status_code).to eq 200
    within 'ol#links' do
      expect(page).to have_content('Makers Academy')
    end
  end
end

feature 'creating links' do
  scenario 'i can create a new link' do
    visit '/links/new'
    fill_in('url', with: 'http://zombo.com')
    fill_in('title', with: 'Zombo')
    click_button('Create link')

    expect(current_path).to eq '/links'

    within 'ol#links' do
      expect(page).to have_content('Zombo')
    end
  end
end

feature 'Adding tags' do

  scenario 'I can add a single tag to a new link' do
    visit '/links/new'
    fill_in 'url',   with: 'http://www.makersacademy.com/'
    fill_in 'title', with: 'Makers Academy'
    fill_in 'tags',  with: 'education'

    click_button 'Create link'
    # binding.pry

    link = Link.first
    expect(link.tags.map(&:name)).to include('education')
  end

end


feature 'filtering by tags' do
  scenario 'I can add filter all links tagged \'bubbles\'' do
    visit '/links/new'
    fill_in 'url',   with: 'http://www.shower.com/'
    fill_in 'title', with: 'Sadness'
    fill_in 'tags',  with: 'no bubbles'
    click_button 'Create link'

    click_link 'Add a bookmark'

    fill_in 'url',   with: 'http://www.bubblebath.com/'
    fill_in 'title', with: 'Bubble Bath'
    fill_in 'tags',  with: 'bubbles'
    click_button 'Create link'

    visit '/links/bubbles'
    expect(page).to have_content('bubbles')
    expect(page).to have_no_content('no bubbles')
  end
end

feature 'adding multiple tags' do
  scenario 'I can add link with multiple tags' do
    visit '/links/new'
    fill_in 'url',   with: 'http://www.bubblebath.com/'
    fill_in 'title', with: 'Bubble Bath'
    fill_in 'tags',  with: 'bubbles,yes'
    click_button 'Create link'
    expect(page).to have_content('bubbles; yes')
  end
end

feature 'User account' do
  scenario 'home page has a sign up button' do
    visit '/'
    click_link("Sign Up")
    expect(page).to have_content('Welcome to Bookmark Manager. Enter your information to sign up')
  end

  scenario 'home page has a sign in button' do
    visit '/'
    click_link("Sign In")
    expect(page).to have_content('Enter your login information to sign in')
  end
end

feature 'User sign up' do
  scenario 'I can sign up as a new user' do
    expect{ sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, example@gmail.com')
    expect(User.first.email).to eq('example@gmail.com')
  end
end
