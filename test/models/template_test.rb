# frozen_string_literal: true

require 'test_helper'

class TemplateTest < ActiveSupport::TestCase
  setup do
    @template = templates(:users)
  end

  test 'add newline body_header' do
    @template.update(body_header: 'テストヘッダ')
    assert_equal "テストヘッダ\n", Template.find(@template.id).body_header
  end

  test 'add newline body_footer' do
    @template.update(body_footer: 'テストフッタ')
    assert_equal "テストフッタ\n", Template.find(@template.id).body_footer
  end

  test 'NO add newline body_header with newline' do
    @template.update(body_header: "テストヘッダ2\n")
    assert_equal "テストヘッダ2\n", Template.find(@template.id).body_header
  end

  test 'NO add newline body_footer with newline' do
    @template.update(body_footer: "テストフッタ2\n")
    assert_equal "テストフッタ2\n", Template.find(@template.id).body_footer
  end

  test 'NO add newline EMPTY body_header' do
    @template.update(body_header: '')
    assert_equal '', Template.find(@template.id).body_header
  end

  test 'NO add newline EMPTY body_footer' do
    @template.update(body_footer: '')
    assert_equal '', Template.find(@template.id).body_footer
  end

  test 'han zen from_name' do
    @template.update(from_name: 'ﾊﾝｶｸｶﾀｶﾅ')
    assert_equal 'ハンカクカタカナ', Template.find(@template.id).from_name
  end

  test 'han zen subject_prefix' do
    @template.update(subject_prefix: 'ﾊﾝｶｸｶﾀｶﾅ')
    assert_equal 'ハンカクカタカナ', Template.find(@template.id).subject_prefix
  end

  test 'han zen subject_suffix' do
    @template.update(subject_suffix: 'ﾊﾝｶｸｶﾀｶﾅ')
    assert_equal 'ハンカクカタカナ', Template.find(@template.id).subject_suffix
  end

  test 'han zen body_header' do
    @template.update(body_header: "ﾊﾝｶｸｶﾀｶﾅ\n")
    assert_equal "ハンカクカタカナ\n", Template.find(@template.id).body_header
  end

  test 'han zen body_footer' do
    @template.update(body_footer: "ﾊﾝｶｸｶﾀｶﾅ\n")
    assert_equal "ハンカクカタカナ\n", Template.find(@template.id).body_footer
  end

end
