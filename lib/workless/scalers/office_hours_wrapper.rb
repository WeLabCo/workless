require 'active_support/time'

module Delayed
  module Workless
    module Scaler
      class OfficeHoursWrapper < Base
        class << self
          attr_accessor :scaler

          def up
            scaler.up
          end

          def down
            day = Date.current.wday
            hour = Time.current.hour
            return if office_days.include?(day) and office_hours.include?(hour)
            scaler.down
          end

          private

          def office_hours
            Range.new(*(ENV['WORKLESS_OFFICE_HOURS'].split('..').map(&:to_i)), true)
          end

          def office_days
            Range.new(*(ENV['WORKLESS_OFFICE_DAYS'].split('..').map(&:to_i)))
          end
        end
      end
    end
  end
end
