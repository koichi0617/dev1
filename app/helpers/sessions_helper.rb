module SessionsHelper

  #渡されてユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id  #sessionメソッドで作成した一時cookiesは自動的に暗号化される
  end

  #現在ログイン中のユーザーを返す
  def current_user
    if session[:user_id]
      #@current_userが存在すればそのまま、なければuser_idに基づいた情報
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  #ユーザーがログインしていればtrue、その他ならfalse
  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
