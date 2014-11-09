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

require File.expand_path('../../test_helper', __FILE__)

class ActivityTest < ActiveSupport::TestCase
  fixtures :projects, :versions, :attachments, :users, :roles, :members, :member_roles, :issues, :journals, :journal_details,
           :trackers, :projects_trackers, :issue_statuses, :enabled_modules, :enumerations, :boards, :messages, :time_entries,
           :wikis, :wiki_pages, :wiki_contents, :wiki_content_versions

  def setup
    @project = Project.find(1)
  end

  def test_activity_without_subprojects
    events = find_events(User.anonymous, :project => @project)
    assert_not_nil events

    assert events.include?(Issue.find(1))
    assert !events.include?(Issue.find(4))
    # subproject issue
    assert !events.include?(Issue.find(5))
  end

  def test_activity_with_subprojects
    events = find_events(User.anonymous, :project => @project, :with_subprojects => 1)
    assert_not_nil events

    assert events.include?(Issue.find(1))
    # subproject issue
    assert events.include?(Issue.find(5))
  end

  def test_global_activity_anonymous
    events = find_events(User.anonymous)
    assert_not_nil events

    assert events.include?(Issue.find(1))
    assert events.include?(Message.find(5))
    # Issue of a private project
    assert !events.include?(Issue.find(4))
    # Private issue and comment
    assert !events.include?(Issue.find(14))
    assert !events.include?(Journal.find(5))
  end

  def test_global_activity_logged_user
    events = find_events(User.find(2)) # manager
    assert_not_nil events

    assert events.include?(Issue.find(1))
    # Issue of a private project the user belongs to
    assert events.include?(Issue.find(4))
  end

  def test_user_activity
    user = User.find(2)
    events = Yield::Activity::Fetcher.new(User.anonymous, :author => user).events(nil, nil, :limit => 10)

    assert(events.size > 0)
    assert(events.size <= 10)
    assert_nil(events.detect {|e| e.event_author != user})
  end

  def test_files_activity
    f = Yield::Activity::Fetcher.new(User.anonymous, :project => Project.find(1))
    f.scope = ['files']
    events = f.events

    assert_kind_of Array, events
    assert events.include?(Attachment.find_by_container_type_and_container_id('Project', 1))
    assert events.include?(Attachment.find_by_container_type_and_container_id('Version', 1))
    assert_equal [Attachment], events.collect(&:class).uniq
    assert_equal %w(Project Version), events.collect(&:container_type).uniq.sort
  end

  def test_event_group_for_issue
    issue = Issue.find(1)
    assert_equal issue, issue.event_group
  end

  def test_event_group_for_journal
    issue = Issue.find(1)
    journal = issue.journals.first
    assert_equal issue, journal.event_group
  end

  def test_event_group_for_issue_time_entry
    time = TimeEntry.where(:issue_id => 1).first
    assert_equal time.issue, time.event_group
  end

  def test_event_group_for_project_time_entry
    time = TimeEntry.where(:issue_id => nil).first
    assert_equal time, time.event_group
  end

  def test_event_group_for_message
    message = Message.find(1)
    reply = message.children.first
    assert_equal message, message.event_group
    assert_equal message, reply.event_group
  end

  def test_event_group_for_wiki_content_version
    content = WikiContent::Version.find(1)
    assert_equal content.page, content.event_group
  end

  private

  def find_events(user, options={})
    Yield::Activity::Fetcher.new(user, options).events(Date.today - 30, Date.today + 1)
  end
end
