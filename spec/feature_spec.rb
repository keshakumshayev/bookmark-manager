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
    link = Link.first
    expect(link.tags.map(&:name)).to include('education')
  end

end
