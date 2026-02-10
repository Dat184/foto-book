namespace :counter_cache do
  desc "Reset all counter caches"
  task reset: :environment do
    puts "Resetting counter caches..."

    User.find_each do |user|
      User.reset_counters(user.id, :photos)
      User.reset_counters(user.id, :albums)
    end

    puts "Counter caches reset successfully!"
  end
end
