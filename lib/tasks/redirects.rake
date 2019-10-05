# frozen_string_literal: true

namespace :redirects do
  def rand_time(from, to = Time.now)
    Time.at(rand_in_range(from.to_f, to.to_f))
  end

  def rand_in_range(from, to)
    rand * (to - from) + from
  end

  def generate_url(num)
    "url_#{num}"
  end

  desc 'Data generation'
  task data_generation: :environment do
    RECORD_COUNT = 3_000
    DeletedUrl.delete_all

    deleted_urls_data = (1..RECORD_COUNT).map do |index|
      next_index = rand(RECORD_COUNT)
      next_index += 1 if index == next_index

      {
        prev_url: generate_url(index),
        next_url: generate_url(next_index),
        created_at: rand_time(1.year.ago),
      }
    end

    DeletedUrl.insert_all(deleted_urls_data)
  end

  desc 'Removal of cyclic'
  task removal_cyclic: :environment do
    puts "Total #{DeletedUrl.count} records"

    DeletedUrl.find_in_batches.with_index do |group, batch|
      puts "Processing #{batch + 1} thousand records"

      group.each do |record|
        chain = RedirectChain.new(record)
        next unless chain.first_last_loop?

        puts "find loop: #{chain}"
        oldest_record = chain.find_oldest_record
        puts "delete #{oldest_record.inspect}"
        oldest_record.destroy
      end
    end
  end

  desc 'Reduction of long chains'
  task reduction_long_chains: :environment do
    puts "Total #{DeletedUrl.count} records"

    DeletedUrl.find_in_batches.with_index do |group, batch|
      puts "Processing #{batch + 1} thousand records"

      group.each do |record|
        chain = RedirectChain.new(record)

        next unless chain.size > 10

        puts ''
        puts "chain (size: #{chain.size}): #{chain}"

        first_record = chain.first_record
        last_record = chain.last_record

        first_record.update(next_url: last_record.next_url)
        puts "after update: #{first_record.inspect}"
      end
    end
  end
end
