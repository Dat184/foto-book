namespace :counter_cache do
  desc "Reset all counter caches"
  task reset: :environment do
    puts "Resetting counter caches..."

    User.find_each do |user|
      User.reset_counters(user.id, :photos)
      User.reset_counters(user.id, :albums)

      # Reset following_count and followers_count manually
      user.update_columns(
        following_count: user.active_follows.count,
        followers_count: user.passive_follows.count
      )
    end

    puts "Counter caches reset successfully!"
  end
end
