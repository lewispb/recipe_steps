describe "Journeys", type: :request do
  it "#create redirects to the first step" do
    post "/journey"
    expect(response).to redirect_to("/journey/1/steps/name/edit")
  end
end
