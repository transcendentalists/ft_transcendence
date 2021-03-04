class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
  
  def sendVerificationCode(user)
    verification_code = rand(100000..999999).to_s
    user.update(verification_code: verification_code)
    p user.email
    ActionMailer::Base.mail(to: user.email,
      subject: "[Transcendence] 2차 인증 메일입니다.",
      body: "인증번호는 [#{verification_code}] 입니다.",
      from: "valhalla.host@gmail.com",
      content_type: "text/html")
  end
end
