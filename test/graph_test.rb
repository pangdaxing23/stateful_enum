# frozen_string_literal: true

require 'test_helper'

class GraphTest < ActiveSupport::TestCase
  def test_graph
    FileUtils.rm_f Rails.root.join('Bug_status.png')
    FileUtils.rm_f Rails.root.join('.smdconfig')

    Dir.chdir Rails.root do
      `rails g stateful_enum:graph bug`
    end

    assert File.exist?(Rails.root.join('Bug_status.png'))
  end

  def test_graph_to_a_relative_dest_dir
    FileUtils.rm_f Rails.root.join('tmp', 'Bug_status.png')

    Dir.chdir Rails.root do
      `DEST_DIR=tmp rails g stateful_enum:graph bug`
    end

    assert File.exist?(Rails.root.join('tmp', 'Bug_status.png'))
  end

  def test_graph_to_an_absolute_dest_dir
    FileUtils.rm_f Rails.root.join('doc', 'Bug_status.png')

    Dir.chdir Rails.root do
      `DEST_DIR=#{Rails.root.join('doc')} rails g stateful_enum:graph bug`
    end

    assert File.exist?(Rails.root.join('doc', 'Bug_status.png'))
  end

  def test_graph_of_multiple_enums
    FileUtils.rm_f Rails.root.join('User_account_status.png')
    FileUtils.rm_f Rails.root.join('User_player_status.png')
    FileUtils.rm_f Rails.root.join('.smdconfig')

    Dir.chdir Rails.root do
      `rails g stateful_enum:graph user`
    end

    assert File.exist?(Rails.root.join('User_account_status.png'))
    assert File.exist?(Rails.root.join('User_player_status.png'))
  end
end
