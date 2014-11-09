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

class Yield::ThemesTest < ActiveSupport::TestCase

  def test_themes
    themes = Yield::Themes.themes
    assert_kind_of Array, themes
    assert_kind_of Yield::Themes::Theme, themes.first
  end

  def test_rescan
    Yield::Themes.themes.pop

    assert_difference 'Yield::Themes.themes.size' do
      Yield::Themes.rescan
    end
  end

  def test_theme_loaded
    theme = Yield::Themes.themes.last

    assert_equal theme, Yield::Themes.theme(theme.id)
  end

  def test_theme_loaded_without_rescan
    theme = Yield::Themes.themes.last

    assert_equal theme, Yield::Themes.theme(theme.id, :rescan => false)
  end

  def test_theme_not_loaded
    theme = Yield::Themes.themes.pop

    assert_equal theme, Yield::Themes.theme(theme.id)
  end

  def test_theme_not_loaded_without_rescan
    theme = Yield::Themes.themes.pop

    assert_nil Yield::Themes.theme(theme.id, :rescan => false)
  end
end
