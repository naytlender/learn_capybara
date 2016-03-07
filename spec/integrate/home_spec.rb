require 'rails_helper'

describe 'items page' do
  it 'lists the items' do
    visit '/items'
    page.should have_content('Listing Items')
  end
end

describe 'new item page' do
  it 'should not create item with empty name', js: true do
    visit '/items/new'
    fill_in 'name', :with => ''
    click_on 'Create Item'
    error_text = find(:xpath, '//form/div/ul/li').text
    expect(error_text).to eq "Name can't be blank"

    uri = URI(current_url)
    uri.path.should eq '/items'
  end

  it 'lets the user to create item with a name', :js => true do
    visit '/items/new'
    fill_in 'name', :with => 'Test item'
    click_on 'Create Item'
    expect(page).to have_content('Item was successfully created.')
    expect(page).to have_content('Item name: Test item')
  end
end

describe 'items page' do
  it 'have content show, edit and delete', js: true do
    visit '/items'
    page.has_selector?(:xpath, '//table/tbody/td')

    expect(page).to have_content('Show')
    expect(page).to have_content('Destroy')
    expect(page).to have_content('Edit')
  end
end

describe 'show item page' do
  it 'should let user delete items', js: true do
    visit '/items'
    first(:xpath, '//a', 'Show').click

    find(:xpath, '//a[text()="Delete"]').click
    text = page.driver.browser.switch_to.alert.text
    expect(text).to eq 'Are you sure?'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content('Item was successfully destroyed.')
    
    uri = URI(current_url)
    uri.path.should eq '/items'
  end
end

describe 'edit item page' do
  it 'should edit current item name', js: true do
    visit '/items'
    first(:xpath, '//a[text()="Edit"]').click
    fill_in 'item_name', with: "Edited name"
    click_on 'Update Item'
    expect(page).to have_content "Item was successfully updated."
  end
end