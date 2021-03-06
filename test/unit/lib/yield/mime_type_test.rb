# Yield - project management software
# Copyright (C) 2014  Hardpixel
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

class Yield::MimeTypeTest < ActiveSupport::TestCase

  def test_of
    to_test = {'test.unk' => nil,
               'test.txt' => 'text/plain',
               'test.c' => 'text/x-c',
               }
    to_test.each do |name, expected|
      assert_equal expected, Yield::MimeType.of(name)
    end
  end

  def test_css_class_of
    to_test = {'test.unk' => nil,
               'test.txt' => 'text-plain',
               'test.c' => 'text-x-c',
               }
    to_test.each do |name, expected|
      assert_equal expected, Yield::MimeType.css_class_of(name)
    end
  end

  def test_main_mimetype_of
    to_test = {'test.unk' => nil,
               'test.txt' => 'text',
               'test.c' => 'text',
               }
    to_test.each do |name, expected|
      assert_equal expected, Yield::MimeType.main_mimetype_of(name)
    end
  end

  def test_is_type
    to_test = {['text', 'test.unk'] => false,
               ['text', 'test.txt'] => true,
               ['text', 'test.c'] => true,
               }
    to_test.each do |args, expected|
      assert_equal expected, Yield::MimeType.is_type?(*args)
    end
  end

  def test_should_default_to_mime_type_gem
    assert !Yield::MimeType::EXTENSIONS.keys.include?("zip")
    assert_equal "application/zip", Yield::MimeType.of("file.zip")
  end
end
