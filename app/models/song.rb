class Song < ActiveRecord::Base
  validates :title, presence: true
  validate :must_have_valid_release_date_if_released
  validate :must_not_release_same_song_twice_in_a_year

  def must_have_valid_release_date_if_released
    if released && release_year.nil?
      errors.add(:release_year, "has no release year")
    elsif released && release_year > Date.today.year
      errors.add(:release_year, "cannot be released in the future")
    end
  end

  def must_not_release_same_song_twice_in_a_year
    repeated = Song.all.any? do |song|
      song.title == title && song.release_year == release_year
    end

    if repeated
      errors.add(:title, "cannot be repeated twice in a year")
    end
  end
end
