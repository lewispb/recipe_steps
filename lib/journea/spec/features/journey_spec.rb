RSpec.feature "User journeys through steps" do
  scenario "starts with the first step" do
    visit root_path
    click_link "Start now"
    expect(page).to have_content "enter your name"
    click_button "Continue"
    expect(page).to have_content "enter your address"
  end
end
