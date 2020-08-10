require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  #Homeページ内のリンクが正しいかのテスト
  test "layout links" do
    get root_path
    assert_template 'static_pages/home' #Homeページが正しいビューを描画しているかの確認
    assert_select "a[href=?]", root_path, count: 2 #?にはroot_pathが入る
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_select "title", full_title("アカウント登録")
  end
end
