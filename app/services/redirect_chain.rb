# frozen_string_literal: true

class RedirectChain
  def initialize(record)
    @records = [record]

    find_all_records unless first_last_loop?
  end

  def first_last_loop?
    last_record.next_url == first_record.prev_url
  end

  def find_oldest_record
    @records.min_by(&:created_at)
  end

  def to_s
    urls = @records.map(&:prev_url)
    urls << last_record.next_url
    if urls.size > 6
      urls = urls.first(3) + ["#{urls.size - 6} nodes"] + urls.last(3)
    end
    urls.join(' -> ')
  end

  def size
    @records.size
  end

  def first_record
    @records.first
  end

  def last_record
    @records.last
  end

  private

  def find_all_records
    loop do
      next_record = find_next_record
      break unless next_record

      @records << next_record

      break if last_any_loop?
    end
  end

  def last_any_loop?
    @records.any? { |record| record.prev_url == last_record.next_url }
  end

  def find_next_record
    DeletedUrl.find_by(prev_url: last_record.next_url)
  end
end
