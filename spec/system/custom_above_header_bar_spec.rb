# frozen_string_literal: true

RSpec.describe "Viewing the custom above header bar", type: :system do
  fab!(:theme) { upload_theme_component }

  it "should display the header bar with anonymous user content when not logged in" do
    theme.update_setting(:anon_banner_link, "/signup")
    theme.update_translation("anon_banner_text", "Welcome visitor!")
    theme.update_translation("anon_cta_text", "Join us")
    theme.save!

    visit("/")

    expect(page).to have_css(".custom-header-bar")
    expect(page).to have_content("Welcome visitor!")
    expect(page).to have_content("Join us")
    expect(page).to have_css(".custom-header-bar a[href='/signup']")
  end

  it "should display the header bar with member content when logged in" do
    user = Fabricate(:user)
    sign_in(user)

    theme.update_setting(:member_banner_link, "/guidelines")
    theme.update_translation("member_banner_text", "Welcome back!")
    theme.update_translation("member_cta_text", "Read guidelines")
    theme.save!

    visit("/")

    expect(page).to have_css(".custom-header-bar")
    expect(page).to have_content("Welcome back!")
    expect(page).to have_content("Read guidelines")
    expect(page).to have_css(".custom-header-bar a[href='/guidelines']")
  end

  it "should open links in new tab when open_in_new_tab setting is enabled for anonymous users" do
    theme.update_setting(:open_in_new_tab, true)
    theme.update_setting(:anon_banner_link, "https://external-site.com")
    theme.save!

    visit("/")

    expect(page).to have_css(".custom-header-bar a[target='_blank']")
  end

  it "should not open links in new tab when open_in_new_tab setting is disabled for anonymous users" do
    theme.update_setting(:open_in_new_tab, false)
    theme.update_setting(:anon_banner_link, "/internal-page")
    theme.save!

    visit("/")

    expect(page).to have_css(".custom-header-bar a")
    expect(page).to_not have_css(".custom-header-bar a[target='_blank']")
  end

  it "should respect user's external link preference when logged in" do
    user = Fabricate(:user)
    user.user_option.update!(external_links_in_new_tab: true)
    sign_in(user)

    theme.update_setting(:member_banner_link, "https://external-site.com")
    theme.save!

    visit("/")

    expect(page).to have_css(".custom-header-bar a[target='_blank']")
  end
end
