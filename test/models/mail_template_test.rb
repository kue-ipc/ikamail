require "test_helper"

class MailTemplateTest < ActiveSupport::TestCase
  setup do
    @mail_template = mail_templates(:users)
  end

  test "add newline body_header" do
    @mail_template.update(body_header: "テストヘッダ")
    assert_equal "テストヘッダ\n", MailTemplate.find(@mail_template.id).body_header
  end

  test "add newline body_footer" do
    @mail_template.update(body_footer: "テストフッタ")
    assert_equal "テストフッタ\n", MailTemplate.find(@mail_template.id).body_footer
  end

  test "NO add newline body_header with newline" do
    @mail_template.update(body_header: "テストヘッダ2\n")
    assert_equal "テストヘッダ2\n", MailTemplate.find(@mail_template.id).body_header
  end

  test "NO add newline body_footer with newline" do
    @mail_template.update(body_footer: "テストフッタ2\n")
    assert_equal "テストフッタ2\n", MailTemplate.find(@mail_template.id).body_footer
  end

  test "NO add newline EMPTY body_header" do
    @mail_template.update(body_header: "")
    assert_equal "", MailTemplate.find(@mail_template.id).body_header
  end

  test "NO add newline EMPTY body_footer" do
    @mail_template.update(body_footer: "")
    assert_equal "", MailTemplate.find(@mail_template.id).body_footer
  end

  test "han zen from_name" do
    @mail_template.update(from_name: "ﾊﾝｶｸｶﾀｶﾅ")
    assert_equal "ハンカクカタカナ", MailTemplate.find(@mail_template.id).from_name
  end

  test "han zen subject_prefix" do
    @mail_template.update(subject_prefix: "ﾊﾝｶｸｶﾀｶﾅ")
    assert_equal "ハンカクカタカナ", MailTemplate.find(@mail_template.id).subject_prefix
  end

  test "han zen subject_suffix" do
    @mail_template.update(subject_suffix: "ﾊﾝｶｸｶﾀｶﾅ")
    assert_equal "ハンカクカタカナ", MailTemplate.find(@mail_template.id).subject_suffix
  end

  test "han zen body_header" do
    @mail_template.update(body_header: "ﾊﾝｶｸｶﾀｶﾅ\n")
    assert_equal "ハンカクカタカナ\n", MailTemplate.find(@mail_template.id).body_header
  end

  test "han zen body_footer" do
    @mail_template.update(body_footer: "ﾊﾝｶｸｶﾀｶﾅ\n")
    assert_equal "ハンカクカタカナ\n", MailTemplate.find(@mail_template.id).body_footer
  end
end
