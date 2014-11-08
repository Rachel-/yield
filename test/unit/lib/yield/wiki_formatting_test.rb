# Yield - project management software
# Copyright (C) 2006-2014  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require File.expand_path('../../../../test_helper', __FILE__)

class Yield::WikiFormattingTest < ActiveSupport::TestCase
  fixtures :issues

  def test_textile_formatter
    assert_equal Yield::WikiFormatting::Textile::Formatter, Yield::WikiFormatting.formatter_for('textile')
    assert_equal Yield::WikiFormatting::Textile::Helper, Yield::WikiFormatting.helper_for('textile')
  end

  def test_null_formatter
    assert_equal Yield::WikiFormatting::NullFormatter::Formatter, Yield::WikiFormatting.formatter_for('')
    assert_equal Yield::WikiFormatting::NullFormatter::Helper, Yield::WikiFormatting.helper_for('')
  end

  def test_formats_for_select
    assert_include ['Textile', 'textile'], Yield::WikiFormatting.formats_for_select
  end

  def test_should_link_urls_and_email_addresses
    raw = <<-DIFF
This is a sample *text* with a link: http://www.yield.org
and an email address foo@example.net
DIFF

    expected = <<-EXPECTED
<p>This is a sample *text* with a link: <a class="external" href="http://www.yield.org">http://www.yield.org</a><br />
and an email address <a class="email" href="mailto:foo@example.net">foo@example.net</a></p>
EXPECTED

    assert_equal expected.gsub(%r{[\r\n\t]}, ''), Yield::WikiFormatting::NullFormatter::Formatter.new(raw).to_html.gsub(%r{[\r\n\t]}, '')
  end

  def test_supports_section_edit
    with_settings :text_formatting => 'textile' do
      assert_equal true, Yield::WikiFormatting.supports_section_edit?
    end

    with_settings :text_formatting => '' do
      assert_equal false, Yield::WikiFormatting.supports_section_edit?
    end
  end

  def test_cache_key_for_saved_object_should_no_be_nil
    assert_not_nil Yield::WikiFormatting.cache_key_for('textile', 'Text', Issue.find(1), :description)
  end
end
