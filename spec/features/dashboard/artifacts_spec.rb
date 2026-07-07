require 'spec_helper'

describe "In the dashboard, Artifacts", type: :feature do
  let(:sample_html) { File.expand_path("../../../support/files/sample_artifact.html", __FILE__) }

  before do
    login_admin
  end

  it "shows an empty state when there are no artifacts" do
    visit storytime.dashboard_artifacts_path
    expect(page).to have_content("No artifacts yet")
  end

  it "creates an artifact by uploading an HTML file" do
    visit storytime.dashboard_artifacts_path
    click_link "New Artifact"

    fill_in "artifact_name", with: "Release Notes"
    attach_file "artifact_file", sample_html
    click_button "Create Artifact"

    expect(page).to have_content("Artifact created.")
    expect(page).to have_content("Release Notes")

    artifact = Storytime::Artifact.find_by(name: "Release Notes")
    expect(artifact).to be_present
    expect(artifact.content).to include("Sample artifact body")
    expect(artifact.byte_size).to be > 0
  end

  it "creates a password-protected, expiring artifact" do
    visit storytime.new_dashboard_artifact_path

    fill_in "artifact_name", with: "Gated"
    attach_file "artifact_file", sample_html
    fill_in "artifact_password", with: "hunter2"
    click_button "Create Artifact"

    expect(page).to have_content("Artifact created.")
    artifact = Storytime::Artifact.find_by(name: "Gated")
    expect(artifact).to be_password_protected
  end

  it "removes password protection from an existing artifact" do
    artifact = FactoryBot.create(:artifact, site: @current_site, user: current_user,
                                 name: "Was Gated", password: "hunter2")

    visit storytime.edit_dashboard_artifact_path(artifact.token)
    check "artifact_remove_password"
    click_button "Save Changes"

    expect(page).to have_content("Artifact updated.")
    expect(artifact.reload).not_to be_password_protected
  end

  it "edits an artifact's name" do
    artifact = FactoryBot.create(:artifact, site: @current_site, user: current_user, name: "Old Name")

    visit storytime.edit_dashboard_artifact_path(artifact.token)
    fill_in "artifact_name", with: "New Name"
    click_button "Save Changes"

    expect(page).to have_content("Artifact updated.")
    expect(artifact.reload.name).to eq("New Name")
  end

  it "deletes an artifact" do
    artifact = FactoryBot.create(:artifact, site: @current_site, user: current_user, name: "Doomed")

    visit storytime.dashboard_artifacts_path
    expect(page).to have_content("Doomed")

    click_link "Delete"

    expect(page).to have_content("Artifact deleted.")
    expect(Storytime::Artifact.find_by(token: artifact.token)).to be_nil
  end
end
