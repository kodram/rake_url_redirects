# frozen_string_literal: true

class CreateDeletedUrls < ActiveRecord::Migration[6.0]
  def change
    create_table 'deleted_urls', force: true do |t|
      t.string   'prev_url'
      t.string   'next_url'
      t.datetime 'created_at'
    end

    add_index(
      'deleted_urls',
      ['prev_url'],
      name: 'index_deleted_urls_on_prev_url',
      unique: true,
      using: :btree,
    )
  end
end
